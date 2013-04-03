# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython"
MY_PACKAGE="Mail"

inherit twisted versionator

DESCRIPTION="A Twisted Mail library, server and client"

KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend "=dev-python/twisted-$(get_version_component_range 1-2)*")
	$(python_abi_depend "=dev-python/twisted-names-$(get_version_component_range 1-2)*")"
RDEPEND="${DEPEND}"

PYTHON_MODULES="twisted/mail twisted/plugins"
