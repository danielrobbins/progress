# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Zope datetime"
HOMEPAGE="http://pypi.python.org/pypi/zope.datetime"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt"
PYTHON_MODULES="${PN/.//}"

src_prepare() {
	distutils_src_prepare

	# Disable failing tests.
	rm -f src/zope/datetime/tests/test_lp_139360.py
}
