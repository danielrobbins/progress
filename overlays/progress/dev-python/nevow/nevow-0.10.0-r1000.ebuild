# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython"
DISTUTILS_SRC_TEST="trial formless nevow"
DISTUTILS_DISABLE_TEST_DEPENDENCY="1"

inherit twisted

MY_PN="Nevow"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A web templating framework that provides LivePage, an automatic AJAX toolkit."
HOMEPAGE="https://launchpad.net/nevow http://pypi.python.org/pypi/Nevow"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86 ~x86-linux"
IUSE="doc"

DEPEND="$(python_abi_depend dev-python/twisted)
	$(python_abi_depend dev-python/twisted-web)
	$(python_abi_depend net-zope/zope.interface)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="formless nevow"
TWISTED_PLUGINS="nevow.plugins"

src_test() {
	TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE="1" distutils_src_test
}

src_install() {
	distutils_src_install

	doman doc/man/nevow-xmlgettext.1
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/{howto,html,old} examples
	fi
	rm -fr "${ED}usr/doc"
}
