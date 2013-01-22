# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Extensions to the Python standard library unit testing framework"
HOMEPAGE="https://launchpad.net/testtools http://pypi.python.org/pypi/testtools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/extras)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_prepare() {
	distutils_src_prepare

	# Avoid ImportError with Python 3 due to not installed testtools/_compat2x.py.
	sed -e "s/except SyntaxError:/except (ImportError, SyntaxError):/" -i testtools/compat.py || die "sed failed"
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
			rm -f "${ED}$(python_get_sitedir)/testtools/_compat2x.py"
		else
			rm -f "${ED}$(python_get_sitedir)/testtools/_compat3x.py"
		fi
	}
	python_execute_function -q delete_version-specific_modules

	delete_tests() {
		# dev-python/subunit imports some objects from testtools.tests.helpers.
		rm -fr "${ED}$(python_get_sitedir)/testtools/tests/"{matchers,test_*}
	}
	python_execute_function -q delete_tests
}
