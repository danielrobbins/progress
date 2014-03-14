# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[{*-cpython}xml]>>"
PYTHON_MULTIPLE_ABIS="1"
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

DEPEND=""
RDEPEND="pygments? ( $(python_abi_depend dev-python/pygments) )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare

	# https://github.com/waylan/Python-Markdown/issues/294
	sed -e "s/self.assertIs(markdown.util.parseBoolValue(value, False), result)/self.assertTrue(markdown.util.parseBoolValue(value, False) is result)/" -i tests/test_apis.py

	# https://github.com/waylan/Python-Markdown/issues/295
	# https://github.com/waylan/Python-Markdown/commit/4ca11effd18372dc6b5e8cf852130a7e75c27eb6
	sed -e "s/^closeClass = r/closeClass = /" -i markdown/extensions/smarty.py
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r "build-$(PYTHON -f --ABI)/docs/"
	fi
}
