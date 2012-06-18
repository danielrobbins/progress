# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="A generic, spec-compliant, thorough implementation of the OAuth request-signing logic"
HOMEPAGE="https://github.com/idangazit/oauthlib http://pypi.python.org/pypi/oauthlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

RDEPEND="$(python_abi_depend dev-python/rsa)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend dev-python/unittest2) )"

src_prepare() {
	distutils_src_prepare
	touch tests/__init__.py

	# multiprocessing module is missing in Jython.
	sed -e "/^import multiprocessing$/d" -i setup.py
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/tests"
	}
	python_execute_function -q delete_tests
}
