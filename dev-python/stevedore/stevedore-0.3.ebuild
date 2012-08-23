# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="https://github.com/dreamhost/stevedore http://pypi.python.org/pypi/stevedore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute "$(PYTHON -f)" setup.py build_sphinx || die "Generation of documentation failed"
	fi
}

src_test() {
	python_execute_nosetests -P .
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/stevedore/tests"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r build/sphinx/html/
	fi
}
