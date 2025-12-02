# Troubleshooting Sound Issues

Sound problems on Linux can be caused by incorrect output device selection, muted channels, or driver issues. Modern Linux uses an audio server (like PipeWire or PulseAudio) to manage all audio streams, so this is the best place to start troubleshooting.

---

### Step 1: The Absolute Basics

Before diving into complex configurations, check the simple things.

1.  **Check Volume Levels:**
    - Click the volume icon in your system tray. Make sure the master volume is not muted and is turned up.
    - Check the volume in the application you are using (e.g., YouTube, VLC). Many apps have their own volume controls.

2.  **Check Physical Connections:**
    - If you are using speakers or headphones, ensure they are securely plugged into the correct audio jack (usually green).
    - If it's a USB headset, try a different USB port.

3.  **Select the Correct Output Device:**
    - Go to `System Settings` > `Sound`.
    - Under the `Output` tab, you will see a list of all detected audio devices (e.g., "Built-in Audio," "HDMI / DisplayPort," "USB Headset").
    - **Select the device you want to use.** This is the most common cause of "no sound"—the system is sending audio to the wrong output (like an unplugged HDMI port).
    - Play a sound and click through each device in the list to see which one works.

### Step 2: Use PulseAudio Volume Control (pavucontrol)

`pavucontrol` is a powerful graphical tool for managing your audio server. It gives you more detailed control than the default system settings.

1.  **Install `pavucontrol`:**
    ```bash
    sudo pacman -S pavucontrol
    ```

2.  **Launch `pavucontrol`:** Open it from your application menu.

3.  **Check the `Playback` Tab:**
    - Play some audio in the background (e.g., a YouTube video).
    - You should see the application listed here (e.g., "Firefox: AudioStream").
    - A volume bar should be moving, showing that audio is being produced.
    - Make sure the application is not muted (the mute button looks like  M).

4.  **Check the `Output Devices` Tab:**
    - This lists your hardware outputs.
    - Make sure the correct device is not muted.
    - Look for the "Set as fallback" button (a green checkmark). Click it for the device you want to be the default.

5.  **Check the `Configuration` Tab:**
    - This tab lets you enable or disable hardware profiles.
    - Find your built-in audio controller (e.g., "Built-in Audio").
    - Click the `Profile` dropdown menu. You will see options like "Analog Stereo Duplex," "Analog Stereo Output," "Digital Stereo (HDMI) Output," etc.
    - **Try changing the profile.** Sometimes the wrong profile is selected by default. For standard speakers/headphones, you want "Analog Stereo Output" or "Analog Stereo Duplex."

### Step 3: Restart the Audio Server

If things seem stuck, restarting the audio server can often fix it.

- **For PipeWire (default on modern Ubuntu, Fedora, Manjaro):**
  ```bash
  systemctl --user restart pipewire pipewire-pulse
  ```

- **For PulseAudio (older systems):**
  ```bash
  pulseaudio -k
  pulseaudio --start
  ```
  After restarting, check `pavucontrol` again.

### Step 4: Check for Muted Channels with `alsamixer`

`alsamixer` is a terminal-based tool that gives you low-level access to your sound card's channels. Sometimes, a channel can be muted here even if it looks fine everywhere else.

1.  **Run `alsamixer`:**
    ```bash
    alsamixer
    ```

2.  **Navigate `alsamixer`:**
    - Use the arrow keys (`left`/`right`) to select different channels.
    - Use the arrow keys (`up`/`down`) to change the volume.
    - **Important:** Look for channels labeled `Master` and `PCM`. Ensure they are turned up.
    - Look for any channels that have `[MM]` at the bottom. This means they are muted. Select the channel and press the `M` key to unmute it. It should change to `[00]`.
    - Press `Esc` to exit.

3.  **Select the correct sound card:**
    - If you have multiple sound cards, press `F6` inside `alsamixer` to see a list and select the one you want to configure.

### Step 5: Reinstall Audio Drivers (Advanced)

If none of the above works, you can try reinstalling the core audio packages. This is a last resort.

- **For PipeWire (default on Garuda):**
  If you suspect an issue with PipeWire itself, you can try reinstalling its packages:
  ```bash
  sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
  ```
  After reinstalling, reboot your computer.

---

By following these steps, you can solve over 95% of common sound issues. The key is usually in `pavucontrol` under the `Output Devices` or `Configuration` tabs.
