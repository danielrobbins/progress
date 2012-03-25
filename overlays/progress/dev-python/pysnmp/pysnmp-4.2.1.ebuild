# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit distutils

DESCRIPTION="A pure-Python SNMPv1/v2c/v3 library"
HOMEPAGE="http://pysnmp.sourceforge.net/ http://pypi.python.org/pypi/pysnmp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"
IUSE="examples"

RDEPEND="$(python_abi_depend ">=dev-python/pyasn1-0.0.14")
	$(python_abi_depend ">=dev-python/pycrypto-2.3")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES README THANKS TODO"

src_install(){
	distutils_src_install

	dohtml docs/*.{gif,html}

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r docs/mibs examples
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	elog
	elog "You may also be interested in the following packages:"
	elog "dev-python/pysnmp-apps - SNMP applications"
	elog "dev-python/pysnmp-mibs - IETF and IANA MIBs"
	elog "net-libs/libsmi - smidump tool for automatic convertion of MIB text files into Python code"
	elog
}
