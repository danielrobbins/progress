# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A collection of tools for internationalizing Python applications"
HOMEPAGE="http://babel.edgewall.org/ http://pypi.python.org/pypi/Babel"
SRC_URI="http://ftp.edgewall.com/pub/babel/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/pytz)
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

PYTHON_MODULES="babel"

src_install() {
	distutils_src_install
	dohtml -r doc/
}
