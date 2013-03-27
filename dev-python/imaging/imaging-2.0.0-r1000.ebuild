# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}tk?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython"

inherit distutils eutils multilib

MY_PN="Pillow"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pillow (fork of PIL) - Python Imaging Library"
HOMEPAGE="https://github.com/python-imaging/Pillow https://pypi.python.org/pypi/Pillow"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="*"
IUSE="X doc examples lcms scanner tiff tk webp"

RDEPEND="media-libs/freetype:2
	sys-libs/zlib
	virtual/jpeg
	X? ( x11-misc/xdg-utils )
	lcms? ( media-libs/lcms:0 )
	scanner? ( media-gfx/sane-backends )
	tiff? ( media-libs/tiff:0 )
	webp? ( media-libs/libwebp )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

DOCS="README.rst docs/CONTRIBUTORS.txt docs/HISTORY.txt"

pkg_setup() {
	PYTHON_MODULES="PIL $(use scanner && echo sane.py)"
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-delete_hardcoded_paths.patch"
	epatch "${FILESDIR}/${P}-gif_transparency.patch"
	epatch "${FILESDIR}/${P}-libm_linking.patch"
	epatch "${FILESDIR}/${P}-use_xdg-open.patch"

	# https://github.com/python-imaging/Pillow/issues/166
	sed -e "s/#if PY_VERSION_HEX >= 0x03000000/#if PY_VERSION_HEX >= 0x03020000/" -i path.c

	# Add shebang.
	# https://github.com/python-imaging/Pillow/issues/167
	sed -e "1i#!/usr/bin/python" -i Scripts/pilfont.py || die "sed failed"

	if ! use lcms; then
		sed -e "s/\(^[[:space:]]*feature\.lcms =\).*/\1 False/" -i setup.py
	fi

	if ! use tiff; then
		sed -e "s/\(^[[:space:]]*feature\.tiff =\).*/\1 False/" -i setup.py
	fi

	if ! use tk; then
		sed -e "s/import _tkinter/raise ImportError/" -i setup.py
	fi

	if ! use webp; then
		sed -e "s/\(^[[:space:]]*feature\.webp =\).*/\1 False/" -i setup.py
	fi	
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi

	if use scanner; then
		pushd Sane > /dev/null
		distutils_src_compile
		popd > /dev/null
	fi
}

src_test() {
	tests() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" selftest.py
	}
	python_execute_function tests
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi

	if use scanner; then
		pushd Sane > /dev/null
		docinto sane
		DOCS="CHANGES sanedoc.txt" distutils_src_install
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins Scripts/*

		if use scanner; then
			insinto /usr/share/doc/${PF}/examples/sane
			doins Sane/demo_pil.py
		fi
	fi
}
