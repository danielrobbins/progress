# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit eutils python toolchain-funcs

MY_P="QScintilla-gpl-${PV}"

DESCRIPTION="Python bindings for QScintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="debug"

DEPEND="
	$(python_abi_depend ">=dev-python/sip-4.12:0=")
	$(python_abi_depend ">=dev-python/PyQt4-4.8:0=[X]")
	~x11-libs/qscintilla-${PV}
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/Python"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.5.1-disable_stripping.patch"
	python_src_prepare
}

src_configure() {
	configuration() {
		local myconf=(
			"$(PYTHON)" configure.py
			--destdir="${EPREFIX}$(python_get_sitedir)/PyQt4"
			-p 4
			--no-timestamp
			$(use debug && echo --debug)
		)
		python_execute "${myconf[@]}"
	}
	python_execute_function -s configuration
}

src_compile() {
	building() {
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINK="$(tc-getCXX)"
	}
	python_execute_function -s building
}
