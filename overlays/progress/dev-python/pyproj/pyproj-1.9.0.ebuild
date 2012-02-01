# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit distutils

DESCRIPTION="Python interface to PROJ.4 library"
HOMEPAGE="http://code.google.com/p/pyproj/ http://pypi.python.org/pypi/pyproj"
SRC_URI="http://pyproj.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")
