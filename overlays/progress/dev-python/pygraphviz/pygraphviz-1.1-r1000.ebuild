# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils eutils

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="http://networkx.lanl.gov/pygraphviz/ https://pypi.python.org/pypi/pygraphviz"
SRC_URI="http://networkx.lanl.gov/download/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="examples"

DEPEND="media-gfx/graphviz"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-1.0-setup.py.patch"
	epatch "${FILESDIR}/${P}-avoid_tests.patch"
}

src_test() {
	testing() {
		python_execute "$(PYTHON)" -c "import sys; sys.path.insert(0, '$(ls -d build-${PYTHON_ABI}/lib.*)'); import pygraphviz.tests; pygraphviz.tests.run()"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/${PN}/tests"
	}
	python_execute_function -q delete_tests

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
