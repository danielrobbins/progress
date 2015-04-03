# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"

inherit distutils

DESCRIPTION="Backports of the linecache module"
HOMEPAGE="https://github.com/testing-cabal/linecache2 https://pypi.python.org/pypi/linecache2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND=""
DEPEND="$(python_abi_depend dev-python/pbr)
	$(python_abi_depend dev-python/setuptools)
	test? (
		$(python_abi_depend dev-python/fixtures)
		$(python_abi_depend dev-python/unittest2)
	)"

DOCS="AUTHORS ChangeLog README.rst"

src_prepare() {
	distutils_src_prepare

	# https://github.com/testing-cabal/linecache2/issues/3
	sed -e "/FILENAME = FILENAME\[:-1\]/a\\elif FILENAME.endswith('\$py.class'):\n    FILENAME = FILENAME[:-9] + '.py'" -i linecache2/tests/test_linecache.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" unit2-${PYTHON_ABI} -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/linecache2/tests"
	}
	python_execute_function -q delete_tests
}
