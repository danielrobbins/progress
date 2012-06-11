# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Zope Exceptions"
HOMEPAGE="http://pypi.python.org/pypi/zope.exceptions"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend net-zope/zope.interface)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend -i "3.*" net-zope/zope.fixers)"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"
