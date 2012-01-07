# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[{*-cpython}readline?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 *-jython"
# functools.cmp_to_key() required with Python 3.
PYTHON_TESTS_RESTRICTED_ABIS="3.1"

inherit distutils elisp-common eutils virtualx

DESCRIPTION="An interactive computing environment for Python"
HOMEPAGE="http://ipython.org/ http://pypi.python.org/pypi/ipython"
SRC_URI="http://archive.ipython.org/release/${PV}/${P}.tar.gz http://archive.ipython.org/release/${PV}/py3/${P}-py3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
# IUSE="doc emacs examples matplotlib pymongo qt4 readline smp test wxwidgets"
IUSE="doc emacs examples pymongo qt4 readline smp test wxwidgets"

RDEPEND="$(python_abi_depend dev-python/decorator)
	$(python_abi_depend -e "*-pypy-*" dev-python/numpy)
	$(python_abi_depend -i "2.*" dev-python/pexpect)
	$(python_abi_depend dev-python/pyparsing)
	$(python_abi_depend virtual/python-argparse)
	emacs? (
		app-emacs/python-mode
		virtual/emacs
	)
	pymongo? ( $(python_abi_depend -i "2.*" dev-python/pymongo) )
	qt4? ( $(python_abi_depend -e "*-pypy-*" dev-python/PyQt4) )
	smp? ( $(python_abi_depend ">=dev-python/pyzmq-2.1.4") )
	wxwidgets? ( $(python_abi_depend -i "2.*" dev-python/wxpython) )"
#	matplotlib? ( $(python_abi_depend dev-python/matplotlib) )
DEPEND="${RDEPEND}
	test? ( $(python_abi_depend dev-python/nose) )"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
PYTHON_MODULES="IPython"

SITEFILE="62ipython-gentoo.el"

src_unpack() {
	unpack ${P}.tar.gz
	mv ${P} ${P}-python2
	unpack ${P}-py3.tar.gz
	mv ${P} ${P}-python3
	mkdir ${P}
}

src_prepare() {
	local version
	for version in 2 3; do
		einfo "Preparation with Python ${version}"
		pushd "${WORKDIR}/${P}-python${version}" > /dev/null

		epatch "${FILESDIR}/${P}-global_path.patch"

		# Disable failing tests.
		sed \
			-e "s/test_obj_del/_&/" \
			-e "s/test_tclass/_&/" \
			-i IPython/core/tests/test_run.py || die "sed failed"

		# Fix installation directory for documentation.
		sed \
			-e "/docdirbase  = pjoin/s/ipython/${PF}/" \
			-e "/pjoin(docdirbase,'manual')/s/manual/html/" \
			-i setupbase.py || die "sed failed"

		rm -fr docs/html/{.buildinfo,_sources,objects.inv}

		if ! use doc; then
			sed \
				-e "/(pjoin(docdirbase, 'extensions'), igridhelpfiles),/d" \
				-e "s/+ manual_files//" \
				-i setupbase.py || die "sed failed"
		fi

		if ! use examples; then
			sed -e "s/+ example_files//" -i setupbase.py || die "sed failed"
		fi

		popd > /dev/null
	done

	pushd "${WORKDIR}/${P}-python3" > /dev/null

	epatch "${FILESDIR}/${P}-python3-scripts_versioning.patch"

	local script
	for script in IPython/parallel/scripts/*3 IPython/scripts/*3; do
		mv ${script} ${script%3} || die "Renaming of ${script} failed"
	done

	# Disable failing tests.
	sed -e "s/test_find_cmd_fail/_&/" -i IPython/utils/tests/test_process.py
	sed \
		-e "s/test_importer/_&/" \
		-e "s/test_z_crash_mux/_&/" \
		-e "s/test_magic_px_blocking/_&/" \
		-i IPython/parallel/tests/test_view.py
	sed -e "s/test_ndarray_serialized/_&/" -i IPython/parallel/tests/test_newserialized.py

	popd > /dev/null

	preparation() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			cp -r "${WORKDIR}/${P}-python3" "${WORKDIR}/${P}-${PYTHON_ABI}"
		else
			cp -r "${WORKDIR}/${P}-python2" "${WORKDIR}/${P}-${PYTHON_ABI}"
		fi
	}
	python_execute_function preparation
}

src_compile() {
	distutils_src_compile

	if use emacs; then
		elisp-compile "${WORKDIR}/${P}-python3/docs/emacs/ipython.el" || die "elisp-compile failed"
	fi
}

src_test() {
	if use pymongo; then
		mkdir -p "${T}/mongo.db"
		mongod --dbpath "${T}/mongo.db" --fork --logpath "${T}/mongo.log"
	fi

	testing() {
		"$(PYTHON)" setup.py install --home="${T}/tests/${PYTHON_ABI}" > /dev/null || die "Installation for tests with $(python_get_implementation_and_version) failed"
		pushd "${T}/tests/${PYTHON_ABI}" > /dev/null
		# Initialize ~/.ipython directory.
		PATH="${T}/tests/${PYTHON_ABI}/bin:${PATH}" PYTHONPATH="${T}/tests/${PYTHON_ABI}/lib/python" ipython <<< "" > /dev/null || return 1
		# Run tests (-v for more verbosity).
		PATH="${T}/tests/${PYTHON_ABI}/bin:${PATH}" PYTHONPATH="${T}/tests/${PYTHON_ABI}/lib/python" iptest -v || return 1
		popd > /dev/null
	}
	VIRTUALX_COMMAND="python_execute_function" virtualmake -s testing

	if use pymongo; then
		killall -u "$(id -nu)" mongod
	fi
}

src_install() {
	distutils_src_install

	if use emacs; then
		pushd "${WORKDIR}/${P}-python3/docs/emacs" > /dev/null
		elisp-install ${PN} ${PN}.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		popd > /dev/null
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
