# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy"

inherit distutils eutils

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="http://initd.org/psycopg/ https://pypi.python.org/pypi/psycopg2"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="*"
IUSE="debug doc examples mxdatetime"
RESTRICT="test"

RDEPEND=">=dev-db/postgresql-8.1
	mxdatetime? ( $(python_abi_depend -e "3.* *-pypy" dev-python/egenix-mx-base) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="AUTHORS NEWS README.rst"
PYTHON_MODULES="${PN}2"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4.2-setup.py.patch"

	if use debug; then
		sed -e "/^define=/{s/$/,PSYCOPG_DEBUG/;s/=,/=/}" -i setup.cfg || die "sed failed"
	fi

	if use mxdatetime; then
		sed -e "/^use_pydatetime=/s/1/0/" -i setup.cfg || die "sed failed"
	fi
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc/src > /dev/null
		PYTHONPATH="$(ls -d ../../build-$(PYTHON -f --ABI)/lib*)" emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/psycopg2/tests"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/src/_build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
