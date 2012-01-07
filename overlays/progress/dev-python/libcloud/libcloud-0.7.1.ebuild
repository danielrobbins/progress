# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[ssl]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5 *-jython"
PYTHON_TESTS_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A standard Python library that abstracts away differences among multiple cloud provider APIs"
HOMEPAGE="http://libcloud.apache.org/ http://pypi.python.org/pypi/apache-libcloud"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="$(python_abi_depend virtual/python-json[external])"
RDEPEND="${DEPEND}"

S="${WORKDIR}/apache-${P}"

src_prepare() {
	distutils_src_prepare
	cp test/secrets.py-dist test/secrets.py || die "cp failed"
}

src_install() {
	distutils_src_install

	if use examples; then
		docinto examples
		dodoc example_*.py
	fi
}
