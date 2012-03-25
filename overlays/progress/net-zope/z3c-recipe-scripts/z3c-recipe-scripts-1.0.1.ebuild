# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"

inherit distutils

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Recipe for installing Python scripts"
HOMEPAGE="http://pypi.python.org/pypi/z3c.recipe.scripts"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="$(python_abi_depend net-zope/namespaces-z3c[z3c,z3c.recipe])
	$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend ">=net-zope/zc-buildout-1.5.0")
	$(python_abi_depend ">=net-zope/zc-recipe-egg-1.3.0")"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt src/z3c/recipe/scripts/*.txt"
PYTHON_MODULES="${PN//-//}"
