#!/bin/bash

# Update embedded GPG keys to avoid build flakiness.

set -e

TARGET_DIRS=(
	8.8
)

DEB_KEYS=(
	427CB69AAC9D00F2A43CAF1CBA3CBA3FFE22B574 # Herbert Valerio Riedel (GHC Debian Packages)
)

STACK_KEYS=(
	C5705533DA4F78D8664B5DC0575159689BEFB442 # FPComplete (Stack master release key)
	2C6A674E85EE3FB896AFC9B965101FF31C5C154D # Emanuel Borsboom (Stack release engineer)
)

export GNUPGHOME="$(mktemp -d)"
for key in "${DEB_KEYS[@]}" "${STACK_KEYS[@]}"; do
	gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"
done

for dir in "${TARGET_DIRS[@]}"; do
	:> "$dir"/DEB_KEYS
	:> "$dir"/STACK_KEYS
	for key in "${DEB_KEYS[@]}"; do
		gpg --export -a "$key" >> "$dir"/DEB_KEYS
	done
	for key in "${STACK_KEYS[@]}"; do
		gpg --export -a "$key" >> "$dir"/STACK_KEYS
	done
done

