# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit distutils eutils

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="http://biopython.org http://pypi.python.org/pypi/biopython"
SRC_URI="http://www.biopython.org/DIST/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="mysql postgres reportlab"

RDEPEND="$(python_abi_depend dev-python/numpy)
	mysql? ( $(python_abi_depend -i "2.*" dev-python/mysql-python) )
	postgres? ( $(python_abi_depend dev-python/psycopg) )
	reportlab? ( $(python_abi_depend -i "2.*" dev-python/reportlab) )"
DEPEND="${RDEPEND}
	sys-devel/flex"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="CONTRIB DEPRECATED NEWS README"
PYTHON_MODULES="Bio BioSQL"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-1.51-flex.patch"
}

src_test() {
	testing() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			cd build/py$(python_get_version -l)/Tests
		else
			cd Tests
		fi

		PYTHONPATH="$(ls -d ../build/lib.*)" "$(PYTHON)" run_tests.py
	}
	python_execute_function --nonfatal -s testing
}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r Doc/*
	insinto /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}usr/share/${PN}" || die "Installation of shared files failed"
}
