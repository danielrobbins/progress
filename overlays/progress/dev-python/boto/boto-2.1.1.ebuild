# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.*"

inherit distutils

DESCRIPTION="Amazon Web Services Library"
HOMEPAGE="http://code.google.com/p/boto/ http://pypi.python.org/pypi/boto"
SRC_URI="http://boto.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""
