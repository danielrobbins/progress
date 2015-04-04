# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1"

inherit distutils

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="https://github.com/testing-cabal/testtools https://launchpad.net/testtools https://pypi.python.org/pypi/testtools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/extras)
	$(python_abi_depend dev-python/linecache2)
	$(python_abi_depend dev-python/mimeparse)
	$(python_abi_depend dev-python/traceback2)
	$(python_abi_depend ">=dev-python/unittest2-1.0.0")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_prepare() {
	distutils_src_prepare

	# Ignore ImportError caused by deletion of incompatible module by delete_version-specific_modules().
	sed -e "s/except SyntaxError:/except (ImportError, SyntaxError):/" -i testtools/compat.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" -m testtools.run testtools.tests.test_suite
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_version-specific_modules() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			rm "${ED}$(python_get_sitedir)/testtools/_compat2x.py"
		else
			rm "${ED}$(python_get_sitedir)/testtools/_compat3x.py"
		fi
	}
	python_execute_function -q delete_version-specific_modules
}
