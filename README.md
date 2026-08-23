# Lexicon

Lexicon is a small, Omarchy-native translation and dictionary popup inspired
by Kindle and Android. Select a word or short phrase in a Wayland application,
press a shortcut, and see the English translation near the pointer.

It auto-detects French, Spanish, and German. Single words also receive a short
definition for the resulting English word when one is available. The popup is
theme-aware, does not take keyboard focus, and closes itself after a few
seconds.

## Requirements

- Omarchy 4 / Quattro with `omarchy-shell`
- `curl`, `jq`, `wl-clipboard`, and `hyprctl` (included with Omarchy)
- Internet access for translation and definitions

Lexicon uses the free, keyless MyMemory API for translation and language
detection, and Free Dictionary API for English definitions. Selected text is
sent to those services. There is no paid API, account, or LLM involved.
Remote responses are size-capped and validated before their text is rendered
as plain text in the popup.

## Install

```bash
omarchy plugin add https://github.com/Panadestein/omarchy-lexicon.git --enable
```

Add a shortcut to `~/.config/hypr/bindings.lua`:

```lua
o.bind("SUPER + ALT + D", "Lexicon", os.getenv("HOME") .. "/.config/omarchy/plugins/panadestein.lexicon/lexicon")
```

Then validate the Hyprland configuration:

```bash
hyprctl reload
hyprctl configerrors
```

## Use

Select a word or short phrase in a Wayland application and press
`SUPER + ALT + D`. Lexicon reads the Wayland primary selection, leaving the
regular clipboard unchanged.

## Remove

Remove the `Lexicon` binding from `~/.config/hypr/bindings.lua`, then run:

```bash
omarchy plugin remove panadestein.lexicon
```

## Limitations

- Applications must publish selected text to the Wayland primary selection.
- Translation quality and availability depend on MyMemory's free service.
- Definitions are for English headwords and may not exist for every result.
- Very short words can be ambiguous for automatic language detection.

## License

MIT
