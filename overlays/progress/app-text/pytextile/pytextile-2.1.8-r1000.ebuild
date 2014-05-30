# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.1 3.2"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="textile"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python implementation of Textile, Dean Allen's Human Text Generator for creating (X)HTML."
HOMEPAGE="https://github.com/ikirudennis/python-textile https://pypi.python.org/pypi/textile"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="${MY_PN}"

src_prepare() {
	distutils_src_prepare

	# Fix failing test.
	# https://github.com/ikirudennis/python-textile/commit/83c81db387fa5f0c5ca25c27b8bc36d105bce599
	sed -e 's/walker = treewalkers.getTreeWalker("simpletree")/walker = treewalkers.getTreeWalker("etree")/' -i textile/tools/sanitizer.py
}

distutils_src_test_post_hook() {
	rm -f .coverage .noseids
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/textile/tests"
	}
	python_execute_function -q delete_tests
}
