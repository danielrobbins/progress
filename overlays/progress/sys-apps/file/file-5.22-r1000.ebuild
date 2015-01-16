# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_DEPEND="python? ( <<>> )"
# http://bugs.jython.org/issue1916
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils eutils libtool multilib-minimal toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/glensc/file.git"
	inherit autotools git-r3
else
	SRC_URI="ftp://ftp.astron.com/pub/file/${P}.tar.gz
		ftp://ftp.gw.com/mirrors/pub/unix/file/${P}.tar.gz"
	KEYWORDS="*"
fi

DESCRIPTION="identify a file's format by scanning binary data for patterns"
HOMEPAGE="http://www.darwinsys.com/file/"

LICENSE="BSD-2"
SLOT="0"
IUSE="python static-libs zlib"

DEPEND="zlib? ( sys-libs/zlib:0=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	python? ( !!dev-python/python-magic )"

PYTHON_MODULES="magic.py"

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	elibtoolize

	# don't let python README kill main README #60043
	mv python/README{,.python}
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	ac_cv_header_zlib_h=$(usex zlib) \
	ac_cv_lib_z_gzopen=$(usex zlib)
	econf \
		$(use_enable static-libs static)
}

src_configure() {
	# when cross-compiling, we need to build up our own file
	# because people often don't keep matching host/target
	# file versions #362941
	if tc-is-cross-compiler && ! ROOT=/ has_version ~${CATEGORY}/${P} ; then
		mkdir -p "${WORKDIR}"/build
		cd "${WORKDIR}"/build
		tc-export_build_env BUILD_C{C,XX}
		ECONF_SOURCE=${S} \
		ac_cv_header_zlib_h=no \
		ac_cv_lib_z_gzopen=no \
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} -static" \
		CC=${BUILD_CC} \
		CXX=${BUILD_CXX} \
		econf --disable-shared
	fi

	multilib-minimal_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		emake
	else
		emake -C src libmagic.la
	fi
}

src_compile() {
	if tc-is-cross-compiler && ! ROOT=/ has_version ~${CATEGORY}/${P} ; then
		emake -C "${WORKDIR}"/build/src file
		PATH="${WORKDIR}/build/src:${PATH}"
	fi
	multilib-minimal_src_compile

	use python && cd python && distutils_src_compile
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		default
	else
		emake -C src install-{includeHEADERS,libLTLIBRARIES} DESTDIR="${D}"
	fi
}

multilib_src_install_all() {
	dodoc ChangeLog MAINT README

	use python && cd python && distutils_src_install
	prune_libtool_files
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}