# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_DEPEND="<<[{*-cpython}xml]>>"
PYTHON_RESTRICTED_ABIS="2.6 3.1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Markdown"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python implementation of Markdown."
HOMEPAGE="https://pythonhosted.org/Markdown/ https://github.com/waylan/Python-Markdown https://pypi.python.org/pypi/Markdown"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc pygments"

DEPEND="$(python_abi_depend dev-python/pyyaml)
	pygments? ( $(python_abi_depend dev-python/pygments) )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r "build-$(PYTHON -f --ABI)/docs/"
	fi
}
