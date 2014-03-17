# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="cryptography is a package designed to expose cryptographic recipes and primitives to Python developers."
HOMEPAGE="https://cryptography.io/ https://github.com/pyca/cryptography https://pypi.python.org/pypi/cryptography"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="dev-libs/openssl:0=
	$(python_abi_depend dev-python/cffi)
	$(python_abi_depend dev-python/six)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? (
		$(python_abi_depend dev-python/iso8601)
		$(python_abi_depend dev-python/pretend)
	)"

DOCS="AUTHORS.rst CONTRIBUTING.rst README.rst"
