# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# fcntl module required.
PYTHON_RESTRICTED_ABIS="*-jython"
# Tests broken with Python 3.
PYTHON_TESTS_RESTRICTED_ABIS="3.*"

inherit distutils

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="http://pypi.python.org/pypi/zc.lockfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="$(python_abi_depend net-zope/namespaces-zc[zc])"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -e "${PYTHON_TESTS_RESTRICTED_ABIS}" net-zope/zope.testing) )"

DOCS="CHANGES.txt src/zc/lockfile/README.txt"
PYTHON_MODULES="${PN/.//}"

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" -c "import sys, unittest, zc.lockfile.tests; sys.exit(not unittest.TextTestRunner(verbosity=2).run(zc.lockfile.tests.test_suite()).wasSuccessful())"
	}
	python_execute_function testing
}
