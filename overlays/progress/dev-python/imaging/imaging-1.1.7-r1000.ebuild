# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}tk?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils eutils multilib

MY_P="Imaging-${PV}"

DESCRIPTION="Python Imaging Library (PIL)"
HOMEPAGE="http://www.pythonware.com/products/pil/index.htm"
SRC_URI="http://www.effbot.org/downloads/${MY_P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples lcms scanner tk X"

DEPEND="media-libs/freetype:2
	virtual/jpeg
	lcms? ( media-libs/lcms:0 )
	scanner? ( media-gfx/sane-backends )
	X? ( x11-misc/xdg-utils )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES CONTENTS"

pkg_setup() {
	PYTHON_MODULES="PIL $(use scanner && echo sane.py)"
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-no-xv.patch"
	epatch "${FILESDIR}/${P}-sane.patch"
	epatch "${FILESDIR}/${P}-giftrans.patch"
	epatch "${FILESDIR}/${P}-missing-math.patch"
	if ! use lcms; then
		epatch "${FILESDIR}/${P}-nolcms.patch"
	fi

	# Add shebang.
	sed -e "1i#!/usr/bin/python" -i Scripts/pilfont.py || die "sed failed"

	sed \
		-e "s:/usr/lib\":/usr/$(get_libdir)\":" \
		-e "s:\"lib\":\"$(get_libdir)\":g" \
		-i setup.py || die "sed failed"

	if ! use tk; then
		# Make the test always fail.
		sed -e "s/import _tkinter/raise ImportError/" -i setup.py || die "sed failed"
	fi
}

src_compile() {
	distutils_src_compile

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

	install_headers() {
		insinto "$(python_get_includedir)"
		doins libImaging/Imaging.h
		doins libImaging/ImPlatform.h
	}
	python_execute_function install_headers

	if use doc; then
		dohtml Docs/*
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
			doins Sane/demo_*.py
		fi
	fi
}
