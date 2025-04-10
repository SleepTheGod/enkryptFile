#!/bin/bash

echo -e"Unban ClumsyLulz pl0x dad"

# Usage:
# ./script.sh -e /path/to/folder     # Encrypt and archive
# ./script.sh -d /path/to/folder.enk # Decrypt and restore

set -euo pipefail

encrypt() {
    local target="$1"
    local output="${target%/}.enk"

    if [[ ! -e "$target" ]]; then
        echo "Target $target does not exist."
        exit 1
    fi

    echo "[*] Archiving and encrypting $target ..."
    tar -czf - "$target" | openssl aes-256-cbc -salt -pbkdf2 -out "$output"
    echo "[*] Removing original $target ..."
    rm -rf "$target"
    echo "[+] Encryption complete: $output"
}

decrypt() {
    local encrypted_file="$1"

    if [[ ! -f "$encrypted_file" ]]; then
        echo "Encrypted file $encrypted_file not found."
        exit 1
    fi

    local output_dir="$(dirname "$encrypted_file")/recovered_$(basename "$encrypted_file" .enk)"
    mkdir -p "$output_dir"

    echo "[*] Decrypting and extracting $encrypted_file ..."
    openssl aes-256-cbc -d -pbkdf2 -in "$encrypted_file" | tar -xz -C "$output_dir"
    echo "[*] Cleaning up: $encrypted_file ..."
    rm -f "$encrypted_file"
    echo "[+] Decryption complete: files restored to $output_dir"
}

main() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 [-e|-d] <target>"
        exit 1
    fi

    case "$1" in
        -e) encrypt "$2" ;;
        -d) decrypt "$2" ;;
        *) echo "Invalid option: $1" ; exit 1 ;;
    esac
}

main "$@"
