# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_P="${PN}-${PV/_alpha/a}"

DESCRIPTION="CSS Cascading Style Sheets parser and library for Python"
HOMEPAGE="https://bitbucket.org/cthedot/cssutils http://code.google.com/p/cssutils http://pypi.python.org/pypi/cssutils"
SRC_URI="http://cssutils.googlecode.com/files/${MY_P}.zip mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	app-arch/unzip
	test? ( $(python_abi_depend dev-python/mock) )"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="cssutils encutils"

distutils_src_compile_post_hook() {
	# Tests use path relative to sheets directory.
	ln -s ../sheets build-${PYTHON_ABI}/sheets
}

src_test() {
	python_execute_nosetests -e -P 'build-${PYTHON_ABI}/lib' -- -P 'build-${PYTHON_ABI}/lib'
}

src_install() {
	distutils_src_install

	delete_tests_and_version-specific_modules() {
		rm -fr "${ED}$(python_get_sitedir)/tests"

		if [[ "$(python_get_version -l --major)" == "2" ]]; then
			rm -f "${ED}$(python_get_sitedir)/cssutils/_codec3.py"
		else
			rm -f "${ED}$(python_get_sitedir)/cssutils/_codec2.py"
		fi
	}
	python_execute_function -q delete_tests_and_version-specific_modules
}
