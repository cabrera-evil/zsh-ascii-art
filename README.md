
<!--

********************************************************************************

WARNING:

    DO NOT EDIT "zsh-ascii-art/README.md"

    IT IS PARTIALLY AUTO-GENERATED

    (based on plugin logic, aliases, and environment overrides)

********************************************************************************

-->

# Quick reference

- **Maintained by**:  
  [Douglas Cabrera](https://github.com/cabrera-evil)

- **Where to get help**:  
  [GitHub Issues](https://github.com/cabrera-evil/zsh-ascii-art/issues)

# What is zsh-ascii-art?

**zsh-ascii-art** is a lightweight [Oh My Zsh](https://ohmyz.sh) plugin that brings ASCII art integration to your terminal. It overrides `neofetch` with a smarter version (`asciifetch`) that dynamically picks an art file based on your hostname, username, OS, or a custom variable.

It also provides CLI tools and aliases to manage your own ASCII templates stored under `~/.config/ascii`, including:
- listing existing templates
- printing selected art
- editing and creating new art files

Ideal for customizing your terminal startup banners or just adding some aesthetic flair.

# How to use this plugin

Clone the repository into your Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/cabrera-evil/zsh-ascii-art ~/.oh-my-zsh/custom/plugins/zsh-ascii-art
```

Enable the plugin in your `.zshrc`:

```zsh
plugins+=(zsh-ascii-art)
```

Reload your shell or source `.zshrc`:

```bash
source ~/.zshrc
```

# CLI Aliases

| Alias | Description                                                |
| ----- | ---------------------------------------------------------- |
| `aa`  | Print the current ASCII art (auto-selected or by variable) |
| `aal` | List available ASCII art templates                         |
| `aae` | Edit an existing ASCII art file                            |
| `aac` | Create a new ASCII art file interactively                  |

# Environment Variables

| Variable              | Description                                                                    |
| --------------------- | ------------------------------------------------------------------------------ |
| `ZSH_ASCII_ART`       | Name of a specific ASCII file (without `.txt` extension) to override detection |
| `ZSH_ASCII_OPEN`      | If set to `"true"`, auto-runs `neofetch` when the terminal starts              |
| `ZSH_ASCII_DEBUG`     | If `"true"`, enables verbose debug logs for troubleshooting                    |
| `ASCII_ART_DIR`       | Directory where ASCII files are stored (default: `~/.config/ascii`)            |
| `ASCII_ART_EXTENSION` | File extension for ASCII templates (default: `.txt`)                           |

# Auto-selection Order

ASCII files are searched in the following priority:

| Priority | Source                | Example                   |
| -------- | --------------------- | ------------------------- |
| 1        | `ZSH_ASCII_ART`       | `custom-logo.txt`         |
| 2        | `$HOST`               | `dev-workstation.txt`     |
| 3        | `$USER`               | `dev.txt`                 |
| 4        | `uname -s`            | `Linux.txt`, `Darwin.txt` |
| 5        | Fallback to `default` | `default.txt`             |

> The first match found is used.

# ASCII File Management

All templates are stored in `${ASCII_ART_DIR}` (default `~/.config/ascii`) as `.txt` files. You can manage them manually or through the provided commands.

To create a new file:

```bash
aac hello-banner
```

To edit one:

```bash
aae hello-banner
```

To print one explicitly:

```bash
aa hello-banner
```

# neofetch override

The plugin wraps and overrides `neofetch`. Instead of calling it directly, it runs `asciifetch`, which:

1. Detects your preferred ASCII template
2. Passes it to `neofetch` with the `--ascii` flag
3. Falls back to standard `neofetch` if no file is found

# Auto-start behavior

If `ZSH_ASCII_OPEN=true`, the plugin will run `neofetch` (with ASCII art) automatically on terminal start — useful for personalizing your CLI banner.

# License

This project is released under the [MIT License](LICENSE).
