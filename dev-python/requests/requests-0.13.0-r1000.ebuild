# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"

inherit distutils

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="http://python-requests.org/ https://github.com/kennethreitz/requests http://pypi.python.org/pypi/requests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="$(python_abi_depend ">=dev-python/certifi-0.0.7")
	$(python_abi_depend dev-python/chardet)
	$(python_abi_depend -i "2.*" "=dev-python/oauthlib-0.1*")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="HISTORY.rst README.rst"

src_prepare() {
	distutils_src_prepare

	# https://github.com/kennethreitz/requests/issues/600
	sed \
		-e "s/self.assertIn('preview', s.cookies)/self.assertTrue('preview' in s.cookies)/" \
		-e "121s/self.assertNotIn('preview', json.loads(r2.text)\['cookies'\])/self.assertTrue('preview' not in json.loads(r2.text)['cookies'])/" \
		-e "127s/self.assertNotIn('preview', json.loads(r2.text)\['cookies'\])/self.assertTrue('preview' not in json.loads(r3.text)['cookies'])/" \
		-i tests/test_requests_ext.py
}

src_test() {
	testing() {
		local exit_status="0"

		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/test_cookies.py -v || exit_status="1"
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/test_requests.py -v || exit_status="1"
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/test_requests_ext.py -v || exit_status="1"
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/test_requests_https.py -v || exit_status="1"

		return "${exit_status}"
	}
	python_execute_function testing
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "requests.async module has been deleted in favor of dev-python/grequests."
}
