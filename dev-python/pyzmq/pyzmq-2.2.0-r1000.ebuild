# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="PyZMQ is a lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="http://www.zeromq.org/bindings:python http://pypi.python.org/pypi/pyzmq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

# Main licenses: BSD LGPL-3
# zmq/eventloop: Apache-2.0
# zmq/ssh/forward.py: LGPL-2.1
LICENSE="Apache-2.0 BSD LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples tornado"

# Minimal version of net-libs/zeromq specified in zmq.core.version.__version__.
DEPEND=">=net-libs/zeromq-2.2.0
	tornado? ( $(python_abi_depend -e "3.1" www-servers/tornado) )"
RDEPEND="${DEPEND}"

DOCS="README.rst"
PYTHON_MODULES="zmq"

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib.*)' -- -s -w '$(ls -d build-${PYTHON_ABI}/lib.*/zmq/tests)'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/zmq/tests/"test_*.py
	}
	python_execute_function -q delete_tests

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
