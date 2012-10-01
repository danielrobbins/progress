# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit eutils python qt4-r2 toolchain-funcs

# Minimal supported version of Qt.
QT_VER="4.7.2"

DESCRIPTION="Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/ http://pypi.python.org/pypi/PyQt"

if [[ "${PV}" == *_pre* ]]; then
	MY_P="PyQt-x11-gpl-snapshot-${PV%_pre*}-${REVISION}"
	SRC_URI="http://www.gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"
else
	MY_P="PyQt-x11-gpl-${PV}"
	SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
# Subslot is "_"-separated, alphabetically sorted list of "${module_name}-${module_version}" strings
# for PyQt4 modules with non-negative versions set by "version" argument of %Module directive:
# $ grep -E "^[[:space:]]*%Module\(" sip/*/*.sip | sort
# http://www.riverbankcomputing.co.uk/static/Docs/sip4/directives.html#directive-%Module
SLOT="0/QtCore-1"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="X dbus debug declarative doc examples help kde multimedia opengl phonon script scripttools sql svg webkit xmlpatterns"
REQUIRED_USE="
	declarative? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	webkit? ( X )"

RDEPEND="$(python_abi_depend ">=dev-python/sip-4.14:0=")
	>=x11-libs/qt-core-${QT_VER}:4
	X? (
		>=x11-libs/qt-gui-${QT_VER}:4[dbus?]
		>=x11-libs/qt-test-${QT_VER}:4
	)
	dbus? (
		$(python_abi_depend -e "2.5" ">=dev-python/dbus-python-0.80")
		>=x11-libs/qt-dbus-${QT_VER}:4
	)
	declarative? ( >=x11-libs/qt-declarative-${QT_VER}:4 )
	help? ( >=x11-libs/qt-assistant-${QT_VER}:4 )
	multimedia? ( >=x11-libs/qt-multimedia-${QT_VER}:4 )
	opengl? (
		>=x11-libs/qt-opengl-${QT_VER}:4
		|| ( >=x11-libs/qt-opengl-4.8.0:4 <x11-libs/qt-opengl-4.8.0:4[-egl] )
	)
	phonon? (
		!kde? ( || ( >=x11-libs/qt-phonon-${QT_VER}:4 media-libs/phonon ) )
		kde? ( media-libs/phonon )
	)
	script? ( >=x11-libs/qt-script-${QT_VER}:4 )
	sql? ( >=x11-libs/qt-sql-${QT_VER}:4 )
	svg? ( >=x11-libs/qt-svg-${QT_VER}:4 )
	webkit? ( >=x11-libs/qt-webkit-${QT_VER}:4 )
	xmlpatterns? ( >=x11-libs/qt-xmlpatterns-${QT_VER}:4 )"
DEPEND="${RDEPEND}
	dbus? ( virtual/pkgconfig )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-4.7.2-configure.py.patch"
)

PYTHON_VERSIONED_EXECUTABLES=("/usr/bin/pyuic4")

src_prepare() {
	if ! use dbus; then
		sed -e "s/^\([[:blank:]]\+\)check_dbus()/\1pass/" -i configure.py || die "sed configure.py failed"
	fi

	# Support qreal for arm architecture (bug #322349).
	use arm && epatch "${FILESDIR}/${PN}-4.7.3-qreal_float_support.patch"

	qt4-r2_src_prepare

	# Use proper include directory.
	sed -e "s:/usr/include:${EPREFIX}/usr/include:g" -i configure.py || die "sed configure.py failed"

	python_copy_sources

	preparation() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			rm -fr pyuic/uic/port_v2
		else
			rm -fr pyuic/uic/port_v3
		fi
	}
	python_execute_function -s preparation
}

pyqt4_use_enable() {
	use $1 && echo "--enable=${2:-$1}"
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			--confirm-license
			--bindir="${EPREFIX}/usr/bin"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			--assume-shared
			--no-timestamp
			--qsci-api
			$(use debug && echo --debug)
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtXml
			$(pyqt4_use_enable X QtDesigner) $(use X || echo --no-designer-plugin)
			$(pyqt4_use_enable X QtGui)
			$(pyqt4_use_enable X QtTest)
			$(pyqt4_use_enable dbus QtDBus)
			$(pyqt4_use_enable declarative QtDeclarative)
			$(pyqt4_use_enable help QtHelp)
			$(pyqt4_use_enable multimedia QtMultimedia)
			$(pyqt4_use_enable opengl QtOpenGL)
			$(pyqt4_use_enable phonon)
			$(pyqt4_use_enable script QtScript)
			$(pyqt4_use_enable scripttools QtScriptTools)
			$(pyqt4_use_enable sql QtSql)
			$(pyqt4_use_enable svg QtSvg)
			$(pyqt4_use_enable webkit QtWebKit)
			$(pyqt4_use_enable xmlpatterns QtXmlPatterns)
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			CFLAGS="${CFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			LFLAGS="${LDFLAGS}")
		python_execute "${myconf[@]}" || return

		local mod
		for mod in QtCore $(use X && echo QtDesigner QtGui) $(use dbus && echo QtDBus) $(use declarative && echo QtDeclarative) $(use opengl && echo QtOpenGL); do
			# Run eqmake4 inside the qpy subdirectories to respect CC, CXX, CFLAGS, CXXFLAGS and LDFLAGS and avoid stripping.
			pushd qpy/${mod} > /dev/null || return
			eqmake4 $(ls w_qpy*.pro)
			popd > /dev/null || return

			# Fix insecure runpaths.
			sed -e "/^LFLAGS[[:space:]]*=/s:-Wl,-rpath,${BUILDDIR}/qpy/${mod}::" -i ${mod}/Makefile || die "Fixing of runpaths failed"
		done

		# Avoid stripping of libpythonplugin.so.
		if use X; then
			pushd designer > /dev/null || return
			eqmake4 python.pro
			popd > /dev/null || return
		fi
	}
	python_execute_function -s configuration
}

src_compile() {
	python_src_compile
}

src_install() {
	installation() {
		# INSTALL_ROOT is used by designer/Makefile, other Makefiles use DESTDIR.
		emake DESTDIR="${T}/images/${PYTHON_ABI}" INSTALL_ROOT="${T}/images/${PYTHON_ABI}" install
	}
	python_execute_function -s installation
	python_merge_intermediate_installation_images "${T}/images"

	dodoc NEWS THANKS

	if use doc; then
		dohtml -r doc/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_mod_optimize PyQt4
}

pkg_postrm() {
	python_mod_cleanup PyQt4
}
