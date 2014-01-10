# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

DESCRIPTION="Python bindings for cURL library"
HOMEPAGE="http://pycurl.sourceforge.net/ https://github.com/pycurl/pycurl https://pypi.python.org/pypi/pycurl"
SRC_URI="http://pycurl.sourceforge.net/download/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="curl_ssl_gnutls curl_ssl_nss +curl_ssl_openssl examples ssl"

DEPEND=">=net-misc/curl-7.25.0-r1[ssl=]
	ssl? ( net-misc/curl[curl_ssl_gnutls=,curl_ssl_nss=,curl_ssl_openssl=,-curl_ssl_axtls,-curl_ssl_cyassl,-curl_ssl_polarssl] )"
RDEPEND="${DEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODULES="curl"

src_prepare() {
	distutils_src_prepare
	sed -e "/setup_args\['data_files'\] = get_data_files()/d" -i setup.py || die "sed failed"
}

src_test() {
	distutils_src_test tests/{easy_test.py,error_test.py,global_init_test.py,internals_test.py,memory_mgmt_test.py,option_constants_test.py,pycurl_object_test.py,unset_range_test.py,version_comparison_test.py,version_test.py,write_abort_test.py,write_cb_bogus_test.py}
}

src_install() {
	distutils_src_install

	dohtml -r doc/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples tests
	fi
}
