# Copyright owners: Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: systemd.eclass
# @MAINTAINER:
# systemd@gentoo.org
# @BLURB: helper functions to install systemd units
# @DESCRIPTION:
# This eclass provides a set of functions to install unit files for
# sys-apps/systemd within ebuilds.
# @EXAMPLE:
#
# @CODE
# inherit autotools-utils systemd
#
# src_configure() {
#	local myeconfargs=(
#		--enable-foo
#		--disable-bar
#	)
#
#	systemd_to_myeconfargs
#	autotools-utils_src_configure
# }
# @CODE

inherit toolchain-funcs

case ${EAPI:-0} in
	0|1|2|3|4|4-python|5|5-progress) ;;
	*) die "${ECLASS}.eclass API in EAPI ${EAPI} not yet established."
esac

DEPEND="virtual/pkgconfig"

# @FUNCTION: _systemd_get_unitdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed unitdir.
_systemd_get_unitdir() {
	if $(tc-getPKG_CONFIG) --exists systemd; then
		echo "$($(tc-getPKG_CONFIG) --variable=systemdsystemunitdir systemd)"
	else
		echo /usr/lib/systemd/system
	fi
}

# @FUNCTION: systemd_get_unitdir
# @DESCRIPTION:
# Output the path for the systemd unit directory (not including ${D}).
# This function always succeeds, even if systemd is not installed.
systemd_get_unitdir() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_systemd_get_unitdir)"
}

# @FUNCTION: _systemd_get_userunitdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed userunitdir.
_systemd_get_userunitdir() {
	if $(tc-getPKG_CONFIG) --exists systemd; then
		echo "$($(tc-getPKG_CONFIG) --variable=systemduserunitdir systemd)"
	else
		echo /usr/lib/systemd/user
	fi
}

# @FUNCTION: systemd_get_userunitdir
# @DESCRIPTION:
# Output the path for the systemd user unit directory (not including
# ${D}). This function always succeeds, even if systemd is not
# installed.
systemd_get_userunitdir() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_systemd_get_userunitdir)"
}

# @FUNCTION: _systemd_get_utildir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed utildir.
_systemd_get_utildir() {
	if $(tc-getPKG_CONFIG) --exists systemd; then
		echo "$($(tc-getPKG_CONFIG) --variable=systemdutildir systemd)"
	else
		echo /usr/lib/systemd
	fi
}

# @FUNCTION: systemd_get_utildir
# @DESCRIPTION:
# Output the path for the systemd utility directory (not including
# ${D}). This function always succeeds, even if systemd is not
# installed.
systemd_get_utildir() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	debug-print-function ${FUNCNAME} "${@}"

	echo "${EPREFIX}$(_systemd_get_utildir)"
}

# @FUNCTION: systemd_dounit
# @USAGE: unit1 [...]
# @DESCRIPTION:
# Install systemd unit(s). Uses doins, thus it is fatal in EAPI 4
# and non-fatal in earlier EAPIs.
systemd_dounit() {
	debug-print-function ${FUNCNAME} "${@}"

	local INSDESTTREE
	insinto "$(_systemd_get_unitdir)"
	doins "${@}"
}

# @FUNCTION: systemd_newunit
# @USAGE: oldname newname
# @DESCRIPTION:
# Install systemd unit with a new name. Uses newins, thus it is fatal
# in EAPI 4 and non-fatal in earlier EAPIs.
systemd_newunit() {
	debug-print-function ${FUNCNAME} "${@}"

	local INSDESTTREE
	insinto "$(_systemd_get_unitdir)"
	newins "${@}"
}

# @FUNCTION: systemd_dotmpfilesd
# @USAGE: tmpfilesd1 [...]
# @DESCRIPTION:
# Install systemd tmpfiles.d files. Uses doins, thus it is fatal
# in EAPI 4 and non-fatal in earlier EAPIs.
systemd_dotmpfilesd() {
	debug-print-function ${FUNCNAME} "${@}"

	for f; do
		[[ ${f} == *.conf ]] \
			|| die 'tmpfiles.d files need to have .conf suffix.'
	done

	local INSDESTTREE
	insinto /usr/lib/tmpfiles.d/
	doins "${@}"
}

