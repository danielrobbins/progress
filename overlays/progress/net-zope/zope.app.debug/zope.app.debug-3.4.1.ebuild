# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="Zope Debug Mode"
HOMEPAGE="http://pypi.python.org/pypi/zope.app.debug"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope,zope.app])
	$(python_abi_depend net-zope/zope.app.appsetup)
	$(python_abi_depend net-zope/zope.app.publication)
	$(python_abi_depend net-zope/zope.publisher)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN//.//}"