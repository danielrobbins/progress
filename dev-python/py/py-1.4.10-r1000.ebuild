# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
# https://bitbucket.org/hpk42/py/issue/10
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="http://pylib.org/ https://bitbucket.org/hpk42/py http://pypi.python.org/pypi/py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="app-arch/unzip
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend ">=dev-python/pytest-2") )"
RDEPEND=""

DOCS="CHANGELOG README.txt"

src_prepare() {
	distutils_src_prepare

	# https://bitbucket.org/hpk42/py/changeset/1060ea1c96dd9dfb031bd1987ceb2bf4
	sed -e "s/^class pytest_funcarg__setup:$/def pytest_funcarg__setup(request):\n    return Setup(request)\n\nclass Setup:/" -i testing/path/test_svnauth.py
}
