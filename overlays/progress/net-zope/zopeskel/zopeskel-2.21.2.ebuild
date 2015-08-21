# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="2.6 3.*"

inherit distutils

MY_PN="ZopeSkel"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Templates and code generator for quickstarting Plone / Zope projects."
HOMEPAGE="https://pypi.python.org/pypi/ZopeSkel"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/pastescript)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

DOCS="CONTRIBUTORS.txt HISTORY.txt README.txt"
