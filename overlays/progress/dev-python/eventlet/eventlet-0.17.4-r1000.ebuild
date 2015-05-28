# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 3.2 *-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Highly concurrent networking library"
HOMEPAGE="http://eventlet.net/ https://github.com/eventlet/eventlet https://bitbucket.org/eventlet/eventlet https://pypi.python.org/pypi/eventlet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

RDEPEND="$(python_abi_depend dev-python/pyopenssl)
	$(python_abi_depend virtual/python-greenlet)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	distutils_src_test tests
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/_build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
