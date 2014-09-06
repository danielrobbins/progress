# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_BDEPEND="test? ( <<[{*-cpython *-pypy-*}sqlite]>> )"
PYTHON_DEPEND="<<[{*-cpython *-pypy-*}sqlite?]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.6 3.1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
WEBAPP_NO_AUTO_INSTALL="yes"

inherit bash-completion-r1 distutils git-2 webapp

DESCRIPTION="High-level Python web framework"
HOMEPAGE="http://www.djangoproject.com/ https://github.com/django/django https://pypi.python.org/pypi/Django"
SRC_URI=""
EGIT_REPO_URI="https://github.com/django/django"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc mysql postgres sqlite test"

RDEPEND="$(python_abi_depend -e "*-jython" dev-python/imaging)
	$(python_abi_depend dev-python/setuptools)
	mysql? ( $(python_abi_depend -e "3.* *-jython" dev-python/mysql-python) )
	postgres? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/psycopg:2) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	python_pkg_setup
	webapp_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	# Disable invalid warning.
	sed -e "s/overlay_warning = True/overlay_warning = False/" -i setup.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		# Tests have non-standard assumptions about PYTHONPATH and work not with usual "build-${PYTHON_ABI}/lib".
		python_execute PYTHONPATH="." "$(PYTHON)" tests/runtests.py --settings=test_sqlite -v1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	newbashcomp extras/django_bash_completion ${PN}

	if use doc; then
		dohtml -r docs/_build/html/
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r django/contrib/admin/static/admin/*

	webapp_src_install
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "A copy of the admin media is available to webapp-config for installation in a webroot,"
	elog "as well as the traditional location in Python's site-packages directory for easy development."
	webapp_pkg_postinst
}
