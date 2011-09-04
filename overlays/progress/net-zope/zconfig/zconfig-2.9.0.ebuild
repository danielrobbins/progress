# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

MY_PN="ZConfig"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Structured Configuration Library"
HOMEPAGE="http://pypi.python.org/pypi/ZConfig"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="app-arch/unzip
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend net-zope/zope-testing) )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="NEWS.txt README.txt"
PYTHON_MODULES="${MY_PN}"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-2.7.1-fix_tests.patch"
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/ZConfig/tests"
	}
	python_execute_function -q delete_tests
}
