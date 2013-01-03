# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"

inherit distutils

PYPARSING_PYTHON2_VERSION="1.5.7"
PYPARSING_PYTHON3_VERSION="${PV}"

DESCRIPTION="Python parsing module"
HOMEPAGE="http://pyparsing.wikispaces.com/ http://pypi.python.org/pypi/pyparsing"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PYPARSING_PYTHON2_VERSION}.tar.gz
	mirror://sourceforge/${PN}/${PN}-${PYPARSING_PYTHON3_VERSION}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
PYTHON_MODULES="pyparsing.py"

src_prepare() {
	preparation() {
		if [[ "$(python_get_version -l --major)" == "3" ]]; then
			cp -r "${WORKDIR}/pyparsing-${PYPARSING_PYTHON3_VERSION}" "${S}-${PYTHON_ABI}"
		else
			cp -r "${WORKDIR}/pyparsing-${PYPARSING_PYTHON2_VERSION}" "${S}-${PYTHON_ABI}"
		fi
	}
	python_execute_function -q preparation
}

src_install() {
	distutils_src_install

	dohtml HowToUsePyparsing.html

	if use doc; then
		dohtml -r htmldoc/*
		dodoc docs/*.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples/python2
		doins "${WORKDIR}/pyparsing-${PYPARSING_PYTHON2_VERSION}/examples/"*
		insinto /usr/share/doc/${PF}/examples/python3
		doins "${WORKDIR}/pyparsing-${PYPARSING_PYTHON3_VERSION}/examples/"*
	fi
}
