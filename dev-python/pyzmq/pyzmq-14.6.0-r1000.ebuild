# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python bindings for ZeroMQ"
HOMEPAGE="http://www.zeromq.org/bindings:python https://github.com/zeromq/pyzmq https://pypi.python.org/pypi/pyzmq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

# Main licenses: BSD LGPL-3
# zmq/eventloop: Apache-2.0
# zmq/ssh/forward.py: LGPL-2.1
LICENSE="Apache-2.0 BSD LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples tornado"

# Minimal version of ZeroMQ required by setup.py: 2.1.4
# Minimal version of ZeroMQ required by zmq/backend/cffi/_cffi.py: 3.2.2
RDEPEND="$(python_abi_depend -e "*-pypy" dev-python/cffi:=)
	>=net-libs/zeromq-3.2.2:=
	tornado? ( $(python_abi_depend www-servers/tornado) )"
DEPEND="${RDEPEND}
	doc? (
		$(python_abi_depend dev-python/numpydoc)
		$(python_abi_depend dev-python/sphinx)
	)"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_CFFI_MODULES_GENERATION_COMMANDS=("import zmq.backend.cffi")

DOCS="AUTHORS.md README.md"
PYTHON_MODULES="zmq"

src_prepare() {
	distutils_src_prepare
	rm -r bundled

	# Disable failing tests.
	# https://github.com/zeromq/pyzmq/issues/681
	sed \
		-e "s/test_single_socket_forwarder_bind/_&/" \
		-e "s/test_single_socket_forwarder_connect/_&/" \
		-i zmq/tests/test_device.py
	# https://github.com/zeromq/pyzmq/issues/683
	sed -e "s/test_copy/_&/" -i zmq/tests/test_socket.py
	# https://github.com/zeromq/pyzmq/issues/685
	sed -e "s/test_curve/_&/" -i zmq/tests/test_security.py

	# Disable hanging test.
	# https://github.com/zeromq/pyzmq/issues/682
	sed -e "s/test_tracker/_&/" -i zmq/tests/test_socket.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		PYTHONPATH="$(ls -d ../build-$(PYTHON -f --ABI)/lib*)" emake html
		popd > /dev/null
	fi
}

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib.*)' -- -s -w '$(ls -d build-${PYTHON_ABI}/lib.*/zmq/tests)'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm "${ED}$(python_get_sitedir)/zmq/tests/"test_*.py
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r docs/build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
