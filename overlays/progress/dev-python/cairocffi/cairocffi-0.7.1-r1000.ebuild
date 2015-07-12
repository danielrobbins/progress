# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 *-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="cffi-based cairo bindings for Python"
HOMEPAGE="https://github.com/SimonSapin/cairocffi https://pypi.python.org/pypi/cairocffi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="dev-libs/glib:2=
	$(python_abi_depend -e "*-pypy" ">=dev-python/cffi-1.1.0:=")
	$(python_abi_depend ">=dev-python/xcffib-0.3.2")
	x11-libs/cairo:0=
	x11-libs/gdk-pixbuf:2=[jpeg]"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_prepare() {
	distutils_src_prepare

	# Disable failing tests.
	sed -e "s/test_glyphs/_&/" -i cairocffi/test_cairo.py
	sed \
		-e "s/test_xcb_pixmap/_&/" \
		-e "s/test_xcb_window/_&/" \
		-i cairocffi/test_xcb.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		PYTHONPATH="build-$(PYTHON -f --ABI)/lib" "$(PYTHON -f)" setup.py build_sphinx
	fi
}

src_test() {
	distutils_src_test cairocffi
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm "${ED}$(python_get_sitedir)/cairocffi/test_"*.py
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
