# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.*"

inherit distutils

MY_PN="py3dns"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for DNS (Domain Name Service)"
HOMEPAGE="http://pydns.sourceforge.net/ http://pypi.python.org/pypi/pydns"
SRC_URI="mirror://sourceforge/pydns/${MY_P}.tar.gz"

LICENSE="CNRI"
SLOT="python-3"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="!dev-python/py3dns"
DEPEND="${RDEPEND}
	virtual/libiconv"

S="${WORKDIR}/${MY_P}"

DOCS="CREDITS.txt"
PYTHON_MODULES="DNS"

src_install(){
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins {tests,tools}/*.py
	fi
}
