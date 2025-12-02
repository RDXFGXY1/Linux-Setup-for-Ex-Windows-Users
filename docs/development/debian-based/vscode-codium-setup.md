# Installing VS Code and VSCodium on Debian-based Linux

This guide covers how to install Visual Studio Code (VS Code) and its open-source version, VSCodium, on Debian-based distributions like Debian, Ubuntu, Kali Linux, and Linux Mint.

The recommended method is to add the official software repositories, which will allow you to get updates automatically through the standard `apt` update process.

## Method 1: Installing Visual Studio Code (Official)

### 1. Add the Microsoft GPG Key and Repository

First, we need to add Microsoft's GPG key to ensure the packages are authentic, and then add their repository.

```bash
# Update the package index and install required packages
sudo apt update
sudo apt install -y software-properties-common apt-transport-https wget

# Import the Microsoft GPG key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

# Add the VS Code repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
```

### 2. Install VS Code

Now that the repository is added, you can install VS Code just like any other package.

```bash
sudo apt update
sudo apt install code
```
You can now launch Visual Studio Code from your application menu.

## Method 2: Installing VSCodium (Open Source)

The process for VSCodium is very similar, using the repository provided by the VSCodium project.

### 1. Add the VSCodium GPG Key and Repository

```bash
# Add the GPG key
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

# Add the repository
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
```

### 2. Install VSCodium

Now, update your package index and install `codium`.

```bash
sudo apt update
sudo apt install codium
```
You can now launch VSCodium from your application menu.

## Alternative: Download and Install the `.deb` Package

If you prefer not to add a repository, you can download the `.deb` package directly from the official websites and install it manually.

1.  Go to the [VS Code download page](https://code.visualstudio.com/Download) or the [VSCodium releases page](https://github.com/VSCodium/vscodium/releases).
2.  Download the `.deb` file for `x64`.
3.  Open a terminal in your Downloads folder and run the installation command (replacing the filename as appropriate).
    ```bash
    sudo apt install ./<filename>.deb
    ```
    Using `apt` to install the local file will automatically handle any required dependencies. The downside of this method is that you will not receive automatic updates.
