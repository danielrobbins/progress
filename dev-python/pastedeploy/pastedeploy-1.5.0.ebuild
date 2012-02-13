# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="http://pythonpaste.org/deploy/ http://pypi.python.org/pypi/PasteDeploy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="$(python_abi_depend dev-python/namespaces-paste)
	$(python_abi_depend dev-python/setuptools)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="docs/index.txt docs/news.txt"
PYTHON_MODULES="paste/deploy"
