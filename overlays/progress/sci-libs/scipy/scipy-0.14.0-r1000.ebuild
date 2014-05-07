# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit distutils eutils flag-o-matic fortran-2 multilib toolchain-funcs

MY_P="${PN}-${PV/_/}"
DOC_P="${PN}-0.13.0"

DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="http://www.scipy.org/ https://github.com/scipy/scipy https://pypi.python.org/pypi/scipy"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	doc? (
		http://docs.scipy.org/doc/${DOC_P}/${PN}-html.zip -> ${DOC_P}-html.zip
		http://docs.scipy.org/doc/${DOC_P}/${PN}-ref.pdf -> ${DOC_P}-ref.pdf
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc sparse test"
KEYWORDS="*"

CDEPEND="$(python_abi_depend dev-python/numpy[lapack])
	sci-libs/arpack:0=
	virtual/cblas
	virtual/lapack
	sparse? ( sci-libs/umfpack:0= )"
DEPEND="${CDEPEND}
	dev-lang/swig
	>=dev-python/cython-0.19
	virtual/pkgconfig
	test? ( $(python_abi_depend dev-python/nose) )"
RDEPEND="${CDEPEND}
	$(python_abi_depend dev-python/imaging)"

S="${WORKDIR}/${MY_P}"

DOCS="THANKS.txt"

pkg_setup() {
	fortran-2_pkg_setup
	python_pkg_setup
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use doc; then
		unzip -qo "${DISTDIR}/${DOC_P}-html.zip" -d html || die
	fi
}

pc_incdir() {
	$(tc-getPKG_CONFIG) --cflags-only-I $@ | \
		sed -e 's/^-I//' -e 's/[ ]*-I/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
		sed -e 's/^-L//' -e 's/[ ]*-L/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

pc_libs() {
	$(tc-getPKG_CONFIG) --libs-only-l $@ | \
		sed -e 's/[ ]-l*\(pthread\|m\)\([ ]\|$\)//g' \
		-e 's/^-l//' -e 's/[ ]*-l/,/g' -e 's/[ ]*$//' \
		| tr ',' '\n' | sort -u | tr '\n' ',' | sed -e 's|,$||'
}

src_prepare() {
	# Support Python 3.1.
	sed -e "/sys.version_info/s/(3, 2)/(3, 1)/" -i setup.py

	# scipy automatically detects libraries by default
	export {FFTW,FFTW3,UMFPACK}=None
	use sparse && unset UMFPACK
	# the missing symbols are in -lpythonX.Y, but since the version can
	# differ, we just introduce the same scaryness as on Linux/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
	[[ -z ${FC}  ]] && export FC="$(tc-getFC)"
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77="$(tc-getFC)"
	export F90="${FC}"
	export SCIPY_FCONFIG="config_fc --noopt --noarch"
	append-fflags -fPIC

	local libdir="${EPREFIX}"/usr/$(get_libdir)
	cat >> site.cfg <<-EOF
		[blas]
		include_dirs = $(pc_incdir cblas)
		library_dirs = $(pc_libdir cblas blas):${libdir}
		blas_libs = $(pc_libs cblas blas)
		[lapack]
		library_dirs = $(pc_libdir lapack):${libdir}
		lapack_libs = $(pc_libs lapack)
	EOF

	# Regenerate Cython-generated files.
	eshopts_push -s extglob
	local file
	for file in $(grep -El "^/\* Generated by Cython .* \*/$" **/*.@(c|cxx)); do
		python_execute cython $([[ ${file} == *.cxx ]] && echo --cplus) ${file%.*}.pyx -o ${file} || die "Cythonization of ${file%.*}.pyx failed"
	done
	eshopts_pop
}

distutils_src_compile_post_hook() {
	if [[ "$(python_get_version -l)" == "3.1" ]]; then
		2to3-${PYTHON_ABI} -f callable -nw --no-diffs build-${PYTHON_ABI}/lib*
	fi
}

src_compile() {
	distutils_src_compile ${SCIPY_FCONFIG}
}

src_test() {
	testing() {
		python_execute "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --home="${S}/test-${PYTHON_ABI}" --no-compile ${SCIPY_FCONFIG} || die "Installation for tests failed with $(python_get_implementation_and_version)"
		pushd "${S}/test-${PYTHON_ABI}/"lib*/python > /dev/null
		python_execute PYTHONPATH="." "$(PYTHON)" -c "import scipy, sys; sys.exit(not scipy.test('full', verbose=3).wasSuccessful())" || return
		popd > /dev/null
		rm -fr test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install ${SCIPY_FCONFIG}

	if use doc; then
		dohtml -r "${WORKDIR}/html/"
		dodoc "${DISTDIR}/${DOC_P}-ref.pdf"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "You might want to set the variable SCIPY_PIL_IMAGE_VIEWER"
	elog "to your prefered image viewer. Example:"
	elog "\t echo \"export SCIPY_PIL_IMAGE_VIEWER=display\" >> ~/.bashrc"
}
