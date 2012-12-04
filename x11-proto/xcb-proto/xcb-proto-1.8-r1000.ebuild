# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[xml]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit python xorg-2

DESCRIPTION="X C-language Bindings protocol headers"
HOMEPAGE="http://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/proto"
[[ ${PV} != 9999* ]] && \
	SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/libxml2"

src_prepare() {
	python_clean_py-compile_files
	xorg-2_src_prepare
}

src_configure() {
	configuration() {
		BUILD_DIR="${S}-${PYTHON_ABI}" xorg-2_src_configure
	}
	python_execute_function configuration
}

src_compile() {
	building() {
		BUILD_DIR="${S}-${PYTHON_ABI}" xorg-2_src_compile
	}
	python_execute_function building
}

src_test() {
	testing() {
		BUILD_DIR="${S}-${PYTHON_ABI}" autotools-utils_src_test
	}
	python_execute_function testing
}

src_install() {
	installation() {
		BUILD_DIR="${S}-${PYTHON_ABI}" xorg-2_src_install
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize xcbgen
	ewarn "Please rebuild both libxcb and xcb-util if you are upgrading from version 1.6"
}

pkg_postrm() {
	python_mod_cleanup xcbgen
}
