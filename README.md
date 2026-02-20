# Dot files

## Inspired by [JaKooLit](https://github.com/JaKooLit/Hyprland-Dots)

## Installation

- Install [GNU Stow](https://www.gnu.org/software/stow/)

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

#### Setup separate ssh for repos

Inside `.ssh/config` add:

```bash
Host azure-work
    HostName ssh.dev.azure.com
    User git
    IdentityFile ~/.ssh/rsa_azure_work
    IdentitiesOnly yes
```

and then inside repository set remote to: `git@azure-work:v3/work-repo`, also to change username and email use:

```bash
git config user.name "Nightmare9254"
git config user.email "your_email@example.com"
```

### Spicetify

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
spicetify config color_scheme mocha
spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
spicetify apply
```

### CSpell

- install cspell-lsp

```bash
pnpm add -g cspell-lsp
```
