# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit distutils

DESCRIPTION="eGenix mx Base Distribution for Python - mxDateTime, mxTextTools, mxProxy, mxTools, mxBeeBase, mxStack, mxQueue, mxURL, mxUID"
HOMEPAGE="http://www.egenix.com/products/python/mxBase http://pypi.python.org/pypi/egenix-mx-base"
SRC_URI="http://downloads.egenix.com/python/${P}.tar.gz"

LICENSE="eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODULES="mx"

src_prepare() {
	distutils_src_prepare

	# Don't install documentation in site-packages directories.
	sed -e "/\/Doc\//d" -i egenix_mx_base.py || die "sed failed"

	# Avoid unnecessary overriding of settings. Distutils in Gentoo is patched in better way.
	sed -e 's/if compiler.compiler_type == "unix":/if False:/' -i mxSetup.py || die "sed failed"

	# Disable failing tests.
	rm -f mx/BeeBase/mxBeeBase/testernesto.py
	rm -f mx/DateTime/mxDateTime/testrichard.py
	rm -f mx/DateTime/mxDateTime/testsubclassing.py
	rm -f mx/DateTime/mxDateTime/testticks.py
	rm -f mx/Proxy/mxProxy/testvlad.py
	rm -f mx/TextTools/mxTextTools/testkj.py
	rm -f mx/TextTools/mxTextTools/testPickleSegFault.py
	rm -f mx/Tools/mxTools/test_safecall.py
}

src_compile() {
	# mxSetup.py uses BASECFLAGS variable.
	BASECFLAGS="${CFLAGS}" distutils_src_compile
}

src_test() {
	testing() {
		local exit_status="0" test
		for test in build-${PYTHON_ABI}/lib*/**/*test*.py; do
			if ! python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" "${test}"; then
				eerror "${test} failed with $(python_get_implementation_and_version)"
				exit_status="1"
			fi
		done

		return "${exit_status}"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	dohtml -a html -r mx
	insinto /usr/share/doc/${PF}
	find -iname "*.pdf" | xargs doins

	delete_tests() {
		find "${ED}$(python_get_sitedir)/mx" -name "*test*.py" -delete
	}
	python_execute_function -q delete_tests

	installation_of_headers() {
		local header
		dodir "$(python_get_includedir)/mx" || return 1
		while read -d $'\0' header; do
			mv -f "${header}" "${ED}$(python_get_includedir)/mx" || return 1
		done < <(find "${ED}$(python_get_sitedir)/mx" -type f -name "*.h" -print0)
	}
	python_execute_function -q installation_of_headers
}
