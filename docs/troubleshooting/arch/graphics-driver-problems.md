# Troubleshooting Graphics Driver Problems

Graphics driver issues can cause problems like screen tearing, poor performance, incorrect resolutions, or even a black screen on boot. This guide covers the basics of managing graphics drivers on Linux for Intel, AMD, and NVIDIA hardware.

---

### Step 1: Identify Your Graphics Card (GPU)

Before doing anything, you need to know what GPU you have. Open a terminal and run:
```bash
lspci -k | grep -A 2 -E "VGA|3D"
```
This command will show you:
- Your GPU model (e.g., NVIDIA Corporation GP107 [GeForce GTX 1050 Ti]).
- The `Kernel driver in use:`. This tells you which driver is currently active (e.g., `nouveau`, `amdgpu`, `i915`, `nvidia`).

---

### Step 2: Understand the Types of Drivers

- **Open-Source Drivers:** These are included in the Linux kernel and work out-of-the-box.
  - **`i915`:** For Intel GPUs. Generally the best choice; no action needed.
  - **`amdgpu`:** For modern AMD GPUs. This is the official open-source driver and offers excellent performance.
  - **`nouveau`:** The open-source driver for NVIDIA GPUs. It's great for basic desktop use but lacks performance for gaming and professional applications.

- **Proprietary (Closed-Source) Drivers:** These are developed by the manufacturer (NVIDIA and sometimes AMD).
  - **NVIDIA:** The proprietary NVIDIA driver is essential for gaming, 3D rendering, and video acceleration. This is usually what you want if you have an NVIDIA card.
  - **AMD:** AMD also offers a proprietary "AMDGPU-PRO" driver, but for most users (including gamers), the open-source `amdgpu` driver is recommended as it's simpler and performs just as well.

---

### Step 3: Installing Drivers

#### For Intel GPUs
You're done! The `i915` driver is already in the kernel and is the best one to use. Just keep your system updated.

#### For AMD GPUs
You're also likely done. The open-source `amdgpu` driver is already included in the kernel. For the best performance, ensure your system is up-to-date, especially the kernel and Mesa (the 3D graphics library). On Arch/Garuda, Mesa is always up-to-date with your regular system updates.
```bash
sudo pacman -Syu
```

#### For NVIDIA GPUs (The Most Common Case)

The open-source `nouveau` driver is often insufficient. You should install the proprietary NVIDIA driver.

**Using Garuda's Tools (Recommended)**
Garuda Linux provides convenient tools to manage graphics drivers.

1.  **Garuda Settings Manager:** This graphical tool simplifies driver installation. You can find it in your application menu. Look for the "Hardware Configuration" or "Auto-install Drivers" section.
2.  **`optimus-manager` (for laptops with hybrid graphics):** If you have a laptop with both Intel/AMD integrated graphics and a dedicated NVIDIA card, `optimus-manager` is highly recommended. It allows you to switch between graphics cards or use the NVIDIA card as a primary GPU. Install it via `pacman`:
    ```bash
    sudo pacman -S optimus-manager
    ```
    Then, follow its documentation for setup and usage.

**Using Pacman (Manual Installation)**
If you prefer the command line or encounter issues with the GUI tools, you can install the drivers directly.

1.  **Install the main NVIDIA driver package:**
    ```bash
    sudo pacman -S nvidia
    ```
    This will install the latest stable NVIDIA driver along with necessary dependencies. For laptops with older NVIDIA cards, you might need `nvidia-390xx-dkms` or `nvidia-470xx-dkms` from the AUR if not available in the repos.
2.  Reboot your computer.

After installation, run `nvidia-smi` in the terminal. If it outputs a table with your GPU info, the driver is working!

---

### Step 4: Common Post-Installation Fixes

#### Issue: Screen Tearing on NVIDIA
Screen tearing is a common issue. The "Force Full Composition Pipeline" option in the NVIDIA settings is the most effective fix.

**Method 1: Create a permanent Xorg configuration file (Recommended)**
Saving settings directly from `nvidia-settings` to `/etc/X11/xorg.conf` can sometimes be overwritten by system updates. A better method is to create a dedicated configuration file.

1.  Create a new file:
    ```bash
    sudo nano /etc/X11/xorg.conf.d/20-nvidia-tearing.conf
    ```
2.  Add the following content. This enables the option for all monitors.
    ```
    Section "Screen"
        Identifier "Screen0"
        Device "Device0"
        Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    EndSection
    ```
3.  Save the file and reboot. The screen tearing should be gone.

**Method 3: Using a Kernel Parameter**
You can also enable DRM (Direct Rendering Manager) modesetting for the NVIDIA driver, which can help with tearing and provide a smoother experience.

1.  Edit the GRUB config file:
    ```bash
    sudo nano /etc/default/grub
    ```
2.  Find the line `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`
3.  Add `nvidia-drm.modeset=1` to the line:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1"`
4.  Save the file, update GRUB, and reboot:
    ```bash
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```
This method is often preferred for modern NVIDIA cards and desktops. If it causes issues, simply remove the parameter and update GRUB again.

#### Issue: Wrong Resolution
- Open `System Settings` > `Displays`.
- Your monitor should be detected correctly. Click on it and select the desired resolution and refresh rate.
- If the correct resolution isn't listed, it's a strong sign the graphics driver is not loaded correctly. Go back to Step 3.

#### Issue: Black Screen on Boot
This can happen after a driver installation or kernel update.
1.  Boot into a recovery console (often an option in the GRUB boot menu).
2.  If you installed NVIDIA drivers, try uninstalling them to get your desktop back:
    ```bash
    # To remove the nvidia driver and its dependencies
    sudo pacman -Rns nvidia
    # If you installed from AUR, you might need to use your AUR helper, e.g.:
    # paru -Rns nvidia-dkms
    ```
3.  Reboot. Your system should fall back to the `nouveau` driver, allowing you to boot and try a different driver version.

---

Managing graphics drivers is one of the few areas in Linux that can be rough for newcomers. For NVIDIA users, installing the proprietary driver is almost always the right first step.
