# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_DEPEND="<<[ssl?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Python FTP server library"
HOMEPAGE="http://code.google.com/p/pyftpdlib/ http://pypi.python.org/pypi/pyftpdlib"
SRC_URI="http://pyftpdlib.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="examples ssl"

DEPEND="ssl? ( $(python_abi_depend -e "*-jython" dev-python/pyopenssl) )"
RDEPEND="${DEPEND}"

DOCS="CREDITS HISTORY"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_contrib.py || return 1
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_ftpd.py || return 1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	dohtml -r doc/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demo test
	fi
}
