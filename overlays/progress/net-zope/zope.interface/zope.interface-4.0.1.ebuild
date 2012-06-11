# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Interfaces for Python"
HOMEPAGE="http://pypi.python.org/pypi/zope.interface"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${PN}-3.8.0.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	!<net-zope/zope-interface-1000"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? (
		dev-python/repoze.sphinx.autointerface[python_abis_2.7]
		dev-python/sphinx[python_abis_2.7]
	)
	test? ( $(python_abi_depend net-zope/zope.event) )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DOCS="CHANGES.txt"
PYTHON_MODULES="${PN/.//}"

src_prepare() {
	epatch "${FILESDIR}/${P}-python-3.1.patch"

	preparation() {
		if [[ "$(python_get_version -l)" == "2.5" ]]; then
			cp -fr "${WORKDIR}/${PN}-3.8.0" "${WORKDIR}/${P}-${PYTHON_ABI}"
		else
			cp -fr "${WORKDIR}/${P}" "${WORKDIR}/${P}-${PYTHON_ABI}"
		fi
	}
	python_execute_function preparation
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html SPHINXBUILD="sphinx-build-2.7"
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install
	python_clean_installation_image

	if use doc; then
		pushd docs/_build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _modules _static
		popd > /dev/null
	fi
}
