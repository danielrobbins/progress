# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A simple schema-based serialization and deserialization library"
HOMEPAGE="http://docs.repoze.org/colander http://pypi.python.org/pypi/colander"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="$(python_abi_depend dev-python/iso8601)
	$(python_abi_depend dev-python/translationstring)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( dev-python/sphinx )"

DOCS="CHANGES.txt README.txt"

src_prepare() {
	distutils_src_prepare

	# Fix Sphinx theme.
	sed -e "s/html_theme = 'pylons'/html_theme = 'default'/" -i docs/conf.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		mkdir _themes
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/colander/tests.py"
	}
	python_execute_function -q delete_tests

	if use doc; then
		pushd docs/_build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static
		popd > /dev/null
	fi
}
