# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.* *-jython"
PYTHON_NAMESPACES="logilab"

inherit distutils python-namespaces

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="http://www.logilab.org/projects/common/ http://pypi.python.org/pypi/logilab-common"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="$(python_abi_depend dev-python/setuptools)
	$(python_abi_depend -i "2.4 2.5 2.6 3.1" dev-python/unittest2)"
# Tests using dev-python/psycopg are skipped when dev-python/psycopg is not installed.
DEPEND="${RDEPEND}
	test? (
		$(python_abi_depend -e "3.* *-jython" dev-python/egenix-mx-base)
		!dev-python/psycopg[-mxdatetime]
	)"

S="${WORKDIR}/${P}"

PYTHON_MODULES="logilab"

src_test() {
	testing() {
		local tpath="${T}/test-${PYTHON_ABI}"
		local spath="${tpath}${EPREFIX}$(python_get_sitedir)"

		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --root="${tpath}" || die "Installation for tests failed with $(python_get_implementation_and_version)"

		# pytest uses tests placed relatively to the current directory.
		pushd "${spath}" > /dev/null || return 1
		PYTHONPATH="${spath}" "$(PYTHON)" "${tpath}${EPREFIX}/usr/bin/pytest" -v || return 1
		popd > /dev/null || return 1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	python-namespaces_src_install

	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/pytest"

	doman doc/pytest.1

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/${PN/-//}/test"
	}
	python_execute_function -q delete_tests
}

pkg_postinst() {
	distutils_pkg_postinst
	python-namespaces_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	python-namespaces_pkg_postrm
}
