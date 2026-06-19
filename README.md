# HX NixOS

Personal NixOS flake for one machine: `nixosConfigurations.laptop`.

This repository configures the laptop system from the root flake. The old multi-host layout is gone; there is no `laptop/`, `server/`, or `docs/` directory in the current tree.

## What This Manages

- Secure Boot through lanzaboote and `/var/lib/sbctl`.
- Disk layout through disko for a specific NVMe device, with LUKS and ext4.
- Sway desktop, Flatpak apps, PipeWire, fonts, and desktop packages.
- Development tooling, shell defaults, containers, YubiKey/GnuPG support, and quick VM tooling.
- Restic backups and WireGuard configuration through agenix-managed secrets.

## Layout

```text
.
├── flake.nix                    # root flake; wires the only active host
├── flake.lock                   # pinned inputs
├── system/
│   ├── disko.nix                # machine-specific disk layout
│   └── hardware-configuration.nix
├── modules/
│   ├── core/                    # boot, nix, network, users, time
│   ├── desktop/                 # sway, flatpak, pipewire, fonts, apps
│   ├── dev/                     # packages, shell, containers, yubikey
│   ├── hardware/                # kernel, graphics, bluetooth, tlp, virtualisation
│   └── services/                # dbus, fstrim, getty, restic, wireguard
├── secrets/                     # age-encrypted secrets and recipients
└── AGENTS.md                    # agent-specific repo instructions
```

`flake.nix` is the source of truth for enabled modules. Creating a file under `modules/` does not activate it until it is added to the `modules = [ ... ]` list for `laptop`.

## Commands

Format Nix files:

```bash
nix fmt
```

Check flake evaluation:

```bash
nix flake check
```

The check currently passes and may emit this upstream-style evaluation warning:

```text
'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'
```

Build the laptop system without switching:

```bash
nixos-rebuild build --flake .#laptop
```

Apply the system:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

Only run the switch command when intentionally changing the live machine.

## Secrets

Secrets are age-encrypted files in `secrets/*.age`. Do not commit plaintext secrets.

New agenix secrets need both:

- A recipient declaration in `secrets/secrets.nix`.
- An `age.secrets.<name>` entry in the module that consumes the secret.

Current secret consumers:

- `modules/services/wireguard.nix` uses `secrets/wg_config.age` and reads the age identity from `/home/${username}/.ssh/id_ed25519`.
- `modules/services/restic.nix` uses `secrets/restic_password.age` and `secrets/restic_ssh_key.age`.

## Commit Convention

Use Conventional Commits with a repo-specific scope:

```text
type(scope): short imperative summary
```

Preferred types:

- `feat` for new capabilities.
- `fix` for bug fixes or broken configuration.
- `refactor` for behavior-preserving restructuring.
- `chore` for dependency, lockfile, secret rotation, and maintenance changes.
- `docs` for README and instruction updates.

Preferred scopes match the tree or subsystem, such as `core`, `desktop`, `dev`, `hardware`, `services`, `secrets`, `nix`, or `docs`.

Keep commits focused. Split unrelated system, secret, and documentation changes instead of bundling them into one commit.

Examples:

```text
feat(services): add restic backups
chore(secrets): rotate wireguard config
docs(readme): document laptop flake workflow
```

## License

[MIT](./LICENSE)
