# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# *-jython: http://bugs.jython.org/issue1973
PYTHON_TESTS_RESTRICTED_ABIS="2.5 *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="Unidecode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ASCII transliterations of Unicode text"
HOMEPAGE="http://pypi.python.org/pypi/Unidecode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="ChangeLog README"
