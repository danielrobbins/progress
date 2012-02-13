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
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(python_abi_depend ">=dev-python/certifi-0.0.7")
	$(python_abi_depend dev-python/chardet)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="HISTORY.rst README.rst"

src_install() {
	distutils_src_install

	delete_version-specific_modules() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			rm -fr "${ED}$(python_get_sitedir)/requests/packages/oreos"
		fi
	}
	python_execute_function -q delete_version-specific_modules
}
