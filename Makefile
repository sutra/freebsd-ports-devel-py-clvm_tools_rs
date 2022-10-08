PORTNAME=	clvm_tools_rs
PORTVERSION=	0.1.11
CATEGORIES=	devel python
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

MAINTAINER=	zhoushuqun@gmail.com
COMMENT=	WIP porting clvm_tools to rust

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}maturin>=0.8.3:devel/py-maturin@${PY_FLAVOR} \
	${PYTHON_PKGNAMEPREFIX}pip>=20.2.3:devel/py-pip@${PY_FLAVOR}

USES=	cargo python ssl
USE_PYTHON=	autoplist concurrent distutils

USE_GITHUB=	yes
GH_ACCOUNT=	Chia-Network

CARGO_CRATES=	autocfg-1.1.0 \
		base91-0.0.1 \
		bitflags-1.3.2 \
		bitvec-0.22.3 \
		block-buffer-0.9.0 \
		bls12_381-0.5.0 \
		bumpalo-3.9.1 \
		byteorder-1.4.3 \
		bytestream-0.4.1 \
		cc-1.0.73 \
		cfg-if-1.0.0 \
		chrono-0.4.19 \
		console_error_panic_hook-0.1.7 \
		cpufeatures-0.2.2 \
		derivative-2.2.0 \
		digest-0.9.0 \
		do-notation-0.1.3 \
		encoding8-0.3.2 \
		fastrand-1.7.0 \
		ff-0.10.1 \
		foreign-types-0.3.2 \
		foreign-types-shared-0.1.1 \
		fraction-0.6.3 \
		funty-1.2.0 \
		generic-array-0.14.5 \
		getrandom-0.2.6 \
		group-0.10.0 \
		hex-0.4.3 \
		indoc-0.3.6 \
		indoc-1.0.6 \
		indoc-impl-0.3.6 \
		instant-0.1.12 \
		itoa-1.0.2 \
		js-sys-0.3.57 \
		lazy_static-1.4.0 \
		libc-0.2.126 \
		lock_api-0.4.7 \
		log-0.4.17 \
		num-0.2.1 \
		num-0.4.0 \
		num-bigint-0.2.6 \
		num-bigint-0.4.3 \
		num-complex-0.2.4 \
		num-complex-0.4.1 \
		num-integer-0.1.45 \
		num-iter-0.1.43 \
		num-rational-0.2.4 \
		num-rational-0.4.0 \
		num-traits-0.2.15 \
		once_cell-1.10.0 \
		opaque-debug-0.3.0 \
		openssl-0.10.40 \
		openssl-macros-0.1.0 \
		openssl-src-111.18.0+1.1.1n \
		openssl-sys-0.9.73 \
		pairing-0.20.0 \
		parking_lot-0.11.2 \
		parking_lot_core-0.8.5 \
		paste-0.1.18 \
		paste-impl-0.1.18 \
		pkg-config-0.3.25 \
		proc-macro-hack-0.5.19 \
		proc-macro2-1.0.39 \
		pyo3-0.14.5 \
		pyo3-build-config-0.14.5 \
		pyo3-build-config-0.15.2 \
		pyo3-macros-0.14.5 \
		pyo3-macros-backend-0.14.5 \
		quote-1.0.18 \
		radium-0.6.2 \
		rand_core-0.6.3 \
		redox_syscall-0.2.13 \
		remove_dir_all-0.5.3 \
		ryu-1.0.10 \
		scoped-tls-1.0.0 \
		scopeguard-1.1.0 \
		serde-1.0.137 \
		serde_json-1.0.81 \
		sha2-0.9.9 \
		smallvec-1.8.0 \
		subtle-2.4.1 \
		syn-1.0.95 \
		tap-1.0.1 \
		tempfile-3.3.0 \
		time-0.1.43 \
		typenum-1.15.0 \
		unicode-ident-1.0.0 \
		unicode-segmentation-1.9.0 \
		unindent-0.1.9 \
		vcpkg-0.2.15 \
		version_check-0.9.4 \
		wasi-0.10.2+wasi-snapshot-preview1 \
		wasm-bindgen-0.2.80 \
		wasm-bindgen-backend-0.2.80 \
		wasm-bindgen-futures-0.4.30 \
		wasm-bindgen-macro-0.2.80 \
		wasm-bindgen-macro-support-0.2.80 \
		wasm-bindgen-shared-0.2.80 \
		wasm-bindgen-test-0.3.30 \
		wasm-bindgen-test-macro-0.3.30 \
		web-sys-0.3.57 \
		winapi-0.3.9 \
		winapi-i686-pc-windows-gnu-0.4.0 \
		winapi-x86_64-pc-windows-gnu-0.4.0 \
		wyz-0.4.0 \
		yamlette-0.0.8 \
		skimmer@git+https://github.com/dnsl48/skimmer?rev=ca914ef624ecf39a75ed7afef10e7838fffe9127\#ca914ef624ecf39a75ed7afef10e7838fffe9127 \
		clvm_rust@git+https://github.com/prozacchiwawa/clvm_rs?branch=20211029-try-config\#b9f9c3345243ab1d5968fd16f4a3599d0ec43699

CARGO_BUILD=	no
CARGO_INSTALL=	no

post-extract:
# Remove extraneous unused files to prevent confusion
	@${RM} ${WRKSRC}/pyproject.toml

# This is to prevent Mk/Uses/python.mk do-configure target from firing.
do-configure:

# TODO Has Cargo.toml and pyproject.toml, but no setup.py. Requires maturin.
do-build:
	@(cd ${BUILD_WRKSRC} ; \
		${ECHO_MSG} "===>  Builing Maturin Pyo3 bindings"; \
		${SETENV} ${MAKE_ENV} maturin build --release \
			${WITH_DEBUG:D:U--strip})

# Stage the .so library.
do-install:
	${STRIP_CMD} ${WRKSRC}/target/release/lib${PORTNAME}.so
	${INSTALL_DATA} ${WRKSRC}/target/release/lib${PORTNAME}.so ${STAGEDIR}${PREFIX}/lib
# TODO Portlint concerned about possible direct use of install, but we need
#	to extract the whl into staging. Requires pip.
	${SETENV} ${MAKE_ENV} pip install --isolated --root=${STAGEDIR} \
		--ignore-installed --no-deps ${WRKSRC}/target/wheels/*.whl

# Create the cached byte-code files.
post-install:
	(cd ${STAGEDIR}${PREFIX} && \
	${PYTHON_CMD} ${PYTHON_LIBDIR}/compileall.py -d ${PREFIX} \
	-f ${PYTHONPREFIX_SITELIBDIR:S;${PREFIX}/;;})
#	${STRIP_CMD} ${STAGEDIR}${PYTHONPREFIX_SITELIBDIR}/clvm*.so
# Regenerate .PLIST.pymodtemp from ${STAGEDIR} since the framework
# does not yet support Cargo.toml+pyproject.toml installs.
	@${FIND} ${STAGEDIR} \
		-type f -o -type l | \
		${SORT} | \
		${SED} -e 's|${STAGEDIR}||' \
		> ${WRKDIR}/.PLIST.pymodtmp

do-test:
	@(cd ${WRKSRC}/tests && ${SETENV} ${TEST_ENV} \
		${PYTHON_CMD} generate-programs.py; \
		${PYTHON_CMD} run-programs.py)

# TODO I'm not sure if these messages are errors or noops:
# ===> Creating unique files: Move MAN files needing SUFFIX
# ===> Creating unique files: Move files needing SUFFIX

.include <bsd.port.mk>
