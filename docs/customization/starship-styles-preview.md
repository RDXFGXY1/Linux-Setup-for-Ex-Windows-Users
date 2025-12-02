# Starship Prompt Styles Preview

This page provides a preview of the different Starship prompt styles available in the `shell-customization-styles` directory. Use these dropdowns to see how each style looks and feels before applying it.

---

<details>
<summary><strong>1. UwU Cute Style</strong></summary>

A playful, colorful, and expressive two-line prompt with cute emoticons. Great for users who want a fun and visually distinct terminal.

**Normal:**
```
╭─(◉ω◉) kyros@machine ~> ~/Documents
│
╰─♥>
```

**With Git and Language Info:**
```
╭─(◉ω◉) kyros@machine ~> ~/project on ◆ main [~2 +1]
│ ◇py:3.13.7 ◇node:20.0.0 ◈docker:prod took 2s
╰─♥>
```

**With an Error:**
```
╭─(◉ω◉) kyros@machine ~> ~/project
│ took 1s
╰─[(>_<) ERR:127]x>
```

**With Battery and Jobs:**
```
╭─(◉ω◉) kyros@machine ~> ~/Documents
│ [BAT:85%] [JOBS:2]
╰─♥>
```
[➡️ View Configuration File](./shell-customization-styles/uwu-cute-style.toml)

</details>

---

<details>
<summary><strong>2. Minimalist Style</strong></summary>

A clean, single-line prompt that focuses on providing essential information without clutter. It prioritizes a minimal look while still being highly functional.

**Normal:**
```
[14:32] 
➜ 
```

**With Git Info:**
```
[14:33]  main [!+?] 
➜ 
```

**With an Error:**
```
[14:34] 
✗ 
```

**With Battery and Long Command:**
```
[14:35] (75% ) 2s 
➜ 
```
[➡️ View Configuration File](./shell-customization-styles/minimalist-style.toml)

</details>

---

<details>
<summary><strong>3. Power User Style</strong></summary>

A verbose, highly informative prompt designed for system administrators and developers who want to see as much context as possible at all times.

**Normal:**
```
[kyros]@machine[~/Documents] 
➜ 
```

**With Git and Language Info:**
```
[kyros]@machine[~/project] on  main [!+?] 
via 🐳 default in 🐍(3.11.2) 
took 1.2s [⨉1] ✖ 
```

**With Kubernetes and Jobs:**
```
[kyros]@machine[~] at ⛵ my-cluster  2 
➜
```
[➡️ View Configuration File](./shell-customization-styles/power-user-style.toml)

</details>

---

<details>
<summary><strong>4. Classic Style</strong></summary>

A simple, traditional prompt that mimics the look of a classic `bash` shell, but enhances it with Git status information. It's clean, distraction-free, and familiar.

**Normal:**
```
~/Documents 
> 
```

**With Git Info:**
```
~/project on  main ([!+?](bold yellow)) 
> 
```

**With an Error:**
```
~/project 
>
```
[➡️ View Configuration File](./shell-customization-styles/classic-style.toml)

</details>

---

<details>
<summary><strong>5. Dracula Style</strong></summary>

A stylish, single-line prompt inspired by the popular Dracula color theme, using "powerline" style blocks to separate segments.

**Normal:**
```
kyros ~/Documents  ♥ 14:45 
➜ 
```

**With Git and Language Info:**
```
kyros ~/project   main ([!+?](bold yellow))   (1.72.0)  ♥ 14:46 
➜
```
[➡️ View Configuration File](./shell-customization-styles/dracula-style.toml)

</details>
