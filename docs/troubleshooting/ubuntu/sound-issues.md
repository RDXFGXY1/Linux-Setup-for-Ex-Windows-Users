# Troubleshooting Sound Issues on Ubuntu

This guide helps you diagnose and resolve common audio problems on Ubuntu, such as no sound from speakers or headphones, or incorrect device selection.

---

## Step 1: Basic Sound Checks

1.  **Check Volume and Mute Status:** Click the volume icon in the top-right system tray. Make sure the volume is not muted and is turned up.
2.  **Check Output Device:** In the same system tray menu, click the arrow to expand the sound devices. Ensure the correct output device is selected (e.g., "Speakers - Built-in Audio" vs. "HDMI / DisplayPort").
3.  **Test a Different Device:** If you are using headphones, unplug them and see if the speakers work. If you are using speakers, try headphones. This helps determine if the issue is with a specific port or device.

## Step 2: Use Advanced Volume Control (`pavucontrol`)

The default sound settings are basic. `pavucontrol` provides a much more detailed view of your audio streams and devices. It works for both the older PulseAudio and the newer PipeWire sound systems.

1.  **Install `pavucontrol`:**
    ```bash
    sudo apt update
    sudo apt install pavucontrol
    ```
2.  **Launch the PulseAudio Volume Control application.**
3.  **Check the `Output Devices` tab:** Make sure the correct device has the green "Set as fallback" button checked.
4.  **Check the `Playback` tab:** When audio is playing (e.g., a YouTube video), you will see the application listed here. Ensure it's sending audio to the correct output device.
5.  **Check the `Configuration` tab:** Make sure your built-in audio device has a profile selected (e.g., "Analog Stereo Duplex"). Sometimes it can be set to "Off."

## Step 3: Check Hardware-Level Mutes with `alsamixer`

Sometimes, sound channels can be muted at the hardware level, which won't always show up in the GUI.

1.  **Open `alsamixer` in a terminal:**
    ```bash
    alsamixer
    ```
2.  **Select your sound card:** Press `F6` to see a list of sound cards and select the appropriate one.
3.  **Check for muted channels:** Use the arrow keys to navigate. If you see a channel with `MM` at the bottom, it's muted. Navigate to it and press the `M` key to unmute it (`00` will appear). Pay special attention to the `Master` and `PCM` channels.
4.  **Exit `alsamixer`** by pressing `Esc`.

## Step 4: Restart the Sound System

On modern Ubuntu versions (22.04 and newer), PipeWire is the default. On older versions, it was PulseAudio. Restarting the service can resolve glitches.

**For PipeWire (Ubuntu 22.04+):**
```bash
systemctl --user restart pipewire-pulse.service
```

**For PulseAudio (Older Ubuntu versions):**
```bash
pulseaudio -k
pulseaudio --start
```

## Step 5: Check for Kernel and Firmware Issues

If no devices are detected at all, the problem might be at the driver level.

1.  **Check for driver errors:**
    ```bash
    dmesg | grep -i "audio"
    ```
    Look for errors related to your sound hardware.
2.  **Reinstall ALSA and PulseAudio/PipeWire:** This can sometimes fix corrupted configuration.
    ```bash
    sudo apt install --reinstall alsa-base alsa-utils pulseaudio
    # On newer systems, you might need to target pipewire instead
    # sudo apt install --reinstall alsa-base alsa-utils pipewire-audio-client-libraries
    ```
3.  **Install SOF Firmware (for modern Intel audio):** Some modern laptops with Intel CPUs require the `sof-firmware` package.
    ```bash
    sudo apt install sof-firmware
    ```
    Reboot after installing.
