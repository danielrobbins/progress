# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="zope.interface extension for defining data schemas"
HOMEPAGE="http://pypi.python.org/pypi/zope.schema"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend -i "2.6" dev-python/ordereddict)
	$(python_abi_depend net-zope/zope.event)
	$(python_abi_depend ">=net-zope/zope.interface-3.6.0")
	$(python_abi_depend net-zope/zope.i18nmessageid)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )
	test? ( $(python_abi_depend net-zope/zope.testing) )"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/.//}"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
