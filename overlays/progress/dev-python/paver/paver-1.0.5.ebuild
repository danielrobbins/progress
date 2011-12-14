# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Paver"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easy build, distribution and deployment scripting"
HOMEPAGE="http://pypi.python.org/pypi/Paver"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	delete_documentation_and_incompatible_modules() {
		rm -fr "${ED}$(python_get_sitedir)/paver/docs" || return 1

		if [[ "$(python_get_version -l)" == "2.4" ]]; then
			rm -f "${ED}$(python_get_sitedir)/paver/path25.py" || return 1
		fi
	}
	python_execute_function -q delete_documentation_and_incompatible_modules

	if use doc; then
		pushd paver/docs > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _images _static
		popd > /dev/null
	fi
}
