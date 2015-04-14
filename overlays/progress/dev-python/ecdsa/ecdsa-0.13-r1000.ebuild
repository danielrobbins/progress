# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="ECDSA cryptographic signature library (pure python)"
HOMEPAGE="https://github.com/warner/python-ecdsa https://pypi.python.org/pypi/ecdsa"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="$(python_abi_depend dev-python/six)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( dev-libs/openssl:0 )"

src_prepare() {
	distutils_src_prepare

	# Use system version of dev-python/six.
	sed \
		-e "s/from .six import/from six import/" \
		-e "s/from .six.moves import/from six.moves import/" \
		-i ecdsa/*.py
	sed -e "s/, \"six\"//" -i ecdsa/__init__.py
	rm ecdsa/six.py
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm "${ED}$(python_get_sitedir)/ecdsa/test_pyecdsa.py"
	}
	python_execute_function delete_tests
}
