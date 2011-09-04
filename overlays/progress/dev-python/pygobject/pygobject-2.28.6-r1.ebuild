# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="xz"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5 *-jython *-pypy-*"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

# XXX: Is the alternatives stuff needed anymore?
inherit alternatives autotools gnome2 python virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +cairo examples +introspection libffi test"

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	introspection? (
		>=dev-libs/gobject-introspection-0.10.2
		cairo? ( $(python_abi_depend ">=dev-python/pycairo-1.2.0") ) )
	libffi? ( virtual/libffi )"
DEPEND="${COMMON_DEPEND}
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc )
	>=dev-util/pkgconfig-0.12"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13"

pkg_setup() {
	python_pkg_setup

	DOCS="AUTHORS ChangeLog* NEWS README"
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		$(use_enable doc docs)
		$(use_enable cairo)
		$(use_enable introspection)
		$(use_with libffi ffi)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix FHS compliance, see upstream bug #535524
	epatch "${FILESDIR}/${PN}-2.28.3-fix-codegen-location.patch"

	# Do not build tests if unneeded, bug #226345
	epatch "${FILESDIR}/${PN}-2.28.3-make_check.patch"

	# Support installation for multiple Python versions, upstream bug #648292
	epatch "${FILESDIR}/${PN}-2.28.3-support_multiple_python_versions.patch"

	# Disable tests that fail
	epatch "${FILESDIR}/${PN}-2.28.3-disable-failing-tests.patch"

	epatch "${FILESDIR}/${P}-python-3.patch"
	epatch "${FILESDIR}/${P}-python-3-codegen.patch"

	# disable pyc compiling
	ln -sfn $(type -P true) py-compile

	eautoreconf

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -d -s
}

# FIXME: With python multiple ABI support, tests return 1 even when they pass
src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		XDG_CACHE_HOME="${T}/$(PYTHON --ABI)"
		Xemake check PYTHON=$(PYTHON -a)
	}
	python_execute_function -s testing
}

src_install() {
	installation() {
		GNOME2_DESTDIR="${T}/images/${PYTHON_ABI}/" gnome2_src_install
		mv "${T}/images/${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)/pygtk.py"{,-2.0}
		mv "${T}/images/${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)/pygtk.pth"{,-2.0}

		if [[ "${PYTHON_ABI}" == 3.* ]]; then
			rm -f "${T}/images/${PYTHON_ABI}${EPREFIX}/usr/$(get_libdir)/pkgconfig/pygobject-2.0.pc"
		fi
	}
	python_execute_function -s installation
	python_merge_intermediate_installation_images "${T}/images"

	python_clean_installation_image

	if [[ -f "${ED}usr/bin/pygobject-codegen-2.0" ]]; then
		sed -e "s:/usr/bin/python:&2:" -i "${ED}usr/bin/pygobject-codegen-2.0" || die "Fixing of calls to Python interpreter failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples
	fi
}

pkg_postinst() {
	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.py" pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.pth" pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks

	python_mod_optimize $(use introspection && echo gi) glib gobject gtk-2.0 pygtk.py
}

pkg_postrm() {
	python_mod_cleanup $(use introspection && echo gi) glib gobject gtk-2.0 pygtk.py

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.py" pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.pth" pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks
}
