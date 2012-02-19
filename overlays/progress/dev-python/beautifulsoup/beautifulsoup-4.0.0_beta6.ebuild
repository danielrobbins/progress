# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
# https://bugs.launchpad.net/beautifulsoup/+bug/936006
PYTHON_TESTS_RESTRICTED_ABIS="*-jython *-pypy-*"
# https://bugs.launchpad.net/beautifulsoup/+bug/933860
# https://bugs.launchpad.net/beautifulsoup/+bug/935710
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="beautifulsoup4"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="HTML/XML parser for quick-turnaround applications like screen-scraping."
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/ https://launchpad.net/beautifulsoup http://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="http://www.crummy.com/software/BeautifulSoup/bs4/download/4.0/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="html5lib +lxml test"
# https://bugs.launchpad.net/beautifulsoup/+bug/936006
REQUIRED_USE="test? ( lxml )"

DEPEND="html5lib? ( $(python_abi_depend -e "3.* *-jython" dev-python/html5lib) )
	lxml? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/lxml) )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="bs4"

src_prepare() {
	distutils_src_prepare

	# https://bugs.launchpad.net/beautifulsoup/+bug/935919
	sed -e "/data_files=\[/,+1d" -i setup.py || die "sed failed"
}

src_test() {
	python_execute_nosetests -e -P 'build-${PYTHON_ABI}/lib' -- -P -w 'build-${PYTHON_ABI}/lib'
}

src_install() {
	distutils_src_install

	# https://bugs.launchpad.net/beautifulsoup/+bug/935720
	delete_documentation_and_tests() {
		rm -fr "${ED}$(python_get_sitedir)/bs4/"{doc,testing.py,tests}
	}
	python_execute_function -q delete_documentation_and_tests
}
