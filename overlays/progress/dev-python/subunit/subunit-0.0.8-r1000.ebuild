# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python implementation of subunit test streaming protocol"
HOMEPAGE="https://launchpad.net/subunit http://pypi.python.org/pypi/python-subunit"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="$(python_abi_depend ">=dev-python/testtools-0.9.11")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare

	# Tests are missing in python-subunit tarball.
	cp -r "${WORKDIR}/${P}/python/subunit/tests" python/subunit

	# https://bugs.launchpad.net/subunit/+bug/996275
	sed -e "/test_run/d" -i python/subunit/tests/__init__.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="python" "$(PYTHON)" -m testtools.run subunit.test_suite
	}
	python_execute_function testing
}
