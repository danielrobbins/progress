# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="<<[ssl?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="Python FTP server library"
HOMEPAGE="http://code.google.com/p/pyftpdlib/ http://pypi.python.org/pypi/pyftpdlib"
SRC_URI="http://pyftpdlib.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="examples pysendfile ssl"

RDEPEND="pysendfile? ( $(python_abi_depend -e "*-jython" dev-python/pysendfile) )
	ssl? ( $(python_abi_depend -e "*-jython" dev-python/pyopenssl) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CREDITS HISTORY"

src_test() {
	testing() {
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_contrib.py || return
		python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_ftpd.py || return
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demo test
	fi
}
