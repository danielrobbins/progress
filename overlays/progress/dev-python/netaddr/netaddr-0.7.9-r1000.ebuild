# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr http://pypi.python.org/pypi/netaddr"
SRC_URI="mirror://github/drkjam/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli"

DEPEND="cli? ( $(python_abi_depend -e "2.5 *-jython" dev-python/ipython) )"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare

	# https://github.com/drkjam/netaddr/issues/33
	sed -e "s/if sys.version_info\[0\] == 3:/if False:/" -i setup.py

	# https://github.com/drkjam/netaddr/issues/34
	sed \
		-e "s/from netaddr.compat import _dict_items/&, _callable/" \
		-e "s/if callable/if _callable/" \
		-i netaddr/ip/iana.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" netaddr/tests/__init__.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if ! use cli; then
		rm -f "${ED}usr/bin/netaddr"*
	fi
}
