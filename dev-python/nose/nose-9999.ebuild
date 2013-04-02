# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.5 2.6 *-jython"

inherit distutils eutils git-2

DESCRIPTION="nose extends unittest to make testing easier"
HOMEPAGE="https://nose.readthedocs.org/ https://github.com/nose-devs/nose https://pypi.python.org/pypi/nose"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nose-devs/nose"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

RDEPEND="$(python_abi_depend dev-python/coverage)
	$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( || (
		dev-python/sphinx[python_abis_2.7]
		dev-python/sphinx[python_abis_2.6]
		dev-python/sphinx[python_abis_2.5]
	) )
	test? ( $(python_abi_depend -e "2.5 3.* *-jython" dev-python/twisted) )"

DOCS="AUTHORS"

src_prepare() {
	distutils_src_prepare

	# Disable usage of sphinx.ext.intersphinx, which requires network connection.
	epatch "${FILESDIR}/${PN}-0.11.0-disable_intersphinx.patch"

	# Disable tests requiring network connection.
	sed \
		-e "s/test_resolve/_&/g" \
		-e "s/test_raises_bad_return/_&/g" \
		-e "s/test_raises_twisted_error/_&/g" \
		-i unit_tests/test_twisted.py || die "sed failed"

	# Disable versioning of nosetests script to avoid collision with versioning performed by python_merge_intermediate_installation_images().
	sed -e "/'nosetests%s = nose:run_exit' % py_vers_tag,/d" -i setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		# https://github.com/nose-devs/nose/issues/481
		if ROOT="/" has_version "dev-python/sphinx[python_abis_2.7]"; then
			emake html SPHINXBUILD="sphinx-build-2.7"
		elif ROOT="/" has_version "dev-python/sphinx[python_abis_2.6]"; then
			emake html SPHINXBUILD="sphinx-build-2.6"
		else
			emake html SPHINXBUILD="sphinx-build-2.5"
		fi
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			rm -fr build || return
			python_execute "$(PYTHON)" setup.py build_tests || return
		fi

		python_execute "$(PYTHON)" setup.py egg_info || return
		python_execute "$(PYTHON)" selftest.py -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install --install-data "${EPREFIX}/usr/share"

	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/nosetests"

	if use doc; then
		dohtml -r doc/.build/html/
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
