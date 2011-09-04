# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils eutils

DESCRIPTION="Python Serial Port Extension"
HOMEPAGE="http://pyserial.sourceforge.net/ http://sourceforge.net/projects/pyserial/ http://pypi.python.org/pypi/pyserial"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="serial"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-python-3.patch"
}
