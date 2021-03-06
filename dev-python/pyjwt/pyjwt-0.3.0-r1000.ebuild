# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

MY_PN="PyJWT"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="https://github.com/progrium/pyjwt https://pypi.python.org/pypi/PyJWT"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="README.md"
PYTHON_MODULES="jwt"
