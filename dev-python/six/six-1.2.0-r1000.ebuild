# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="Python 2 and 3 compatibility utilities"
HOMEPAGE="http://pypi.python.org/pypi/six"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="doc? ( $(python_abi_depend dev-python/sphinx) )"
RDEPEND=""

PYTHON_MODULES="six.py"

src_prepare() {
	distutils_src_prepare

	# Compatibility with Jython
	# https://bitbucket.org/gutworth/six/issue/11
	# https://bitbucket.org/gutworth/six/changeset/cc84a84e05ffda4b8c252c8395004f46d26152bb
	sed -e 's/if sys.platform == "java":/if sys.platform.startswith("java"):/' -i six.py

	# Disable tests requiring Tkinter.
	sed -e "s/test_move_items/_&/" -i test_six.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd documentation > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r documentation/_build/html/
	fi
}
