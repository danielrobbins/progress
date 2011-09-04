# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 *-jython"

inherit distutils

DESCRIPTION="Python module used for monitoring filesystems events"
HOMEPAGE="http://trac.dbzteam.org/pyinotify http://pypi.python.org/pypi/pyinotify"
SRC_URI="http://seb.dbzteam.org/pub/pyinotify/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

PYTHON_MODULES="pyinotify.py"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins python2/examples/*
	fi
}
