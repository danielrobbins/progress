# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit python

DESCRIPTION="Virtual for pysqlite2 and sqlite3 Python modules"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="external"

DEPEND=""
RDEPEND="python_abis_2.4? ( dev-python/pysqlite:2[python_abis_2.4] )
	python_abis_2.5? (
		external? ( dev-python/pysqlite:2[python_abis_2.5] )
		!external? ( || ( dev-lang/python:2.5[sqlite] dev-python/pysqlite:2[python_abis_2.5] ) )
	)
	python_abis_2.6? (
		external? ( dev-python/pysqlite:2[python_abis_2.6] )
		!external? ( || ( dev-lang/python:2.6[sqlite] dev-python/pysqlite:2[python_abis_2.6] ) )
	)
	python_abis_2.7? (
		external? ( dev-python/pysqlite:2[python_abis_2.7] )
		!external? ( || ( dev-lang/python:2.7[sqlite] dev-python/pysqlite:2[python_abis_2.7] ) )
	)
	python_abis_3.1? ( dev-lang/python:3.1[sqlite] )
	python_abis_3.2? ( dev-lang/python:3.2[sqlite] )
	python_abis_3.3? ( dev-lang/python:3.3[sqlite] )
	python_abis_2.7-pypy-1.5? ( dev-python/pysqlite:2[python_abis_2.7-pypy-1.5] )
	python_abis_2.7-pypy-1.6? ( dev-python/pysqlite:2[python_abis_2.7-pypy-1.6] )"
