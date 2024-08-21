# Dot files

## Installation

- Install (https://www.gnu.org/software/stow/)[GNU Stow]

### Git SSH Auth with Keychain

- Generate ssh key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Start ssh-agent and add public key to it. It should return `> Agent pid 59566`

```bash
eval "$(ssh-agent -s)"
```

```bash
ssh-add ~/.ssh/id_ed25519
```

- Install **keychain**
- Inside .zshrc there should be _eval `keychain --agents ssh --eval id_ed25519`_, which starts and asks for passphrase for added ssh key

### (Spicetify)[https://spicetify.app/docs/getting-started]

- install _Spicetify_ and _Spicetify marketpalce_

```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

```

- Use **stow** to symlink

```bash
stow spicetify
```

- Apply theme

```bash
spicetify config current_theme catppuccin
spicetify config color_scheme frappe
spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
spicetify apply
```
