# Dotfiles

## About these dotfiles

These are config files to set up a system the way I like it.

## Installation

    export DESTINATION="$HOME/src/github.com/faun/dotfiles"
    export INSTALL_SCRIPT_URL="https://gist.githubusercontent.com/faun/67fadc3f1525399da236589562cb4583/raw/install_dotfiles.sh?$(date +%s)"
    curl -sSL -o dotfiles_installer.sh "$INSTALL_SCRIPT_URL"
    chmod +x ./dotfiles_installer.sh
    ./dotfiles_installer.sh

## Configuration

There are a number of settings that can be configured for these dotfiles. They are:

##### Git

Create a file at `~/.gitconfig.local`:

    [user]
      name = Your Name
      email = email@example.com

    [github]
      user = username

##### Vim

Add any additional settings in `~/.vimrc.local` or `.vimrc.local` in a project directory for project-specific settings

##### Shell config

Add any additional configuration settings to `~/.local.sh` and these will be sourced at login.

Things that can be added to this file include custom aliases, configuration settings, private environment variables, paths, etc.

##### Secrets (1Password → macOS Keychain → env vars)

`zsh/05_secrets.sh` provides three commands for loading secrets from 1Password into shell env vars, cached in the macOS Keychain so shell startup never blocks on a biometric prompt.

The model is **one 1Password item with many fields**. Each field's label matches the env var name. The item is referenced only by UUID — names rename, UUIDs don't.

Add the following to `~/.local.sh`:

    export OP_ACCOUNT="<account>.1password.com"
    export OP_SECRETS_VAULT="<vault-uuid>"
    export OP_SECRETS_ITEM="<item-uuid>"

Operations:

| Command | What it does |
| --- | --- |
| `secret_store NAME` | Read field `NAME` from 1Password, cache it in Keychain, and record `NAME` in the index. Run once per machine, or after rotating the value. |
| `secret_store_all` | Fetch every populated field on the configured 1Password item and cache all of them. Use to bootstrap a new machine or refresh everything at once. |
| `secret_delete NAME` | Remove the cached value from Keychain and from the index. |
| `secret_load NAME` | Read `NAME` from Keychain and `export NAME=<value>`. Silent on miss. Called automatically at shell startup for every name in the index. |

To add a new secret:

1. In 1Password, add a concealed field labeled exactly `NAME` (the desired env var name) to the configured item.
2. Run `secret_store NAME` once — it caches the value and records `NAME` in the index.
3. Every new shell exports `$NAME` automatically (no manual edit to the file needed).

### Change shell to latest Zsh

    brew install zsh

Add Homebrew Zsh to /etc/shells

    sudo sh -c 'echo "$(which zsh)" >> /etc/shells'

Set Homebrew Zsh as your default user

    sudo chsh -s $(which zsh) $(whoami)

Install tmux

    brew install tmux
    brew install reattach-to-user-namespace

### Zellij (tmux-compatible alternative)

[Zellij](https://github.com/zellij-org/zellij) is installed alongside tmux. tmux
stays the default multiplexer (`t` / `tat`); zellij is opt-in via `zj`, which
attaches to (or creates) a session named after the current directory.

Config lives at `config/zellij/config.kdl` (symlinked to `~/.config/zellij`). It
keeps zellij's native modal keys *and* adds a tmux-compatibility prefix on
`Ctrl+a` so existing muscle memory carries over. After pressing `Ctrl+a`:

| Keys | Action | tmux equivalent |
| --- | --- | --- |
| `Ctrl+a` then `\|` | split right | `prefix \|` |
| `Ctrl+a` then `-` / `\` | split down | `prefix -` / `\` |
| `Ctrl+a` then `c` | new tab | new-window |
| `Ctrl+a` then `,` | rename tab | rename-window |
| `Ctrl+a` then `n` / `p` | next / previous tab | next/prev-window |
| `Ctrl+a` then `h/j/k/l` | move focus | vim-tmux-navigator |
| `Ctrl+a` then `H/J/K/L` | resize pane | `prefix H/J/K/L` |
| `Ctrl+a` then `z` | zoom pane | `prefix z` |
| `Ctrl+a` then `x` | close pane | `prefix x` |
| `Ctrl+a` then `s` | session manager | `prefix s` |
| `Ctrl+a` then `d` | detach | `prefix d` |
| `Ctrl+a` then `[` | scroll / copy mode | `prefix [` |
| `Ctrl+a` then `Ctrl+a` | send literal `Ctrl+a` | send-prefix |

Sessions persist and resurrect automatically (`session_serialization`),
replacing tmux-resurrect/continuum. Native zellij modes (`Ctrl+p` pane,
`Ctrl+t` tab, `Ctrl+n` resize, `Ctrl+o` session, …) remain available.

### Patch your terminal font with Powerline glyphs for maximum awesomeness

See [Powerline repo](https://github.com/Lokaltog/powerline-fonts) for more info.

My personal favorite is [inconsolata-dz](https://github.com/Lokaltog/powerline-fonts/raw/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf).

### Integrate iTerm2 with tmux

See [iTerm2 downloads](http://code.google.com/p/iterm2/downloads/list) for more info
