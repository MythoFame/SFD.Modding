# SFDE Format (extension scripts)

`.sfde` files are Superfighters Deluxe **extension scripts**. They use the shared [File Format](../Misc/File%20Format.md)
container and are nearly identical to `.sfdm` maps; this page covers the
differences.

## Layout

```
[h_gv] [h_or] [h_tmp] [h_el] [h_wn] [h_wa] [h_mtp] [h_tg] [h_wd] [h_wdt]
[h_pei] [h_mt] [h_ext] [h_exscript\n] [h_pt] [h_img]
[c_wp] [c_lr] [c_lrp] [c_tl] [c_sobjs] [EOF]
```

Two additions over a map header, and one body section removed:

- `h_ext` is added.
- `h_exscript\n` is added.
- `c_scrpt` is **never present** — the source lives in the header instead.

Annotated excerpt from a real extension script (*Spawn Variety*):

```
0x0138  [5]"h_pei" | 0a "3468475555"           publish ID
0x0149  [4]"h_mt"  | "SFDMAPEDIT"              10 raw bytes
0x0158  [5]"h_ext" | 0d "Versus,Custom"        game modes
0x016C  0b 68 5f 65 78 73 63 72 69 70 74 0a    [11]"h_exscript\n" — token ends with \n
0x0178  2f 2f 20 3c 61 75 74 6f 2d 67 65 6e …  raw C# source, UTF-8, no length prefix
        …                                        (9294 chars in this file)
0x25CA  00                                       NUL terminator
0x25CB  [4]"h_pt" …                             next header section
```

## `h_ext` (game modes)

A comma separated string, e.g. `Versus,Custom`, mirroring the `Map_ScriptTypes`
world property (339). It controls which game modes the script attaches to. Valid
values: `Versus`, `Custom`, `Campaign`, `Survival`.

## `h_exscript\n` (the script source)

Two quirks make this section easy to corrupt:

1. **The token itself ends with a newline.** The length prefix is `0x0B` and the
   token bytes are `68 5F 65 78 73 63 72 69 70 74 0A` — `"h_exscript\n"` — *not*
   the 10-character `"h_exscript"`. Parsers looking for `[10]"h_exscript"` will
   miss it; parsers writing `[10]"h_exscript"` leave a stray `0A` that desyncs
   the stream.
2. **The payload is raw UTF-8 terminated by a `00` byte** — no length prefix, no
   Base64 (unlike a map's `c_scrpt`). Because of that, the source itself cannot
   contain NUL characters.

## Everything else is a map

An `.sfde` still embeds a complete world: `c_wp` (with the full property table,
including the `Map_*` mirrors), layers, the custom ID table, objects and `EOF`.
Consequences:

- World-level settings (camera area, weather, world bottom, start commands) can be
  edited the same way as in maps.
- Metadata edits need the same dual writes (header + `c_wp` mirror) as maps.
- Multi-part support in the writer exists, though shipped extension scripts carry
  a single unnamed part in `h_pt`.

## Identifying the file kind

The game decides "extension script" purely by the presence of `h_exscript\n` while
parsing the header, the file extension is just convention:

- `.sfde` with no `h_exscript\n` parses as a plain map.
- `.sfdm` containing `h_exscript\n` behaves as an extension script.
