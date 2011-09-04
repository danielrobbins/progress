# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="2.4 2.5"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="Unidecode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="US-ASCII transliterations of Unicode text"
HOMEPAGE="http://code.zemanta.com/tsolc/unidecode/ http://pypi.python.org/pypi/Unidecode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

# License of dev-lang/perl and dev-perl/Text-Unidecode.
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="ChangeLog README"
