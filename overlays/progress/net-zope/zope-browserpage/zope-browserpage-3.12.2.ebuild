# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.* *-jython"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ZCML directives for configuring browser views for Zope."
HOMEPAGE="http://pypi.python.org/pypi/zope.browserpage"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend net-zope/zope-browsermenu)
	$(python_abi_depend net-zope/zope-component)
	$(python_abi_depend net-zope/zope-configuration)
	$(python_abi_depend net-zope/zope-interface)
	$(python_abi_depend net-zope/zope-pagetemplate)
	$(python_abi_depend net-zope/zope-publisher)
	$(python_abi_depend net-zope/zope-schema)
	$(python_abi_depend net-zope/zope-security)
	$(python_abi_depend net-zope/zope-traversing)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/-//}"
