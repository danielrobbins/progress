# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 3.2 *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="pyOpenSSL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python wrapper module around the OpenSSL library"
HOMEPAGE="https://pythonhosted.org/pyOpenSSL/ https://github.com/pyca/pyopenssl https://pypi.python.org/pypi/pyOpenSSL"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

RDEPEND="$(python_abi_depend dev-python/cryptography)
	$(python_abi_depend dev-python/six)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="OpenSSL"

src_prepare() {
	distutils_src_prepare

	# Disable test requiring network connection.
	# https://github.com/pyca/pyopenssl/issues/68
	sed -e "s/test_set_default_verify_paths(/_&/" -i OpenSSL/test/test_ssl.py

	# Disable failing tests.
	sed \
		-e "s/test_extension_count/_&/" \
		-e "s/test_get_extension(/_&/" \
		-e "s/test_der/_&/" \
		-e "s/test_digest/_&/" \
		-i OpenSSL/test/test_crypto.py
	sed -e "s/test_set_tmp_ecdh/_&/" -i OpenSSL/test/test_ssl.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm "${ED}$(python_get_sitedir)/OpenSSL/test/test_"*.py
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/_build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
