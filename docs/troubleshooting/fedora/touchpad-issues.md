# Troubleshooting Touchpad Issues on Fedora

This guide helps resolve common touchpad problems on Fedora, like the cursor not moving, tap-to-click not working, or erratic behavior. Fedora uses Wayland by default, which handles input devices differently from the older X11 system.

---

## Step 1: Check Basic Settings

Before diving into technical fixes, make sure your touchpad isn't simply disabled in the settings.

1.  **Open "Settings"** and go to the "Mouse & Touchpad" tab.
2.  **Check for a "Touchpad" section.** If it's not there, your system may not be detecting the touchpad at all (see later steps).
3.  **Ensure the "Touchpad" toggle is on.**
4.  **Review the available settings,** such as "Tap to Click" and "Natural Scrolling," and make sure they are configured as you expect.
5.  **Check for a physical toggle key** on your laptop's keyboard (e.g., `Fn` + `F7`). It's possible the touchpad has been disabled at the hardware level.

## Step 2: Identify Your Touchpad and Driver

Fedora uses the `libinput` driver for all modern input devices.

1.  **Check if the hardware is detected:** The `libinput` command-line tool can show all input devices the system sees.
    ```bash
    sudo libinput list-devices
    ```
    Look for your touchpad in the list. If it's not there, the kernel may not be detecting it (see Step 3).

2.  **Debug events (to see if it's working at a low level):** This command will print out events as you touch the touchpad. It's the best way to see if the hardware is responding, even if the cursor isn't moving.
    ```bash
    sudo libinput debug-events
    ```
    Press `Ctrl+C` to stop. If you see output when you touch the pad, the hardware is working, and the problem is with a higher-level setting.

## Step 3: Kernel Parameters (If Touchpad is Not Detected)

If your touchpad doesn't appear in `libinput list-devices`, the kernel may be having trouble initializing it. You can try adding a kernel parameter to GRUB.

1.  **Edit the GRUB configuration file:**
    ```bash
    sudo nano /etc/default/grub
    ```
2.  **Find the line** `GRUB_CMDLINE_LINUX="... quiet"`.
3.  **Add a parameter** to the end of this line (inside the quotes). Try **one** of the following options.
    *   `psmouse.proto=bare`
    *   `psmouse.proto=imps`

    For example:
    `GRUB_CMDLINE_LINUX="... quiet psmouse.proto=bare"`

4.  **Save the file and update GRUB:**
    ```bash
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    ```
5.  **Reboot your computer.**

## Step 4: Check Kernel Messages

If the touchpad is still not working, check the kernel's log for specific errors.

```bash
dmesg | grep -i "synaptic\|touchpad\|psmouse"
```
Look for any error messages that might indicate a firmware issue or a hardware detection failure. Searching for these specific error messages online can often lead to a solution for your exact laptop model.

## Note on Advanced Configuration

On Fedora's default Wayland session, there is no `xorg.conf` file to edit for input devices. Configuration is handled by `libinput` directly, and user-level overrides are less common and more complex than on X11. The vast majority of touchpad issues on Fedora are resolved either through the main Settings panel or by fixing hardware detection at the kernel level (Steps 3 and 4).
