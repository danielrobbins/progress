# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="Non-validating SQL parser"
HOMEPAGE="https://github.com/andialbrecht/sqlparse https://pypi.python.org/pypi/sqlparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

DEPEND="$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"
RDEPEND=""

src_prepare() {
	distutils_src_prepare
	sed -e "/^sys.path.insert/d" -i docs/source/conf.py
}

src_compile() {
	distutils_src_compile

	preparation() {
		cp -r tests build-${PYTHON_ABI} || return

		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs build-${PYTHON_ABI}/tests || return
		fi
	}
	python_execute_function -q preparation

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		PYTHONPATH="../build-$(PYTHON -f --ABI)/lib" emake html
		popd > /dev/null
	fi
}

src_test() {
	python_execute_py.test -e -P 'build-${PYTHON_ABI}/lib' 'build-${PYTHON_ABI}/tests'
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/build/html/
	fi
}
