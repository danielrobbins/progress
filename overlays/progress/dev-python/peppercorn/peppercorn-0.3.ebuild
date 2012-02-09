# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A library for converting a token stream into a data structure for use in web form posts"
HOMEPAGE="http://docs.repoze.org/peppercorn http://pypi.python.org/pypi/peppercorn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend -e "2.4" dev-python/sphinx) )"
RDEPEND=""

DOCS="CHANGES.txt README.txt"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		[[ "$(python_get_version -f -l)" == "2.4" ]] && die "Generation of documentation using Python 2.4 not supported"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/peppercorn/tests.py"
	}
	python_execute_function -q delete_tests

	if use doc; then
		pushd docs/.build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static
		popd > /dev/null
	fi
}
