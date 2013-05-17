# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="beautifulsoup4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Beautiful Soup is a Python library for pulling data out of HTML and XML files"
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/ https://launchpad.net/beautifulsoup https://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="*"
IUSE="doc html5lib +lxml"

RDEPEND="html5lib? ( $(python_abi_depend -e "3.* *-jython" dev-python/html5lib) )
	lxml? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/lxml) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS.txt NEWS.txt README.txt TODO.txt"
PYTHON_MODULES="bs4"

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
	python_execute_nosetests -e -P 'build-${PYTHON_ABI}/lib' -- -P -w 'build-${PYTHON_ABI}/lib'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/bs4/"{testing.py,tests}
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/build/html/
	fi
}
