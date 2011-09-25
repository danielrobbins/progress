# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
# https://bitbucket.org/hpk42/pytest/issue/75
PYTHON_TESTS_RESTRICTED_ABIS="2.5-jython"

inherit distutils

DESCRIPTION="py.test: simple powerful testing with Python"
HOMEPAGE="http://pytest.org/ http://pypi.python.org/pypi/pytest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="$(python_abi_depend ">=dev-python/py-1.4.5")"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGELOG README.txt"
PYTHON_MODULES="pytest.py _pytest"

src_prepare() {
	distutils_src_prepare

	# https://bitbucket.org/hpk42/pytest/issue/74
	sed -e "s/test_cmdline_python_package/_&/" -i testing/acceptance_test.py

	# Disable versioning of py.test script to avoid collision with versioning performed by python_merge_intermediate_installation_images().
	sed -e "s/return points/return {'py.test': target}/" -i setup.py || die "sed failed"
}

src_test() {
	testing() {
		PYTHONPATH="${S}/build-${PYTHON_ABI}/lib" "$(PYTHON)" "build-${PYTHON_ABI}/lib/pytest.py"
	}
	python_execute_function testing

	find "(" -name "*.pyc" -o -name "*\$py.class" ")" -print0 | xargs -0 rm -f
	find -name "__pycache__" -print0 | xargs -0 rmdir
}

src_install() {
	distutils_src_install
	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/py.test"
}
