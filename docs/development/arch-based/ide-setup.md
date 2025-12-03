# Installing VS Code and VSCodium on Arch-Based Systems

This guide covers how to install two popular code editors on Arch-based systems (like Arch Linux, Manjaro, EndeavourOS, or Garuda):

*   **Visual Studio Code**: The official build from Microsoft.
*   **VSCodium**: A community-driven, open-source build without Microsoft's telemetry.

## Understanding Package Sources

There are several ways to install software on Arch-based systems:

*   **Official Repositories**: The core source of trusted, tested packages, managed with `pacman`.
*   **Arch User Repository (AUR)**: A vast, community-driven repository. Packages are installed via helper tools (like `yay`) or by manually building them with `makepkg`. This is the most common way to get VS Code.
*   **Cross-Distribution Packages**: Formats like Flatpak and Snap, which work across many different Linux distributions.

---

## Method 1: Using the AUR (Recommended)

The AUR is the most popular and integrated method for Arch users. It provides access to `visual-studio-code-bin`, a package that downloads the official pre-compiled binary from Microsoft, ensuring you get the "real" VS Code.

### A) Using an AUR Helper (e.g., `yay`)

An AUR helper automates the process of downloading, building, and installing packages. `yay` is a popular choice.

1.  **Install `yay`** if you don't have it. It needs `git` and `base-devel`.
    ```bash
    sudo pacman -Syu git base-devel --needed
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

2.  **Install VS Code using `yay`:**
    ```bash
    # For the official Microsoft build
    yay -S visual-studio-code-bin

    # For the open-source VSCodium build
    yay -S vscodium-bin
    ```

### B) Using a GUI Package Manager (e.g., `pamac`)

Distributions like Manjaro and Garuda often include a graphical software manager (`pamac`, "Add/Remove Software") with AUR support.

1.  **Enable AUR support:** Open the software manager, find its preferences (often in a three-dot menu), and look for a "Third Party" or "AUR" tab. Make sure AUR support is enabled.
2.  **Search and Install:** Search for `visual-studio-code-bin` or `vscodium-bin` and click the "Build" or "Install" button.

---

## Method 2: Using Flatpak

Flatpak is a universal package manager that works on most Linux distributions.

1.  **Install Flatpak** and enable the Flathub repository if you haven't already.
    ```bash
    sudo pacman -S flatpak
    ```
2.  **Install VS Code from Flathub:**
    ```bash
    flatpak install flathub com.visualstudio.code
    ```

---

## Method 3: Using Snap

Snap is another universal package manager developed by Canonical.

1.  **Install `snapd`** and enable the service.
    ```bash
    sudo pacman -S snapd
    sudo systemctl enable --now snapd.socket
    ```
2.  **Install VS Code from the Snap Store:**
    ```bash
    sudo snap install --classic code
    ```

---

## What's the Difference: VS Code vs. VSCodium?

*   **Visual Studio Code** (`visual-studio-code-bin`) is Microsoft's official build. It includes Microsoft's branding, telemetry (data collection), and is licensed under a proprietary Microsoft license. It is configured to use the official Microsoft Visual Studio Marketplace for extensions by default.
*   **VSCodium** (`vscodium-bin`) is a community-driven, open-source build of the same source code. It has all Microsoft branding, telemetry, and tracking disabled. It uses the Open VSX Registry for extensions, which is an open-source alternative to Microsoft's marketplace. It's ideal for users who want a 100% FLOSS (Free/Libre and Open Source Software) experience.

Both editors are functionally identical for coding. The choice depends on your preference for open-source purity versus official branding and marketplace access.