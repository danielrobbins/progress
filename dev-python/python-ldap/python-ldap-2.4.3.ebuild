# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils multilib

DOC_P="${PN}-docs-html-${PV}"

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="http://python-ldap.sourceforge.net/ http://pypi.python.org/pypi/python-ldap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? ( http://www.python-ldap.org/doc/${DOC_P}.tar.gz )"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE="doc examples sasl ssl"

RDEPEND=">=net-nds/openldap-2.4.11
	sasl? ( dev-libs/cyrus-sasl )"
DEPEND="${DEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES README"
PYTHON_MODULES="dsml.py ldap ldapurl.py ldif.py"

src_prepare() {
	local rpath
	[[ "${CHOST}" != *-darwin* ]] && rpath="-Wl,-rpath=${EPREFIX}/usr/$(get_libdir)/sasl2"

	sed \
		-e "s:^\(library_dirs =\).*:\1:" \
		-e "s:^\(include_dirs =\).*:\1 ${EPREFIX}/usr/include/sasl:" \
		-e "s:^\(extra_compile_args =\).*:\1:" \
		-e "/^extra_compile_args/a extra_link_args = ${rpath}" \
		-i setup.cfg || die "sed failed"

	local mylibs="ldap"
	if use sasl; then
		use ssl && mylibs="ldap_r"
		mylibs+=" sasl2"
	fi
	use ssl && mylibs+=" ssl crypto"

	sed -e "s:^\(libs =\).*:\1 lber resolv ${mylibs}:" -i setup.cfg || die "sed failed"
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r "${WORKDIR}/${DOC_P}"/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Demo/*
	fi
}
