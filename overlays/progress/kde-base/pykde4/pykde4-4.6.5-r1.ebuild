# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"

PYTHON_DEPEND="<<[threads]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 *-jython *-pypy-*"

OPENGL_REQUIRED="always"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	KMMODULE="."
	kde_eclass="kde4-base"
else
	KMNAME="kdebindings"
	KMMODULE="python/pykde4"
	kde_eclass="kde4-meta"
fi

inherit ${kde_eclass} portability python

DESCRIPTION="Python bindings for KDE4"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples semantic-desktop"

# blocker added due to compatibility issues and error during compile time
RDEPEND="
	!dev-python/pykde
	$(python_abi_depend ">=dev-python/sip-4.12")
	$(add_kdebase_dep kdelibs 'opengl,semantic-desktop=')
	semantic-desktop? ( $(add_kdebase_dep kdepimlibs 'semantic-desktop') )
	aqua? ( $(python_abi_depend ">=dev-python/PyQt4-4.8.2[dbus,declarative,sql,svg,webkit,aqua]") )
	!aqua? ( $(python_abi_depend ">=dev-python/PyQt4-4.8.2[dbus,declarative,sql,svg,webkit,X]") )
"
DEPEND="${RDEPEND}
	sys-devel/libtool
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.4-pyqt475.patch
	"${FILESDIR}"/${PN}-4.6.3-python-3.2.patch
)

pkg_setup() {
	python_pkg_setup
	${kde_eclass}_pkg_setup

	have_python2=false

	scan_python_versions() {
		[[ ${PYTHON_ABI} == 2.* ]] && have_python2=true
		:
	}
	python_execute_function -q scan_python_versions
	if ! ${have_python2}; then
		ewarn "You do not have a Python 2 version selected."
		ewarn "kpythonpluginfactory will not be built"
	fi
}

src_prepare() {
	${kde_eclass}_src_prepare

	if ! use examples; then
		sed -e '/^ADD_SUBDIRECTORY(examples)/s/^/# DISABLED /' -i ${KMMODULE}/CMakeLists.txt \
			|| die "Failed to disable examples"
	fi

	# See bug 322351
	use arm && epatch "${FILESDIR}/${PN}-4.4.4-arm-sip.patch"

	sed -i -e 's/kpythonpluginfactory /kpython${PYTHON_SHORT_VERSION}pluginfactory /g' ${KMMODULE}/kpythonpluginfactory/CMakeLists.txt

	if ${have_python2}; then
		mkdir -p "${WORKDIR}/wrapper" || die "failed to copy wrapper"
		cp "${FILESDIR}/kpythonpluginfactorywrapper.c" "${WORKDIR}/wrapper" || die "failed to copy wrapper"
	fi
}

src_configure() {
	# Required for KTabWidget::label
	append-cxxflags -DKDE3_SUPPORT

	configuration() {
		local mycmakeargs=(
			-DWITH_PolkitQt=OFF
			-DWITH_QScintilla=OFF
			$(cmake-utils_use_with semantic-desktop Soprano)
			$(cmake-utils_use_with semantic-desktop Nepomuk)
			$(cmake-utils_use_with semantic-desktop KdepimLibs)
			-DPYTHON_EXECUTABLE=$(PYTHON -a)
		)
		local CMAKE_BUILD_DIR=${S}_build-${PYTHON_ABI}
		${kde_eclass}_src_configure
	}

	python_execute_function configuration
}

src_compile() {
	compilation() {
		local CMAKE_BUILD_DIR=${S}_build-${PYTHON_ABI}
		${kde_eclass}_src_compile
	}
	python_execute_function compilation

	if ${have_python2}; then
		cd "${WORKDIR}/wrapper"
		python_execute libtool --tag=CC --mode=compile $(tc-getCC) \
			-shared \
			${CFLAGS} ${CPPFLAGS} \
			-DEPREFIX="\"${EPREFIX}\"" \
			-DPLUGIN_DIR="\"/usr/$(get_libdir)/kde4\"" -c \
			-o kpythonpluginfactorywrapper.lo \
			kpythonpluginfactorywrapper.c
		python_execute libtool --tag=CC --mode=link $(tc-getCC) \
			-shared -module -avoid-version \
			${CFLAGS} ${LDFLAGS} \
			-o kpythonpluginfactory.la \
			-rpath "${EPREFIX}/usr/$(get_libdir)/kde4" \
			kpythonpluginfactorywrapper.lo \
			$(dlopen_lib)
	fi
}

src_install() {
	installation() {
		cd "${S}_build-${PYTHON_ABI}"
		emake DESTDIR="${T}/images/${PYTHON_ABI}" install
	}
	python_execute_function installation

	python_merge_intermediate_installation_images "${T}/images"

	# As we don't call the eclass's src_install, we have to install the docs manually
	DOCS=("${S}"/${KMMODULE}/{AUTHORS,NEWS,README})
	use doc && HTML_DOCS=("${S}/${KMMODULE}/docs/html/")
	base_src_install_docs

	if ${have_python2}; then
		cd "${WORKDIR}/wrapper"
		python_execute libtool --mode=install install kpythonpluginfactory.la "${ED}/usr/$(get_libdir)/kde4/kpythonpluginfactory.la"
		rm "${ED}/usr/$(get_libdir)/kde4/kpythonpluginfactory.la"
	fi
}

pkg_postinst() {
	${kde_eclass}_pkg_postinst

	python_mod_optimize PyKDE4 PyQt4/uic/pykdeuic4.py PyQt4/uic/widget-plugins/kde4.py

	if use examples; then
		echo
		elog "PyKDE4 examples have been installed to"
		elog "${EPREFIX}/usr/share/apps/${PN}/examples"
		echo
	fi
}

pkg_postrm() {
	${kde_eclass}_pkg_postrm

	python_mod_cleanup PyKDE4 PyQt4/uic/pykdeuic4.py PyQt4/uic/widget-plugins/kde4.py
}
