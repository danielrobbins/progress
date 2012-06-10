# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
JAVA_PKG_IUSE="doc examples oracle source"

inherit java-pkg-2 java-ant-2 python

if [[ "${PV}" == *_pre* ]]; then
	inherit mercurial

	EHG_REPO_URI="http://hg.python.org/jython"
	EHG_REVISION="b0a3bea03ca2"
fi

PATCHSET_REVISION="20120610"

DESCRIPTION="Implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"
SRC_URI=""

LICENSE="PSF-2"
SLOT="2.7"
PYTHON_ABI="${SLOT}-jython"
KEYWORDS="~amd64 ~x86"
IUSE="+readline +ssl +threads +xml"

CDEPEND="dev-java/ant-core:0
	dev-java/antlr:3
	dev-java/asm:4
	dev-java/guava:12
	dev-java/jffi:1.2
	dev-java/jline:0
	dev-java/jnr-constants:0
	dev-java/jnr-netdb:1.0
	dev-java/jnr-posix:2.1
	dev-java/jsr223:0
	>=dev-java/libreadline-java-0.8.0
	dev-java/xerces:2
	java-virtuals/servlet-api:2.5
	oracle? ( dev-java/jdbc-oracle-bin:10.2 )"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}
	>=dev-java/java-config-2.1.11-r3
	!dev-java/jython:${SLOT}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	dev-java/junit:0"

pkg_setup() {
	java-pkg-2_pkg_setup
	python_pkg_setup
}

java_prepare() {
	EPATCH_SUFFIX="patch" epatch "${FILESDIR}/${SLOT}-${PATCHSET_REVISION}"

	find extlibs -name "*.jar" -delete
	find -name "*.py[co]" -delete

	java-pkg_jar-from --into extlibs ant-core ant.jar
	java-pkg_jar-from --into extlibs antlr-3 antlr3.jar antlr-3.1.3.jar
	java-pkg_jar-from --into extlibs asm-4 asm.jar asm-4.0.jar
	java-pkg_jar-from --into extlibs asm-4 asm-commons.jar asm-commons-4.0.jar
	java-pkg_jar-from --into extlibs asm-4 asm-util.jar asm-util-4.0.jar
	java-pkg_jar-from --into extlibs guava-12 guava.jar guava-11.0.2.jar
	java-pkg_jar-from --into extlibs jffi-1.2 jffi.jar jffi-1.2.2-SNAPSHOT.jar
	java-pkg_jar-from --into extlibs jline jline.jar jline-0.9.95-SNAPSHOT.jar
	java-pkg_jar-from --into extlibs jnr-constants jnr-constants.jar jnr-constants-0.8.3-SNAPSHOT.jar
	java-pkg_jar-from --into extlibs jnr-netdb-1.0 jnr-netdb.jar jnr-netdb-1.0.6-SNAPSHOT.jar
	java-pkg_jar-from --into extlibs jnr-posix-2.1 jnr-posix.jar jnr-posix-2.1-SNAPSHOT.jar
	java-pkg_jar-from --build-only --into extlibs junit junit.jar junit-3.8.2.jar
	java-pkg_jar-from --into extlibs libreadline-java libreadline-java.jar libreadline-java-0.8.jar
	java-pkg_jar-from --into extlibs jsr223 script-api.jar livetribe-jsr223-2.0.5.jar
	java-pkg_jar-from --into extlibs servlet-api-2.5 servlet-api.jar servlet-api-2.5.jar
	java-pkg_jar-from --into extlibs xerces-2 xercesImpl.jar xercesImpl-2.9.1.jar

	# Dependencies of dev-java/antlr:3.
	java-pkg_jar-from --build-only --into extlibs antlr antlr.jar antlr-2.7.7.jar
	java-pkg_jar-from --build-only --into extlibs stringtemplate stringtemplate.jar stringtemplate-3.2.jar

	# Dependency of dev-java/jnr-posix:2.1
	java-pkg_jar-from --build-only --into extlibs jnr-ffi-0.7 jnr-ffi.jar jnr-ffi-0.7.4-SNAPSHOT.jar

	echo "has.repositories.connection=false" > ant.properties

	if use oracle; then
		echo "oracle.jar=$(java-pkg-getjar jdbc-oracle-bin-10.2 ojdbc14.jar)" >> ant.properties
	fi
}

src_compile() {
	eant developer-build $(use_doc javadoc)
}

src_test() {
	ANT_TASKS="ant-junit" nonfatal eant prepare-test javatest launchertest regrtest-unix
}

src_install() {
	dodoc ACKNOWLEDGMENTS NEWS README.txt

	pushd dist > /dev/null
	java-pkg_newjar "${PN}-dev.jar"

	local java_args="-Dpython.home=${EPREFIX}/usr/share/${PN}-${SLOT}"
	java_args+=" -Dpython.cachedir=\$([[ -n \"\${JYTHON_SYSTEM_CACHEDIR}\" ]] && echo ${EPREFIX}/var/cache/${PN}/${SLOT}-\${EUID} || echo \${HOME}/.jython${SLOT}-cachedir)"
	java_args+=" -Dpython.executable=${EPREFIX}/usr/bin/jython${SLOT}"
	java-pkg_dolauncher jython${SLOT} --main "org.python.util.jython" --pkg_args "${java_args}"

	java-pkg_register-optional-dependency jdbc-mysql
	java-pkg_register-optional-dependency jdbc-postgresql

	insinto /usr/share/${PN}-${SLOT}
	doins -r Lib registry
	python_clean_installation_image -q

	use doc && java-pkg_dojavadoc Doc/javadoc
	popd > /dev/null

	use examples && java-pkg_doexamples Demo/*
	use source && java-pkg_dosrc src

	if use readline; then
		sed \
			-e "s/#\(python.console=org.python.util.ReadlineConsole\)/\1/" \
			-e "/#python.console.readlinelib=JavaReadline/a python.console.readlinelib=GnuReadline" \
			-i "${ED}usr/share/${PN}-${SLOT}/registry" || die "sed failed"
	fi
}

pkg_postinst() {
	# Clean Jython system cache.
	rm -fr "${EROOT}var/cache/jython/"${SLOT}-*/*

	python_mod_optimize -f -x "/(site-packages|test|tests)/" $(python_get_libdir)

	elog
	elog "Readline can be configured in the registry:"
	elog
	elog "python.console=org.python.util.ReadlineConsole"
	elog "python.console.readlinelib=GnuReadline"
	elog
	elog "Global registry: '${EROOT}usr/share/${PN}-${SLOT}/registry'"
	elog "User registry: '~/.jython'"
	elog
}

pkg_postrm() {
	python_mod_cleanup $(python_get_libdir)
}
