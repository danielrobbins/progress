# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}tk?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils

DESCRIPTION="Python code static checker"
# Old homepage: http://www.logilab.org/project/pylint
HOMEPAGE="http://www.pylint.org/ https://bitbucket.org/logilab/pylint https://pypi.python.org/pypi/pylint"
SRC_URI="http://download.logilab.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples tk"

# Versions specified in __pkginfo__.py.
RDEPEND="$(python_abi_depend ">=dev-python/logilab-common-0.53.0")
	$(python_abi_depend ">=dev-python/astng-0.24.3")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
# DOCS="doc/*.txt"

src_prepare() {
	# https://bitbucket.org/logilab/pylint/commits/86cdfa0bd31e3d4d923b741867e6ce0b935859dc
	mv test/input/{func_dangerous_default_py27.py,func_set_literal_as_default_py27.py} || die
	echo "W:  5:function1: Dangerous default value {1} as argument" > test/messages/func_set_literal_as_default_py27.txt

	distutils_src_prepare
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build/lib" pytest -v
	}
	python_execute_function -s testing
}

src_install() {
	distutils_src_install

	if ! use tk; then
		rm -f "${ED}usr/bin/pylint-gui"*
	fi

	doman man/{pylint,pyreverse}.1

	if use examples; then
		docinto examples
		dodoc examples/*
	fi

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/pylint/test"
	}
	python_execute_function -q delete_tests
}
