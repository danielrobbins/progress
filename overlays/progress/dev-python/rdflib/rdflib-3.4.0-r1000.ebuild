# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="RDFLib is a Python library for working with RDF, a simple yet powerful language for representing information."
HOMEPAGE="https://github.com/RDFLib/rdflib http://pypi.python.org/pypi/rdflib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="berkdb examples html5lib"

RDEPEND="$(python_abi_depend dev-python/isodate)
	berkdb? ( $(python_abi_depend -e "*-jython" dev-python/bsddb3) )
	html5lib? ( $(python_abi_depend -e "3.* *-jython" dev-python/html5lib) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGELOG CONTRIBUTORS"

src_prepare() {
	distutils_src_prepare
	find -name "*.py[c~]" -delete

	# Delete dependency on dev-python/html5lib.
	sed \
		-e "/kwargs\['tests_require'\] = \['html5lib'\]/d" \
		-e "s/kwargs\['install_requires'\] = \['isodate', 'html5lib'\]/kwargs['install_requires'] = ['isodate']/" \
		-i setup.py
}

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib)' -- -P -w '$([[ "$(python_get_version -l --major)" == "3" ]] && echo build/src || echo .)'
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
