# Troubleshooting Touchpad Issues

Touchpad problems on laptops usually fall into two categories: the touchpad isn't detected at all, or it's detected but gestures like tap-to-click or two-finger scrolling don't work as expected. Here’s how to fix these issues.

---

### Step 1: The Basics - GUI Settings

Before diving into configuration files, check the graphical settings. Modern Linux desktops provide easy ways to configure most common touchpad options.

1.  **Go to `System Settings` > `Mouse & Touchpad`.**
    *(The name may vary slightly, e.g., "Touchpad" on some systems).*

2.  **Look for common options:**
    - **Enable/Disable Touchpad:** Make sure it's turned on.
    - **Tap to Click:** This is often disabled by default. Enable it if you want to tap the touchpad to register a click.
    - **Natural Scrolling (or "Reverse Scrolling"):** This makes two-finger scrolling behave like a smartphone's touch screen (content moves in the same direction as your fingers). Enable or disable this to match your preference.
    - **Two-Finger Scrolling / Horizontal Scrolling:** Ensure these are enabled.

Test your touchpad after changing these settings. For most users, this is all you need to do.

---

### Step 2: Identify Your Touchpad Driver

Linux uses two main drivers for modern touchpads:
- **`libinput`:** The modern standard for all input devices on Wayland and most Xorg systems. It's the default on virtually all new Linux distributions.
- **`synaptics`:** The older driver. It's more configurable but is now considered legacy. It is generally not recommended unless you have a very old device that `libinput` doesn't support well.

You can check which one is in use:
```bash
grep -i "Using input driver" /var/log/Xorg.0.log
```
Look for lines related to your touchpad. It will tell you whether `libinput` or `synaptics` is managing the device.

---

### Step 3: Advanced Configuration with `libinput`

If the GUI settings are too basic, you can configure `libinput` directly by creating a configuration file. This is useful for enabling features that aren't exposed in the settings menu.

1.  **Find your touchpad's device name:**
    ```bash
    xinput list
    ```
    You will see a list of input devices. Look for your touchpad, e.g., "SynPS/2 Synaptics TouchPad". Note the name.

2.  **Create a configuration file:**
    The file should be placed in `/etc/X11/xorg.conf.d/`. Let's name it `30-touchpad.conf`.
    ```bash
    sudo nano /etc/X11/xorg.conf.d/30-touchpad.conf
    ```

3.  **Add configuration options:**
    Here is a sample configuration that enables tap-to-click, natural scrolling, and middle-click emulation (tapping with three fingers).

    ```
    Section "InputClass"
        Identifier "touchpad"
        Driver "libinput"
        MatchIsTouchpad "on"
        Option "Tapping" "on"
        Option "NaturalScrolling" "on"
        Option "TappingButtonMap" "lrm" # Left, Right, Middle click
        Option "ScrollMethod" "twofinger"
    EndSection
    ```

**Explanation of Common Options:**
- `Identifier`: A unique name for this rule.
- `Driver`: Specifies that we are configuring `libinput`.
- `MatchIsTouchpad "on"`: Tells the system to apply this rule to any device identified as a touchpad.
- `Option "Tapping" "on"`: Enables tap-to-click.
- `Option "NaturalScrolling" "on"`: Enables natural scrolling. Set to `"off"` for traditional scrolling.
- `Option "ClickMethod"`: Can be `"buttonareas"` (for touchpads with no physical buttons) or `"clickfinger"`.
- `Option "DisableWhileTyping" "on"`: Prevents accidental cursor movement while typing.

4.  **Save the file and reboot.** Your new settings should be applied.

---

### Step 4: If Your Touchpad is Not Detected At All

If your touchpad doesn't move the cursor at all and doesn't appear in `xinput list`, the kernel may not be recognizing it properly. This is rare on modern hardware but can happen.

1.  **Check the kernel log for errors:**
    ```bash
    dmesg | grep -i psmouse
    ```
    The `psmouse` driver handles most internal touchpads. Look for any error messages.

2.  **Try a kernel parameter:**
    Sometimes, the driver needs to be told how to handle specific hardware. This is done via GRUB, just like with brightness controls.

    - Edit the GRUB config file: `sudo nano /etc/default/grub`
    - Find the line `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`
    - Add a parameter inside the quotes. A common one to try is `psmouse.proto=imps`.
      `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash psmouse.proto=imps"`
    - Save the file, update GRUB, and reboot.
      ```bash
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      ```

This step is advanced. Before trying it, search online for your laptop model + "linux touchpad not working" to see if there is a known, specific kernel parameter for your device.

---

For the vast majority of users, touchpad issues are resolved simply by enabling tap-to-click and setting the scroll direction in the system's GUI settings.
