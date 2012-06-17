# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="zLOG"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A general logging facility"
HOMEPAGE="http://pypi.python.org/pypi/zLOG"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend net-zope/zconfig) )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="${MY_PN}"

src_prepare() {
	distutils_src_prepare

	# net-zope/zconfig is actually used only by tests.
	sed -e "/ZConfig/d" -i setup.py || die "sed failed"
}
