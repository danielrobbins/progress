# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"

inherit distutils

MY_PN="ManifestDestiny"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Universal manifests for Mozilla test harnesses"
HOMEPAGE="http://pypi.python.org/pypi/ManifestDestiny"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="manifestparser"
