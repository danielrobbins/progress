# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit python

MY_PN="PythonMagick"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for ImageMagick"
HOMEPAGE="http://www.imagemagick.org/script/api.php"
SRC_URI="mirror://imagemagick/python/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend "dev-libs/boost:0=[python]")
	>=media-gfx/imagemagick-6.8.6:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PYTHON_CXXFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	python_clean_py-compile_files
	python_src_prepare
}

src_configure() {
	configuration() {
		sed -e "s/-lboost_python/-lboost_python-${PYTHON_ABI}/" -i Makefile.in
		econf \
			--disable-static \
			--with-boost-python="boost_python-${PYTHON_ABI}"
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install
	python_clean_installation_image
}

pkg_postinst() {
	python_byte-compile_modules PythonMagick
}

pkg_postrm() {
	python_clean_byte-compiled_modules PythonMagick
}
