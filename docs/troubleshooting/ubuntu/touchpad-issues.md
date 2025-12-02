# Troubleshooting Touchpad Issues on Ubuntu

This guide helps resolve common touchpad problems on Ubuntu, like the cursor not moving, tap-to-click not working, or erratic behavior.

---

## Step 1: Check Basic Settings

Before diving into technical fixes, make sure your touchpad isn't simply disabled in the settings.

1.  **Open "Settings"** and go to the "Mouse & Touchpad" tab.
2.  **Check for a "Touchpad" section.** If it's not there, your system may not be detecting the touchpad at all (see later steps).
3.  **Ensure the "Touchpad" toggle is on.**
4.  **Review the available settings,** such as "Tap to Click" and "Natural Scrolling," and make sure they are configured as you expect.
5.  **Check for a physical toggle key** on your laptop's keyboard (e.g., `Fn` + `F7`). It's possible the touchpad has been disabled at the hardware level.

## Step 2: Identify Your Touchpad and Driver

Modern Ubuntu uses the `libinput` driver for almost all touchpads. The older `synaptics` driver is largely deprecated but may still be in use on older systems.

1.  **Check if `libinput` is installed:**
    ```bash
    sudo apt install xserver-xorg-input-libinput
    ```
    This is almost always installed by default.

2.  **List your input devices:** This command will show you what devices the display server recognizes.
    ```bash
    xinput list
    ```
    Look for your touchpad in the list. It will have an ID number.

3.  **Check the device properties:** Use the ID number from the previous command to see all the properties of your touchpad, which confirms which driver is managing it.
    ```bash
    xinput list-props <DEVICE_ID>
    ```
    You should see "libinput" in the property names.

## Step 3: Kernel Parameters (If Touchpad is Not Detected)

If your touchpad doesn't appear in `xinput list` or in the Settings panel, the kernel may be having trouble initializing it. You can try adding a kernel parameter to GRUB.

1.  **Edit the GRUB configuration file:**
    ```bash
    sudo nano /etc/default/grub
    ```
2.  **Find the line** `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`.
3.  **Add a parameter** to this line. Try **one** of the following options.
    *   `psmouse.proto=bare`
    *   `psmouse.proto=imps`

    For example:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash psmouse.proto=bare"`

4.  **Save the file and update GRUB:**
    ```bash
    sudo update-grub
    ```
5.  **Reboot your computer.**

## Step 4: Check Kernel Messages

If the touchpad is still not working, check the kernel's log for specific errors.

```bash
dmesg | grep -i "synaptic\|touchpad\|psmouse"
```
Look for any error messages that might indicate a firmware issue or a hardware detection failure. Searching for these specific error messages online can often lead to a solution for your exact model.

## Step 5: Advanced Configuration (Using `xorg.conf.d`)

While `libinput` works out-of-the-box for most devices, you can create a custom configuration file to override its behavior. This is an advanced step and should only be used if specific options are not behaving correctly.

1.  **Create a new configuration file:**
    ```bash
    sudo nano /etc/X11/xorg.conf.d/40-libinput.conf
    ```
2.  **Add configuration.** For example, to enable tap-to-click for a touchpad that isn't respecting the setting:
    ```
    Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
    EndSection
    ```
3.  Save and reboot to apply the changes.
