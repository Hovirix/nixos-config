# HX NixOS

[![Read the Documentation](https://img.shields.io/badge/Read%20the%20Documentation%20→-000000?style=for-the-badge&logo=vitepress&logoColor=white)](https://hx-nixos.pages.dev)

NixOS configuration managing a laptop and homelab server.

Features Secure Boot, full-disk encryption, declarative containers, zero-trust authentication, and automated backups. Fully documented with VitePress.

## NixOS Stack
[![NixOS Anywhere](https://img.shields.io/badge/NixOS%20Anywhere-89B4FA?style=for-the-badge&logo=nixos&logoColor=1E1E2E)](#)
[![Disko](https://img.shields.io/badge/Disko-F9E2AF?style=for-the-badge&logo=nixos&logoColor=1E1E2E)](#)
[![Impermanence](https://img.shields.io/badge/Impermanence-F5C2E7?style=for-the-badge&logo=nixos&logoColor=1E1E2E)](#)
[![Lanzaboote](https://img.shields.io/badge/Lanzaboote-F38BA8?style=for-the-badge&logo=nixos&logoColor=1E1E2E)](#)
[![Agenix](https://img.shields.io/badge/Agenix-A6E3A1?style=for-the-badge&logo=nixos&logoColor=1E1E2E)](#)

## Repository Structure

```
.
├── docs/               # VitePress documentation site
├── laptop/             # NixOS laptop configuration (flake-based)
│   ├── modules/        # Modular system configuration
│   ├── flake.nix
│   └── flake.lock
├── server/             # NixOS server configuration (flake-based)
│   ├── modules/        # Core system modules
│   ├── containers/     # Declarative OCI containers
│   ├── secrets/        # Age-encrypted secrets
│   ├── flake.nix
│   └── flake.lock
├── flake.nix           # Top-level flake
├── flake.lock
└── README.md
```

## License

[MIT](./LICENSE)
