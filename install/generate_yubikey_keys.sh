#!/usr/bin/env bash

set -eou pipefail

TOOLS=(
	ykpersonalize
	yubico-piv-tool
	pkcs15-tool
	ssh-keygen
	brew
)

for TOOL in "${TOOLS[@]}"; do
	if ! command -v $TOOL >/dev/null 2>&1; then
		echo "Unable to find $TOOL, please install and try again" >&2
		exit 1
	fi
done

if [[ $# -eq 1 ]] && [[ "$1" = "first-run" ]]; then
	echo "Setting the YubiKey to be a U2F device and behave as a smart card"
	ykpersonalize -m 86

	echo "Please set a new managment key:"
	yubico-piv-tool -aset-mgm-key || true

	echo "Please set the device PIN:"
	yubico-piv-tool -achange-pin -P123456

	echo "Please set the device PUK:"
	yubico-piv-tool -achange-puk -P12345678

	echo "Please confirm the PIN is set correctly:"
	pkcs15-tool --verify-pin
fi

echo "Gnenerating RSA keypair..."
yubico-piv-tool -s 9a -a generate -k --pin-policy=once --touch-policy=always --algorithm=RSA2048 -o public.pem

echo "Generating self-signed SSH key..."
yubico-piv-tool -a verify-pin -a selfsign-certificate -s 9a -S '/CN=ssh/' --valid-days=365 -i public.pem -o cert.pem

echo "Please touch the device."

echo "Importing self-signed key..."
yubico-piv-tool -k -a import-certificate -s 9a -i cert.pem

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
SHARED_LIBRARY_PATH="${HOMEBREW_PREFIX}/lib"

echo "Exporting public key for PKCS#11..."
ssh-keygen -D ${SHARED_LIBRARY_PATH}/pkcs11/opensc-pkcs11.so -e

echo "Exporting public key..."
ssh-keygen -i -m PKCS8 -f public.pem

echo "Please confirm the public key status:"
yubico-piv-tool -a status

# if [[ -f ${SHARED_LIBRARY_PATH}/libykcs11.dylib ]]; then
# 	ssh-add -s ${SHARED_LIBRARY_PATH}/libykcs11.dylib
# fi

echo "Please confirm the key has been added to SSH:"
ssh-add -L

GITHUB_USERNAME=$(git config --get github.user)
echo "You can now add the following to ~/.ssh/config:"
cat <<-EOF
	Host github.com
	PKCS11Provider "${SHARED_LIBRARY_PATH}/opensc-pkcs11.so"
	Port 22
	User $GITHUB_USERNAME
EOF
