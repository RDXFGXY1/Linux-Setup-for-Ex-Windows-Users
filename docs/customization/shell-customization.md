# Shell Customization: Starship Terminal Prompt

One of the most impactful ways to personalize your Linux experience, especially for developers and power users, is to customize your terminal prompt. **Starship** is a fast, customizable, cross-shell prompt that allows you to create a beautiful and informative command-line interface.

This guide will show you how to install Starship and apply a custom configuration.

## 1. Install Starship

Starship is a single, self-contained binary, making its installation straightforward across most Linux distributions.

### Using `curl` (Recommended)
This method is generally the easiest and most universal.

```bash
curl -sS https://starship.rs/install.sh | sh
```
This script will download the latest Starship binary and install it to `/usr/local/bin` (or a similar location) and will ask for `sudo` password if required.

### Using your Package Manager (Alternative)
Some distributions include Starship in their official repositories.

*   **Arch-based (Arch, Garuda, EndeavourOS):**
    ```bash
    sudo pacman -S starship
    ```
*   **Debian-based (Debian, Ubuntu, Kali, Mint):**
    ```bash
    sudo apt install starship
    ```
*   **Fedora-based (Fedora, Nobara):
    ```bash
    sudo dnf install starship
    ```
*   **SUSE-based (openSUSE):**
    ```bash
    sudo zypper install starship
    ```
### Using `cargo` (If you have Rust installed)
If you have the Rust toolchain installed, you can install Starship via `cargo`.
```bash
cargo install starship --locked
```

## 2. Install a Nerd Font

Starship uses various symbols and icons to enhance the prompt's appearance. For these to display correctly, you need to install a **Nerd Font** and configure your terminal to use it.

1.  **Download a Nerd Font:** Visit [Nerd Fonts](https://www.nerdfonts.com/font-downloads) and download a font you like (e.g., FiraCode Nerd Font, JetBrainsMono Nerd Font).
2.  **Install the font:**
    *   Extract the downloaded archive.
    *   Copy the `.ttf` or `.otf` files to `~/.local/share/fonts/` (create the directory if it doesn't exist).
    *   Update your font cache: `fc-cache -f -v`
3.  **Configure your terminal:** Open your terminal's settings (e.g., GNOME Terminal preferences, Konsole profile settings) and change the font to the Nerd Font you just installed.

## 3. Enable Starship in Your Shell

After installing Starship, you need to tell your shell to use it. Add the following line to your shell's configuration file:

*   **Bash:** Add to `~/.bashrc`
*   **Zsh:** Add to `~/.zshrc`
*   **Fish:** Add to `~/.config/fish/config.fish`

```bash
# ~/.bashrc or ~/.zshrc or ~/.config/fish/config.fish
eval "$(starship init bash)"  # For Bash
# eval "$(starship init zsh)"  # For Zsh
# starship init fish | source  # For Fish
```
**Important:** Choose only one `eval` line based on your shell. After adding the line, restart your terminal or source your config file (e.g., `source ~/.zshrc`).

## 4. Choose and Apply a Starship Configuration Style

Before choosing, you can see a preview of each style here: ➡️ [**Starship Styles Preview**](./starship-styles-preview.md)

Starship is configured via a `starship.toml` file. Instead of embedding a single style, we've provided several example configurations in the `shell-customization-styles` directory.

1.  **View available styles:**
    You can browse the available `.toml` files in the `docs/customization/shell-customization-styles` directory. To see the content of a style, use `cat`:
    ```bash
    cat docs/customization/shell-customization-styles/uwu-cute-style.toml
    # Or, to list available styles:
    # ls docs/customization/shell-customization-styles/
    ```

2.  **Copy your chosen style:**
    Once you've found a style you like, copy its content to your main Starship configuration file:
    ```bash
    mkdir -p ~/.config
    cp docs/customization/shell-customization-styles/uwu-cute-style.toml ~/.config/starship.toml
    # Replace 'uwu-cute-style.toml' with the name of your chosen style file.
    ```

3.  **Restart your terminal** or open a new one to see the changes.

## Example Outputs

After copying your chosen style to `~/.config/starship.toml` and restarting your terminal, your prompt should look similar to the examples provided within each style's `.toml` file.