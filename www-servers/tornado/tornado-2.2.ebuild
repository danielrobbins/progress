# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
# Support for Python 3 is experimental.
PYTHON_RESTRICTED_ABIS="3.* *-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

inherit distutils

DESCRIPTION="Scalable, non-blocking web server and tools"
HOMEPAGE="http://www.tornadoweb.org/ http://pypi.python.org/pypi/tornado"
SRC_URI="http://github.com/downloads/facebook/tornado/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/pycurl)
	$(python_abi_depend virtual/python-json)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_test() {
	testing() {
		python_execute PYTHONPATH="." "$(PYTHON)" tornado/test/runtests.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/tornado/test"
	}
	python_execute_function -q delete_tests
}
