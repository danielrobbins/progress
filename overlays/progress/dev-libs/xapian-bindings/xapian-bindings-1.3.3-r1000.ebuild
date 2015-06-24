# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_DEPEND="python? ( <<[threads]>> )"
PYTHON_RESTRICTED_ABIS="3.1 *-jython *-pypy"

USE_PHP="php5-4 php5-5 php5-6"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

inherit java-pkg-opt-2 mono-env php-ext-source-r2 python

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="java lua mono perl php python ruby tcl"
REQUIRED_USE="|| ( java lua mono perl php python ruby tcl )"

RDEPEND="~dev-libs/xapian-${PV}
	lua? ( >=dev-lang/lua-5.1:= )
	mono? ( dev-lang/mono )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:= )
	tcl? ( >=dev-lang/tcl-8.5:0= )"
DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.3 )"
RDEPEND+="
	java? ( >=virtual/jre-1.3 )"

pkg_setup() {
	java-pkg-opt-2_pkg_setup

	if use mono; then
		mono-env_pkg_setup
	fi

	if use python; then
		python_pkg_setup
	fi
}

src_unpack() {
	default
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	sed \
		-e '/^pkgpylib_DATA =/,/^$/s|xapian/__init__.py[co] \?||' \
		-e 's|\(^xapian/__init__.py: xapian.py\)|\1 xapian/_xapian$(PYTHON2_SO)|' \
		-i python/Makefile.in || die "sed failed"
	sed \
		-e '/^pkgpylib_DATA =/,/^$/s|xapian/__pycache__/__init__.@PYTHON3_CACHE_TAG@.py[co] \?||' \
		-e 's|\(^xapian/__init__.py: xapian.py\)|\1 xapian/_xapian$(PYTHON3_SO)|' \
		-i python3/Makefile.in || die "sed failed"

	if use python; then
		python_copy_sources
	fi
}

src_configure() {
	if use java; then
		CXXFLAGS+="${CXXFLAGS:+ }$(java-pkg_get-jni-cflags)"
	fi

	if use lua; then
		local LUA_LIB
		export LUA_LIB="$(pkg-config --variable=INSTALL_CMOD lua)"
	fi

	if use perl; then
		local PERL_ARCH PERL_LIB
		export PERL_ARCH="$(perl -MConfig -e 'print $Config{installvendorarch}')"
		export PERL_LIB="$(perl -MConfig -e 'print $Config{installvendorlib}')"
	fi

	econf \
		$(use_with java) \
		$(use_with lua) \
		$(use_with mono csharp) \
		$(use_with perl) \
		$(use_with php) \
		$(use_with ruby) \
		$(use_with tcl) \
		--without-python \
		--without-python3

	# PHP bindings are built/tested/installed manually.
	sed -e "/SUBDIRS =/s/ php//" -i Makefile || die "sed failed"

	if use python; then
		configuration() {
			local myconf=()

			if [[ "$(python_get_version -l --major)" == "2" ]]; then
				myconf+=(
					--with-python
					--without-python3
					PYTHON2="$(PYTHON)"
				)
			else
				myconf+=(
					--without-python
					--with-python3
					PYTHON3="$(PYTHON)"
				)
			fi

			econf \
				--without-java \
				--without-lua \
				--without-csharp \
				--without-perl \
				--without-php \
				--without-ruby \
				--without-tcl \
				"${myconf[@]}"
		}
		python_execute_function -s configuration
	fi
}

src_compile() {
	default

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			cp -r php php-${php_slot}
			emake -C php-${php_slot} \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)"
		done
	fi

	if use python; then
		python_src_compile
	fi
}

src_test() {
	emake VERBOSE="1" check

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			emake -C php-${php_slot} \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)" \
				VERBOSE="1" \
				check
		done
	fi

	if use python; then
		python_src_test VERBOSE="1"
	fi
}

src_install () {
	emake DESTDIR="${D}" install

	if use java; then
		java-pkg_dojar java/built/xapian_jni.jar
		# TODO: Make the build system not install this file.
		java-pkg_doso "${ED}/${S}/java/built/libxapian_jni.so"
		rm "${ED}/${S}/java/built/libxapian_jni.so"
		rmdir -p "${ED}/${S}/java/built"
		rmdir -p "${ED}/${S}/java/native"
	fi

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			emake -C php-${php_slot} \
				DESTDIR="${D}" \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)" \
				install
		done

		php-ext-source-r2_createinifiles
	fi

	if use python; then
		python_src_install
	fi

	# This directory is created in some combinations of USE flags.
	if [[ -d "${ED}usr/share/doc/xapian-bindings" ]]; then
		mv "${ED}usr/share/doc/xapian-bindings" "${ED}usr/share/doc/${PF}" || die "mv failed"
	fi

	dodoc AUTHORS HACKING NEWS TODO README
}

pkg_postinst() {
	if use python; then
		python_byte-compile_modules xapian
	fi
}

pkg_postrm() {
	if use python; then
		python_clean_byte-compiled_modules xapian
	fi
}
