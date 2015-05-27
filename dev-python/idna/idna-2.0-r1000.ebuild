# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
# *-jython: "java.lang.RuntimeException: java.lang.RuntimeException: Method code too large!"
PYTHON_RESTRICTED_ABIS="3.1 3.2 *-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.6"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Internationalized Domain Names in Applications (IDNA)"
HOMEPAGE="https://github.com/kjd/idna https://pypi.python.org/pypi/idna"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD PSF-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

DOCS="HISTORY.rst README.rst"
