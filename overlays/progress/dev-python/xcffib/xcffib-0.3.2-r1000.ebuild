# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 *-jython"

inherit distutils

DESCRIPTION="A drop in replacement for xpyb, an XCB python binding"
HOMEPAGE="https://github.com/tych0/xcffib https://pypi.python.org/pypi/xcffib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend -e "*-pypy" ">=dev-python/cffi-1.1.0:=")
	$(python_abi_depend dev-python/six)
	x11-libs/libxcb:0="
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"
