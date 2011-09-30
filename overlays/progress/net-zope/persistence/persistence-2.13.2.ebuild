# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Persistence"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Persistent ExtensionClass"
HOMEPAGE="http://pypi.python.org/pypi/Persistence"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/extensionclass)
	$(python_abi_depend net-zope/zodb)"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

PYTHON_MODULES="${MY_PN}"

distutils_src_test_pre_hook() {
	local module
	for module in Persistence; do
		ln -fs "../../$(ls -d build-${PYTHON_ABI}/lib.*)/${module}/_${module}$(python_get_extension_module_suffix)" "src/${module}/_${module}$(python_get_extension_module_suffix)" || die "Symlinking ${module}/_${module}$(python_get_extension_module_suffix) failed with $(python_get_implementation_and_version)"
	done
}

src_install() {
	distutils_src_install
	python_clean_installation_image
}
