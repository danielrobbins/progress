# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"

inherit distutils

DESCRIPTION="Python module for DNS (Domain Name Service)"
HOMEPAGE="http://pydns.sourceforge.net/ http://pypi.python.org/pypi/pydns"
SRC_URI="mirror://sourceforge/pydns/${P}.tar.gz"

LICENSE="CNRI"
SLOT="python-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="!dev-python/pydns:0"
DEPEND="${RDEPEND}
	virtual/libiconv"

DOCS="CREDITS.txt"
PYTHON_MODULES="DNS"

src_prepare() {
	# Fix encoding of comments.
	local file
	for file in DNS/{Lib,Type}.py; do
		iconv -f ISO-8859-1 -t UTF-8 < "${file}" > "${file}~" && mv -f "${file}~" "${file}" > /dev/null
	done

	# Fix Python shebangs in examples.
	sed -i -e 's:#!/.*\(python\).*/*$:#!/usr/bin/\12:g' {tests,tools}/*.py
}

src_install(){
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins {tests,tools}/*.py
	fi
}
