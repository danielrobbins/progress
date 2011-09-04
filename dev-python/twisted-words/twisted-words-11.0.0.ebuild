# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"
MY_PACKAGE="Words"

inherit twisted

DESCRIPTION="Twisted Words contains Instant Messaging implementations."

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ~ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="$(python_abi_depend "=dev-python/twisted-$(get_version_component_range 1)*")
	$(python_abi_depend "=dev-python/twisted-web-$(get_version_component_range 1)*")"
RDEPEND="${DEPEND}"

PYTHON_MODULES="twisted/plugins twisted/words"

src_prepare() {
	distutils_src_prepare

	# Delete documentation for no longer available "im" script.
	rm -fr doc/man
}
