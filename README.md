# Linux for Windows Refugees 🐧

A comprehensive guide for users switching from Windows to Linux. Whether you're leaving Windows due to end-of-support, privacy concerns, or just want something better—this guide is for you.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

---

## Table of Contents

- [Why Switch to Linux?](#why-switch-to-linux)
- [Getting Started](#getting-started)
  - [Choosing the Right Distribution for You](./docs/first-step/README.md)
  - [Installation Guide](#installation-guide)
- [Windows to Linux Transition](#windows-to-linux-transition)
  - [Software Alternatives](#software-alternatives)
  - [File System Differences](#file-system-differences)
- [Troubleshooting Common Issues](./docs/troubleshooting/README.md)
- [Gaming on Linux](./docs/gaming/README.md)
- [Development on Linux](./docs/development/README.md)
- [Command-Line Basics](./docs/command-line/README.md)
- [Customization](./docs/customization/README.md)
- [Contributing](#contributing)

---

## Why Switch to Linux?

### Common Reasons Users Leave Windows:

- **End of Support:** Windows 10 support ends October 2025, forcing expensive upgrades or hardware replacement
- **Privacy Concerns:** Telemetry, forced updates, and data collection
- **Performance:** Linux runs faster on older hardware
- **Cost:** Completely free, no license fees
- **Control:** You own your system, not Microsoft
- **Security:** Better protection against malware and viruses
- **Customization:** Make your system look and work exactly how you want
- **No Forced Updates:** Update on your schedule, not Microsoft's

---

## Getting Started

### Choosing the Right Distribution for You

The "best" Linux distribution depends entirely on your needs. We've created a detailed guide to help you choose based on your intended use case, whether it's for daily tasks, software development, gaming, or security.

➡️ [**See our complete guide to choosing the right distro.**](./docs/choosing-a-distro/README.md)

### Installation Guide

### Step 1: Create a Bootable USB

#### On Windows:
1. Download [Rufus](https://rufus.ie/)
2. Insert USB drive (8GB or larger)
3. Open Rufus
4. Select your downloaded Linux ISO file
5. Click "Start"

#### On Linux:
```bash
# Using dd command (replace /dev/sdX with your USB drive)
sudo dd if=linux-distro.iso of=/dev/sdX bs=4M status=progress
```

### Step 2: Backup Your Data

**IMPORTANT:** Before installing Linux, backup all important files from Windows.

Recommended backup locations:
- External hard drive
- Cloud storage (Google Drive, Dropbox, OneDrive)
- Secondary internal drive

### Step 3: Installation Process

1. **Boot from USB:**
   - Restart computer
   - Press F12, F2, or Del during boot (varies by manufacturer)
   - Select USB drive from boot menu

2. **Choose Installation Type:**
   - **Replace Windows:** Erases Windows completely (recommended for dedicated Linux users)
   - **Dual Boot:** Keep Windows alongside Linux (good for testing)
   - **Something Else:** Manual partitioning (advanced users)

3. **Follow the Installer:**
   - Select language
   - Configure keyboard layout
   - Create user account
   - Wait for installation (15-30 minutes)

4. **Reboot and Enjoy!**

---

## Windows to Linux Transition

### Software Alternatives

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

### File System Differences

#### Windows vs Linux Paths

| Concept | Windows | Linux |
|---------|---------|-------|
| Root | `C:\` | `/` |
| User folder | `C:\Users\username\` | `/home/username/` or `~` |
| Program files | `C:\Program Files\` | `/usr/bin/`, `/opt/` |
| System files | `C:\Windows\` | `/etc/`, `/boot/` |
| Path separator | `\` (backslash) | `/` (forward slash) |
| Documents | `C:\Users\username\Documents` | `~/Documents` |
| Downloads | `C:\Users\username\Downloads` | `~/Downloads` |

#### Common Linux Directories

- `/home` - User home directories (like `C:\Users`)
- `/etc` - System configuration files
- `/usr` - User programs and data
- `/var` - Variable data (logs, caches)
- `/tmp` - Temporary files (cleared on reboot)
- `/opt` - Optional software
- `/mnt` - Mount points for drives



---

## Resources

### Official Documentation
- [Ubuntu Documentation](https://help.ubuntu.com/)
- [Arch Wiki](https://wiki.archlinux.org/) (excellent for all distros)
- [Linux Mint User Guide](https://linuxmint.com/documentation.php)

### Learning Resources
- [Linux Journey](https://linuxjourney.com/) - Interactive tutorials
- [The Linux Command Line](http://linuxcommand.org/tlcl.php) - Free book
- [DistroWatch](https://distrowatch.com/) - Compare distributions

### Communities
- [r/linux4noobs](https://reddit.com/r/linux4noobs) - Beginner-friendly
- [r/linuxquestions](https://reddit.com/r/linuxquestions) - Q&A
- [Linux.org Forums](https://www.linux.org/forums/)
- [Ubuntu Forums](https://ubuntuforums.org/)

### YouTube Channels
- **Chris Titus Tech** - Tutorials and guides
- **DistroTube** - Linux news and reviews
- **The Linux Experiment** - User-friendly content
- **LearnLinuxTV** - Comprehensive tutorials

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

## FAQ

**Q: Will my Windows programs work on Linux?**  
A: Many Windows programs work through Wine or Proton. Check [WineHQ](https://www.winehq.org/) for compatibility.

**Q: Can I still use Microsoft Office?**  
A: Use LibreOffice (compatible with Office files) or Office 365 web version.

**Q: Is Linux safe from viruses?**  
A: Linux is much more secure than Windows. Antivirus is rarely needed for personal use.

**Q: Can I go back to Windows?**  
A: Yes! You can always reinstall Windows or keep it in dual boot setup.

**Q: Will my hardware work?**  
A: Most hardware works out-of-box. Check your specific hardware before installing.

**Q: Is Linux difficult to learn?**  
A: Modern Linux distributions are as easy as Windows. The terminal is optional for most tasks.

**Q: Can I game on Linux?**  
A: Yes! Thanks to Steam Proton, most Windows games work on Linux.

**Q: Do I need to use the terminal?**  
A: No, but learning basic commands makes things faster and easier.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support

If you find this guide helpful:
- ⭐ Star this repository
- 🐛 Report issues
- 📖 Suggest improvements
- 🔄 Share with others leaving Windows

---

**Made with ♥ by the Linux community for Windows refugees**

*"The best time to switch to Linux was 10 years ago. The second best time is now."*
