# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="Zope Location"
HOMEPAGE="http://pypi.python.org/pypi/zope.location"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend ">=net-zope/zope.component-3.8")
	$(python_abi_depend net-zope/zope.copy)
	$(python_abi_depend net-zope/zope.interface)
	$(python_abi_depend net-zope/zope.proxy)
	$(python_abi_depend ">=net-zope/zope.schema-3.6")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"
