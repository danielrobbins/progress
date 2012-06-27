# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="trial"
DISTUTILS_DISABLE_TEST_DEPENDENCY="1"

inherit distutils

DESCRIPTION="RPC protocol for Twisted"
HOMEPAGE="http://foolscap.lothar.com/trac http://pypi.python.org/pypi/foolscap"
SRC_URI="http://${PN}.lothar.com/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc ssl"

RDEPEND="$(python_abi_depend dev-python/twisted)
	$(python_abi_depend dev-python/twisted-web)
	ssl? ( $(python_abi_depend dev-python/pyopenssl) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( dev-python/twisted-lore )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		emake docs
	fi
}

src_test() {
	LC_ALL="C" distutils_src_test
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/foolscap/test"
	}
	python_execute_function -q delete_tests

	if use doc; then
		dodoc doc/*.txt
		dohtml -a css,html,py -r doc/*
	fi
}
