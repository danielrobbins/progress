# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="http://python-requests.org/ http://pypi.python.org/pypi/requests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="async"

RDEPEND="$(python_abi_depend ">=dev-python/certifi-0.0.7")
	$(python_abi_depend dev-python/chardet)
	$(python_abi_depend -i "2.*" "=dev-python/oauthlib-0.1*")
	async? ( $(python_abi_depend -e "3.* *-jython *-pypy-*" dev-python/gevent) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="HISTORY.rst README.rst"
