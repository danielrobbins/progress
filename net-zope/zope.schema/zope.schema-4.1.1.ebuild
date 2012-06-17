# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="zope.interface extension for defining data schemas"
HOMEPAGE="http://pypi.python.org/pypi/zope.schema"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend -i "2.6" dev-python/ordereddict)
	$(python_abi_depend dev-python/six)
	$(python_abi_depend net-zope/zope.event)
	$(python_abi_depend ">=net-zope/zope.interface-3.6.0")
	$(python_abi_depend net-zope/zope.i18nmessageid)"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend net-zope/zope.testing) )"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"
