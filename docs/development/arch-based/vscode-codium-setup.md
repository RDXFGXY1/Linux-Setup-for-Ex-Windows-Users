# Installing VS Code and VSCodium on Garuda Linux

This guide covers how to install two popular code editors, Visual Studio Code (VS Code) and its open-source counterpart, VSCodium, on Garuda Linux. Since Garuda is based on Arch Linux, we will primarily use the Arch User Repository (AUR).

## Understanding the AUR

The **Arch User Repository (AUR)** is a community-driven repository for Arch-based systems. It contains package descriptions (`PKGBUILDs`) that allow you to compile and install software not available in the official repositories. Garuda comes pre-configured with tools to easily access the AUR.

## Method 1: Using `pamac` (The Recommended GUI Method)

Garuda's "Add/Remove Software" tool (`pamac`) has built-in support for the AUR.

1.  **Open "Add/Remove Software"** from your application menu.
2.  **Enable AUR support:** If it's not already enabled, go to the preferences (click the three dots/hamburger menu) and on the "Third Party" tab, make sure "Enable AUR support" is toggled on.
3.  **Search for your editor:**
    *   For **VS Code**, search for `visual-studio-code-bin`.
    *   For **VSCodium**, search for `vscodium-bin`.
    *(Note: The `-bin` suffix means the package will download a pre-compiled binary, which is much faster than compiling from source.)*
4.  **Click "Build"** and then "Apply" to install the package. Pamac will handle downloading, building, and installing the application and its dependencies.

## Method 2: Using an AUR Helper (Command Line)

Garuda comes with `yay`, a popular command-line AUR helper.

1.  **Open a terminal.**
2.  **Update your system and AUR packages:**
    ```bash
    yay -Syu
    ```
3.  **Install your chosen editor:**
    *   For **VS Code**:
        ```bash
        yay -S visual-studio-code-bin
        ```
    *   For **VSCodium**:
        ```bash
        yay -S vscodium-bin
        ```
4.  `yay` will prompt you to review the build files (you can press `q` to skip) and then proceed with the installation.

## What's the Difference Between VS Code and VSCodium?

*   **Visual Studio Code** (`visual-studio-code-bin`) is Microsoft's official build. It includes Microsoft's branding, telemetry (data collection), and is licensed under a proprietary Microsoft license. The official Microsoft marketplace for extensions is enabled by default.
*   **VSCodium** (`vscodium-bin`) is a community-driven, open-source build of the same source code. It has all telemetry and tracking disabled. It uses the Open VSX Registry for extensions instead of the official Microsoft marketplace, though you can configure it to use Microsoft's. It's ideal for users who want a 100% open-source experience.

Both editors are functionally identical for coding. The choice depends on your preference for open-source purity versus official branding and support.