# @FUNCTION: systemd_newtmpfilesd
# @USAGE: oldname newname.conf
# @DESCRIPTION:
# Install systemd tmpfiles.d file under a new name. Uses newins, thus it
# is fatal in EAPI 4 and non-fatal in earlier EAPIs.
systemd_newtmpfilesd() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${2} == *.conf ]] \
		|| die 'tmpfiles.d files need to have .conf suffix.'

	local INSDESTTREE
	insinto /usr/lib/tmpfiles.d/
	newins "${@}"
}

# @FUNCTION: systemd_enable_service
# @USAGE: target service
# @DESCRIPTION:
# Enable service in desired target, e.g. install a symlink for it.
# Uses dosym, thus it is fatal in EAPI 4 and non-fatal in earlier
# EAPIs.
systemd_enable_service() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "Synopsis: systemd_enable_service target service"

	local target=${1}
	local service=${2}
	local ud=$(_systemd_get_unitdir)
	local destname=${service##*/}

	dodir "${ud}"/"${target}".wants && \
	dosym ../"${service}" "${ud}"/"${target}".wants/"${destname}"
}

# @FUNCTION: systemd_with_unitdir
# @USAGE: [configure option]
# @DESCRIPTION:
# Output '--with-systemdsystemunitdir' as expected by systemd-aware configure
# scripts. This function always succeeds. Its output may be quoted in order
# to preserve whitespace in paths. systemd_to_myeconfargs() is preferred over
# this function.
#
# If upstream does use invalid configure option to handle installing systemd
# units (e.g. `--with-systemdunitdir'), you can pass the 'suffix' as an optional
# argument to this function (`$(systemd_with_unitdir systemdunitdir)'). Please
# remember to report a bug upstream as well.
systemd_with_unitdir() {
	debug-print-function ${FUNCNAME} "${@}"
	local optname=${1:-systemdsystemunitdir}

	echo --with-${optname}="$(systemd_get_unitdir)"
}

# @FUNCTION: systemd_with_utildir
# @DESCRIPTION:
# Output '--with-systemdsystemutildir' as used by some packages to install
# systemd helpers. This function always succeeds. Its output may be quoted
# in order to preserve whitespace in paths.
systemd_with_utildir() {
	debug-print-function ${FUNCNAME} "${@}"

	echo --with-systemdutildir="$(systemd_get_utildir)"
}

# @FUNCTION: systemd_to_myeconfargs
# @DESCRIPTION:
# Add '--with-systemdsystemunitdir' as expected by systemd-aware configure
# scripts to the myeconfargs variable used by autotools-utils eclass. Handles
# quoting automatically.
systemd_to_myeconfargs() {
	debug-print-function ${FUNCNAME} "${@}"

	myeconfargs=(
		"${myeconfargs[@]}"
		--with-systemdsystemunitdir="$(systemd_get_unitdir)"
	)
}

# @FUNCTION: systemd_update_catalog
# @DESCRIPTION:
# Update the journald catalog. This needs to be called after installing
# or removing catalog files.
#
# If systemd is not installed, no operation will be done. The catalog
# will be (re)built once systemd is installed.
#
# See: http://www.freedesktop.org/wiki/Software/systemd/catalog
systemd_update_catalog() {
	debug-print-function ${FUNCNAME} "${@}"

	# Make sure to work on the correct system.

	local journalctl=${EPREFIX}/usr/bin/journalctl
	if [[ -x ${journalctl} ]]; then
		ebegin "Updating systemd journal catalogs"
		journalctl --update-catalog
		eend $?
	else
		debug-print "${FUNCNAME}: journalctl not found."
	fi
}

# @FUNCTION: systemd_is_booted
# @DESCRIPTION:
# Check whether the system was booted using systemd.
#
# This should be used purely for informational purposes, e.g. warning
# user that he needs to use systemd. Installed files or application
# behavior *must not* rely on this. Please remember to check MERGE_TYPE
# to not trigger the check on binary package build hosts!
#
# Returns 0 if systemd is used to boot the system, 1 otherwise.
#
# See: man sd_booted
systemd_is_booted() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -d /run/systemd/system ]]
	local ret=${?}

	debug-print "${FUNCNAME}: [[ -d /run/systemd/system ]] -> ${ret}"
	return ${ret}
}