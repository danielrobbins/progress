# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://sendapatch.se/projects/pylibmc/ http://pypi.python.org/pypi/pylibmc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libmemcached-0.32"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare
	sed -e "/with-info = 1/d" -i setup.cfg
}

src_test() {
	memcached -d -l localhost -p 11219 -P "${T}/memcached.pid"
	MEMCACHED_PORT="11219" distutils_src_test
	kill "$(<"${T}/memcached.pid")"
}
