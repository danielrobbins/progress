# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils

DESCRIPTION="A process and system utilities module for Python"
HOMEPAGE="http://code.google.com/p/psutil/ https://pypi.python.org/pypi/psutil"
SRC_URI="http://psutil.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="$(python_abi_depend dev-python/setuptools)"
RDEPEND=""

DOCS="CREDITS HISTORY README"

src_prepare() {
	distutils_src_prepare

	# Disable failing tests.
	# http://code.google.com/p/psutil/issues/detail?id=369
	# http://code.google.com/p/psutil/issues/detail?id=377
	# http://code.google.com/p/psutil/issues/detail?id=378
	sed \
		-e "s/test_as_dict/_&/" \
		-e "s/test_get_memory_maps/_&/" \
		-e "s/test_terminal/_&/" \
		-e "s/test_disk_partitions/_&/" \
		-e "s/test_fetch_all/_&/" \
		-i test/test_psutil.py
	sed -e "s/test_memory_maps/_&/" -i test/_linux.py
}

src_test() {
	testing() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" test/test_psutil.py
	}
	python_execute_function testing
}
