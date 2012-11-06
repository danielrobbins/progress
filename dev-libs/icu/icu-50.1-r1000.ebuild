# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs versionator

MAJOR_VERSION="$(get_version_component_range 1)"
if [[ "${PV}" =~ ^[[:digit:]]+_rc[[:digit:]]*$ ]]; then
	MINOR_VERSION="1"
else
	MINOR_VERSION="$(get_version_component_range 2)"
fi

DESCRIPTION="International Components for Unicode"
HOMEPAGE="http://www.icu-project.org/"

BASE_URI="http://download.icu-project.org/files/icu4c/${PV/_/}"
SRC_ARCHIVE="icu4c-${PV//./_}-src.tgz"
DOCS_ARCHIVE="icu4c-${PV//./_}-docs.zip"

SRC_URI="${BASE_URI}/${SRC_ARCHIVE}
	doc? ( ${BASE_URI}/${DOCS_ARCHIVE} )"

LICENSE="BSD"
SLOT="0/${MAJOR_VERSION}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc examples static-libs"

DEPEND="doc? ( app-arch/unzip )"
RDEPEND=""

S="${WORKDIR}/${PN}/source"

QA_DT_NEEDED="/usr/lib.*/libicudata\.so\.${MAJOR_VERSION}\.${MINOR_VERSION}.*"
QA_FLAGS_IGNORED="/usr/lib.*/libicudata\.so\.${MAJOR_VERSION}\.${MINOR_VERSION}.*"

src_unpack() {
	unpack "${SRC_ARCHIVE}"
	if use doc; then
		mkdir docs
		pushd docs > /dev/null
		unpack "${DOCS_ARCHIVE}"
		popd > /dev/null
	fi
}

src_prepare() {
	sed -e "s/#CXXFLAGS =/CXXFLAGS =/" -i config/icu.pc.in || die "sed failed"

	# Do not hardcode flags in icu-config and icu-*.pc files.
	# https://ssl.icu-project.org/trac/ticket/6102
	local variable
	for variable in CFLAGS CPPFLAGS CXXFLAGS FFLAGS LDFLAGS; do
		sed -e "/^${variable} =.*/s: *@${variable}@\( *$\)\?::" -i config/icu.pc.in config/Makefile.inc.in || die "sed failed"
	done

	local cplusplus_version="1998"
	if [[ "$(tc-getCXX)" == *clang* ]]; then
		# Store -std=c++11 flag in CXXFLAGS in icu-config and icu-*.pc files for API consumers, if this flag is supported and required.
		if $(tc-getCXX) -c -std=c++11 -x c++ - -o /dev/null <<< "char16_t string[] = u\"...\";" &> /dev/null && ! $(tc-getCXX) -c -x c++ - -o /dev/null <<< "char16_t string[] = u\"...\";" &> /dev/null; then
			cplusplus_version="2011"
			sed -e "/^CXXFLAGS =/s/ *$/ -std=c++11/" -i config/icu.pc.in config/Makefile.inc.in || die "sed failed"
		fi
	else
		# Store -std=gnu++11 flag in CXXFLAGS in icu-config and icu-*.pc files for API consumers, if this flag is supported and required.
		if $(tc-getCXX) -c -std=gnu++11 -x c++ - -o /dev/null <<< "char16_t string[] = u\"...\";" &> /dev/null && ! $(tc-getCXX) -c -x c++ - -o /dev/null <<< "char16_t string[] = u\"...\";" &> /dev/null; then
			cplusplus_version="2011"
			sed -e "/^CXXFLAGS =/s/ *$/ -std=gnu++11/" -i config/icu.pc.in config/Makefile.inc.in || die "sed failed"
		fi
	fi

	# Hardcode type of UChar in C++ mode in installed headers.
	if [[ "${cplusplus_version}" == "2011" ]]; then
		sed -e "s/^\(#   if \)(\(defined(__cplusplus)\) && __cplusplus >= 201103L)$/\1\2/" -i common/unicode/platform.h || die "sed failed"
	else
		sed -e "s/^\(#   if \)(defined(__cplusplus) && __cplusplus >= 201103L)$/\10/" -i common/unicode/platform.h || die "sed failed"
	fi

	sed -e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" -i common/unicode/uconfig.h

	epatch "${FILESDIR}/${PN}-4.8.1-fix_binformat_fonts.patch"
	epatch "${FILESDIR}/${PN}-4.8.1.1-fix_ltr.patch"

	# https://ssl.icu-project.org/trac/ticket/9718
	sed -e "/#include \"locmap.h\"/i #include \"uposixdefs.h\"" -i io/ufile.c || die "sed failed"
}

src_configure() {
	econf \
		--disable-renaming \
		$(use_enable debug) \
		$(use_enable examples samples) \
		$(use_enable static-libs static)
}

src_compile() {
	emake VERBOSE="1"
}

src_test() {
	# INTLTEST_OPTS: intltest options
	#   -e: Exhaustive testing
	#   -l: Reporting of memory leaks
	#   -v: Increased verbosity
	# IOTEST_OPTS: iotest options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	# CINTLTST_OPTS: cintltst options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	emake -j1 VERBOSE="1" check
}

src_install() {
	emake DESTDIR="${D}" VERBOSE="1" install

	dohtml ../readme.html
	if use doc; then
		insinto /usr/share/doc/${PF}/html/api
		doins -r "${WORKDIR}/docs/"*
	fi
}
