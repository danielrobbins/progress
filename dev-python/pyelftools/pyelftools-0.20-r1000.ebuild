# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
# *-jython: http://bugs.jython.org/issue1973
PYTHON_RESTRICTED_ABIS="2.5 3.1 *-jython"

inherit distutils eutils

DESCRIPTION="Library for analyzing ELF files and DWARF debugging information"
HOMEPAGE="http://pypi.python.org/pypi/pyelftools https://bitbucket.org/eliben/pyelftools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="*"
IUSE=""

PYTHON_MODULES="elftools"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${P}-dyntags-{1,2}.patch
	sed -e "s/from enums import ENUM_D_TAG/from .enums import ENUM_D_TAG/" -i elftools/elf/dynamic.py
}

src_test() {
	testing() {
		local exit_status="0" test
		for test in all_unittests examples_test; do
			python_execute PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/run_${test}.py || exit_status="1"
		done

		return "${exit_status}"
	}
	python_execute_function testing
}
