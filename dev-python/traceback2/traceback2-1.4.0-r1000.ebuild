# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils

DESCRIPTION="Backports of the traceback module"
HOMEPAGE="https://github.com/testing-cabal/traceback2 https://pypi.python.org/pypi/traceback2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="$(python_abi_depend dev-python/linecache2)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/pbr)
	$(python_abi_depend dev-python/setuptools)
	test? (
		$(python_abi_depend dev-python/contextlib2)
		$(python_abi_depend dev-python/fixtures)
		$(python_abi_depend ">=dev-python/testtools-1.0.0")
		$(python_abi_depend dev-python/unittest2)
	)"

DOCS="AUTHORS ChangeLog README.rst"

src_test() {
	testing() {
		python_execute PYTHONPATH="." unit2-${PYTHON_ABI} -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/traceback2/tests"
	}
	python_execute_function -q delete_tests
}
