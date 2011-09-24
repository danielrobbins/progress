# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://sphinx.pocoo.org/ http://pypi.python.org/pypi/Sphinx"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc latex"

DEPEND="$(python_abi_depend ">=dev-python/docutils-0.5")
	$(python_abi_depend ">=dev-python/jinja-2.2")
	$(python_abi_depend ">=dev-python/pygments-0.8")
	$(python_abi_depend dev-python/setuptools)
	latex? ( dev-texlive/texlive-latexextra )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES"

src_compile() {
	distutils_src_compile

	if use doc; then
		pushd doc > /dev/null
		einfo "Generation of documentation"
		PYTHONPATH=".." emake SPHINXBUILD="$(PYTHON -f) ../sphinx-build.py" html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -A txt -r doc/_build/html/*
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	# Generate the Grammar pickle to avoid sandbox violations.
	generation_of_grammar_pickle() {
		"$(PYTHON)" -c "import sys; sys.path.insert(0, '${EROOT}$(python_get_sitedir -b)'); from sphinx.pycode.pgen2.driver import load_grammar; load_grammar('${EROOT}$(python_get_sitedir -b)/sphinx/pycode/Grammar.txt')"
	}
	python_execute_function \
		--action-message 'Generation of Grammar pickle with $(python_get_implementation_and_version)...' \
		--failure-message 'Generation of Grammar pickle with $(python_get_implementation_and_version) failed' \
		generation_of_grammar_pickle
}

pkg_postrm() {
	distutils_pkg_postrm

	deletion_of_grammar_pickle() {
		rm -f "${EROOT}$(python_get_sitedir -b)/sphinx/pycode"/Grammar*.pickle || return 1

		# Delete empty parent directories.
		local dir="${EROOT}$(python_get_sitedir -b)/sphinx/pycode"
		while [[ "${dir}" != "${EROOT%/}" ]]; do
			rmdir "${dir}" 2> /dev/null || break
			dir="${dir%/*}"
		done
	}
	python_execute_function \
		--action-message 'Deletion of Grammar pickle with $(python_get_implementation_and_version)...' \
		--failure-message 'Deletion of Grammar pickle with $(python_get_implementation_and_version) failed' \
		deletion_of_grammar_pickle
}
