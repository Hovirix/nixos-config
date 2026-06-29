#!/usr/bin/env bash
set -euo pipefail

nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./system/hardware.nix \
  --flake .#laptop \
  --target-host root@localhost
