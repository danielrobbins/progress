# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

inherit distutils

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="http://www.rdflib.net/ http://pypi.python.org/pypi/rdflib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="berkdb examples mysql redland sqlite test zodb"

RDEPEND="berkdb? ( $(python_abi_depend -e "*-jython" dev-python/bsddb3) )
	mysql? ( $(python_abi_depend -e "*-jython" dev-python/mysql-python) )
	redland? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-libs/redland-bindings[python]) )
	sqlite? ( $(python_abi_depend -e "*-jython" virtual/python-sqlite) )
	zodb? ( $(python_abi_depend -e "2.4 *-jython" net-zope/zodb) )"
DEPEND="${RDEPEND}
	test? ( $(python_abi_depend dev-python/nose) )"

DOCS="CHANGELOG"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib)" "$(PYTHON)" run_tests.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
