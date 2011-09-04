# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_DEPEND="<<[ncurses]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Urwid is a curses-based user interface library for Python"
HOMEPAGE="http://excess.org/urwid/ http://pypi.python.org/pypi/urwid"
SRC_URI="http://excess.org/urwid/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="examples"

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_test() {
	testing() {
		"$(PYTHON)" test_urwid.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	dohtml reference.html tutorial.html

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins bigtext.py browse.py calc.py dialog.py edit.py fib.py graph.py input_test.py tour.py
	fi
}
