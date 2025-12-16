<div align="center">
orion-package/
├── install.sh              # Main installer (downloads from GitHub)
├── install                 # Local installation script
├── uninstall.sh           # Clean removal script
├── README.md
├── orion                  # Main command executable
└── modules/               # Module directory
    ├── update-discord
    ├── update-spotify
    └── (other modules)
<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxC82urGX3_0kpt-He3s81g0M2864gSzJlUA&s" width="800" alt="Linux Penguin">
   
# Linux for Windows Refugees

### A comprehensive guide for users switching from Windows to Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-4facfe.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Disocrd](https://img.shields.io/badge/Join-Discord-00f2fe.svg?style=for-the-badge)](https://discord.gg/5x5dG4Mssv)

---

**Whether you're leaving Windows due to end-of-support, privacy concerns, or just want something better—this guide is for you.**

[Get Started](#getting-started) • [Software Alternatives](#software-alternatives) • [FAQ](#faq) • [Contribute](#contributing)

</div>

---

## Why Switch to Linux?

<table>
<tr>
<td width="50%">

### End of Support
Windows 10 support ends October 2025, forcing expensive upgrades or hardware replacement. Linux runs on any hardware, forever.

### Privacy Concerns
No more telemetry, forced updates, and data collection. Your computer, your rules.

### Performance
Linux runs significantly faster on older hardware. Breathe new life into aging machines.

</td>
<td width="50%">

### Zero Cost
Completely free, no license fees, no subscriptions, no hidden costs. Ever.

### Full Control
You own your system, not Microsoft. Customize everything exactly how you want.

### Built-in Security
Superior protection against malware and viruses. Antivirus rarely needed for personal use.

</td>
</tr>
</table>

---

## Getting Started

### Choosing the Right Distribution

The "best" Linux distribution depends entirely on your needs. We've created a detailed guide to help you choose based on your intended use case.

**[See our complete guide to choosing the right distro →](./docs/choosing-a-distro/README.md)**

---

## Installation Guide

### Step 1: Create a Bootable USB

#### On Windows:
1. Download [Rufus](https://rufus.ie/)
2. Insert USB drive (8GB or larger)
3. Open Rufus and select your downloaded Linux ISO file
4. Click "Start"

#### On Linux:
```bash
# Using dd command (replace /dev/sdX with your USB drive)
sudo dd if=linux-distro.iso of=/dev/sdX bs=4M status=progress
```

### Step 2: Backup Your Data

> **CRITICAL:** Before installing Linux, backup all important files from Windows.

**Recommended backup locations:**
- External hard drive
- Cloud storage (Google Drive, Dropbox, OneDrive)
- Secondary internal drive

### Step 3: Installation Process

1. **Boot from USB**
   - Restart computer
   - Press F12, F2, or Del during boot (varies by manufacturer)
   - Select USB drive from boot menu

2. **Choose Installation Type**
   - **Replace Windows:** Erases Windows completely (recommended for dedicated Linux users)
   - **Dual Boot:** Keep Windows alongside Linux (good for testing)
   - **Something Else:** Manual partitioning (advanced users)

3. **Follow the Installer**
   - Select language
   - Configure keyboard layout
   - Create user account
   - Wait for installation (15-30 minutes)

4. **Reboot and Enjoy**

---

## Software Alternatives

| Windows Software | Linux Alternative | Notes |
|-----------------|-------------------|-------|
| Microsoft Office | LibreOffice | Full office suite, compatible with MS formats |
| Adobe Photoshop | GIMP, Krita | Free, powerful image editors |
| Adobe Premiere | Kdenlive, DaVinci Resolve | Professional video editing |
| Notepad++ | Gedit, Kate, VSCode | Text editors and IDEs |
| Windows Media Player | VLC | Plays everything |
| Internet Explorer/Edge | Firefox, Chrome, Brave | Modern browsers |
| Paint | Krita, Pinta | Drawing and painting |
| 7-Zip | File Roller, Ark | Built-in archive managers |
| Task Manager | System Monitor, htop | Process management |
| CCleaner | BleachBit | System cleaning |
| Windows Defender | ClamAV | Antivirus (rarely needed) |
| iTunes | Rhythmbox, Audacious | Music players |
| AutoCAD | FreeCAD, LibreCAD | CAD software |
| Visual Studio | VSCode, JetBrains IDEs | Development environments |

---

## File System Differences

### Windows vs Linux Paths

| Concept | Windows | Linux |
|---------|---------|-------|
| Root | `C:\` | `/` |
| User folder | `C:\Users\username\` | `/home/username/` or `~` |
| Program files | `C:\Program Files\` | `/usr/bin/`, `/opt/` |
| System files | `C:\Windows\` | `/etc/`, `/boot/` |
| Path separator | `\` (backslash) | `/` (forward slash) |
| Documents | `C:\Users\username\Documents` | `~/Documents` |
| Downloads | `C:\Users\username\Downloads` | `~/Downloads` |

### Common Linux Directories

- `/home` — User home directories (like `C:\Users`)
- `/etc` — System configuration files
- `/usr` — User programs and data
- `/var` — Variable data (logs, caches)
- `/tmp` — Temporary files (cleared on reboot)
- `/opt` — Optional software
- `/mnt` — Mount points for drives

---

## Scripts and Tools

### `pkgup` - Package Updater

A simple, modular command-line tool for updating self-contained applications that aren't managed by your system's main package manager.

**[Learn more about `pkgup` →](./Scripts/%5Bpkgup%5D%20package%20update/README.md)**

---

## Resources

<table>
<tr>
<td width="50%">

### Official Documentation
- [Ubuntu Documentation](https://help.ubuntu.com/)
- [Arch Wiki](https://wiki.archlinux.org/)
- [Linux Mint User Guide](https://linuxmint.com/documentation.php)

### Learning Resources
- [Linux Journey](https://linuxjourney.com/) — Interactive tutorials
- [The Linux Command Line](http://linuxcommand.org/tlcl.php) — Free book
- [DistroWatch](https://distrowatch.com/) — Compare distributions

</td>
<td width="50%">

### Communities
- [r/linux4noobs](https://reddit.com/r/linux4noobs) — Beginner-friendly
- [r/linuxquestions](https://reddit.com/r/linuxquestions) — Q&A
- [Linux.org Forums](https://www.linux.org/forums/)
- [Ubuntu Forums](https://ubuntuforums.org/)

### YouTube Channels
- **Chris Titus Tech** — Tutorials and guides
- **DistroTube** — Linux news and reviews
- **The Linux Experiment** — User-friendly content
- **LearnLinuxTV** — Comprehensive tutorials

</td>
</tr>
</table>

---

## Troubleshooting

**[Visit our complete troubleshooting guide →](./docs/troubleshooting/README.md)**

Common topics covered:
- Wi-Fi and Bluetooth issues
- Graphics driver problems
- Audio not working
- Printer setup
- Windows dual boot issues

---

## Advanced Topics

- **[Gaming on Linux](./docs/gaming/README.md)** — Steam, Proton, and game compatibility
- **[Development on Linux](./docs/development/README.md)** — Set up your dev environment
- **[Command-Line Basics](./docs/command-line/README.md)** — Essential terminal commands
- **[Customization](./docs/customization/README.md)** — Themes, icons, and desktop tweaks

---

## FAQ

<details>
<summary><strong>Will my Windows programs work on Linux?</strong></summary>

Many Windows programs work through Wine or Proton. Check [WineHQ](https://www.winehq.org/) for compatibility of specific applications.
</details>

<details>
<summary><strong>Can I still use Microsoft Office?</strong></summary>

Use LibreOffice (compatible with Office files) or Office 365 web version in your browser.
</details>

<details>
<summary><strong>Is Linux safe from viruses?</strong></summary>

Linux is much more secure than Windows. Antivirus software is rarely needed for personal use due to the architecture and permissions system.
</details>

<details>
<summary><strong>Can I go back to Windows?</strong></summary>

Yes! You can always reinstall Windows or keep it in a dual boot setup for flexibility.
</details>

<details>
<summary><strong>Will my hardware work?</strong></summary>

Most hardware works out-of-the-box. Check compatibility for specific devices before installing, especially newer or specialized hardware.
</details>

<details>
<summary><strong>Is Linux difficult to learn?</strong></summary>

Modern Linux distributions are as easy to use as Windows. The terminal is optional for most everyday tasks.
</details>

<details>
<summary><strong>Can I game on Linux?</strong></summary>

Yes! Thanks to Steam Proton, the vast majority of Windows games work seamlessly on Linux.
</details>

<details>
<summary><strong>Do I need to use the terminal?</strong></summary>

No, but learning basic commands makes many tasks faster and easier. It's a powerful tool, not a requirement.
</details>

---

## Contributing

We welcome contributions from the community!

### How to Contribute:

1. **Fork this repository**
2. **Create a new branch:** `git checkout -b feature/your-tutorial`
3. **Add your tutorial or improvement**
4. **Commit changes:** `git commit -m "Add tutorial for X"`
5. **Push to branch:** `git push origin feature/your-tutorial`
6. **Open a Pull Request**

### Contribution Guidelines:

- Keep tutorials clear and beginner-friendly
- Test all commands before submitting
- Include screenshots where helpful
- Use proper markdown formatting
- Explain why, not just how

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

## Support This Project

If you find this guide helpful:
- ⭐ Star this repository
- Report issues and bugs
- Suggest improvements
- Share with others leaving Windows

---

**Made with care by the Linux community for Windows refugees**

*"The best time to switch to Linux was 10 years ago. The second best time is now."*

</div>
