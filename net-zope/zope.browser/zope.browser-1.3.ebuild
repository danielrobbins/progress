# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

DESCRIPTION="Shared Zope Toolkit browser components"
HOMEPAGE="http://pypi.python.org/pypi/zope.browser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend net-zope/zope.interface)"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"
