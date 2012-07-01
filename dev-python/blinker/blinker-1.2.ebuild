# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Fast, simple object-to-object and broadcast signaling"
HOMEPAGE="http://discorporate.us/projects/Blinker/ http://pypi.python.org/pypi/blinker"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/html/*
	fi
}
