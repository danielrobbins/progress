# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[{*-cpython}threads]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Reliable start/stop/configuration of Mozilla Applications (Firefox, Thunderbird, etc.)"
HOMEPAGE="http://pypi.python.org/pypi/mozrunner"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="$(python_abi_depend ">=dev-python/mozinfo-0.4")
	$(python_abi_depend ">=dev-python/mozprocess-0.7")
	$(python_abi_depend ">=dev-python/mozprofile-0.4")
	$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend virtual/python-json[external])"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare

	sed \
		-e "s/mozinfo == 0.4/mozinfo >= 0.4/" \
		-e "s/mozprocess == 0.7/mozprocess >= 0.7/" \
		-e "s/mozprofile == 0.4/mozprofile >= 0.4/" \
		-i setup.py
}
