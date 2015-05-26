# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_RESTRICTED_ABIS="3.1 *-jython *-pypy"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Pythonic interface to the HDF5 binary data format"
HOMEPAGE="http://www.h5py.org/ https://github.com/h5py/h5py https://pypi.python.org/pypi/h5py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="examples mpi test"

RDEPEND="sci-libs/hdf5:=[mpi?]
	$(python_abi_depend dev-python/numpy)
	$(python_abi_depend dev-python/six)
	mpi? ( $(python_abi_depend dev-python/mpi4py) )"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/cython)
	$(python_abi_depend dev-python/pkgconfig)
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -i "2.6" dev-python/unittest2) )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

src_prepare() {
	# Require not Cython at run time.
	sed -e "/install_requires =/s/, 'Cython>=0.17'//" -i setup.py

	distutils_src_prepare
}

src_configure() {
	configuration() {
		python_execute "$(PYTHON)" setup.py configure $(use mpi && echo --mpi)
	}
	python_execute_function -s configuration
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -r "${ED}$(python_get_sitedir)/h5py/tests"
	}
	python_execute_function -q delete_tests

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
