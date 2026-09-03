# SFDM Format (map files)

`.sfdm` files are Superfighters Deluxe maps. They use the shared
[Binary World Format](../Misc/Binary%20%World%20Format.md) container; this page covers the parts
specific to maps.

## Layout

A regular map is one world:

```
[h_gv] [h_or] [h_tmp] [h_el] [h_wn] [h_wa] [h_mtp] [h_tg] [h_wd] [h_wdt]
[h_pei] [h_mt] [h_pt] [h_img]
[c_wp] [c_scrpt] [c_lr] [c_lrp] [c_tl] [c_sobjs] [EOF]
```

Annotated start of a real map (`Test`, author `dsafxP`; `[]` marks a length prefix):

```
0x0000  [4]"h_gv"  | 16-byte GUID | [10]"v.1.5.14.0"
0x0020  [4]"h_or"  | 16-byte GUID | [27]"TLm82wPZgDypmbHs14Ve8BBbwOY"
0x0051  [5]"h_tmp" | 01                     template = true
0x0058  [4]"h_el"  | 00                     edit lock = false
0x005E  [4]"h_wn"  | [4]"Test"
0x0068  [4]"h_wa"  | [6]"dsafxP"
0x0074  [5]"h_mtp" | 02000000 00000000      Custom, 0 players
0x0082  [4]"h_tg"  | 00                     no tags
0x0088  [4]"h_wd"  | 00                     no description
0x008E  [5]"h_wdt" | ea07 0700 1900 1700 0700   2026-07-25 23:07
0x00A8  [5]"h_pei" | 00                     not published
0x00AF  [4]"h_mt"  | "SFDMAPEDIT"           10 raw bytes, no length prefix
0x00BE  [4]"h_pt"  | 01000000 | 00 01 00000000  one part: "", selectable, start=0
0x00CD  [4]"c_wp"  | 1d000000 ...           29 world properties
```

This particular file has no `h_img`, the thumbnail section is optional.

## `h_pt` (the parts table)

```c
int32 partCount
partCount × {
    string name
    byte   selectable
    int32  startPosition     // absolute file offset, first part always 0
}
```

- Regular maps carry one unnamed entry (`""`, start = 0).
- The game seeks to each `startPosition` and parses a **complete world** from there
  (`GameWorld.ReadFromStream`), including a full `h_*` header.
- Renaming a part changes the table size, which shifts every later part — all
  `startPosition` values must be rewritten accordingly or the game reads garbage.

## Campaigns are concatenated maps

A campaign `.sfdm` is simply N complete maps joined in one file:

- **Part 1 is the master**: only it carries `h_pt` (the chapter list) and `h_img`
  (the campaign thumbnail).
- **Parts 2..N** are full maps with their own headers, their own `c_wp`, and their
  own `c_scrpt` — but no `h_pt`/`h_img`.
- Shared metadata (name, author, publish ID, lock flags, version, official marker)
  is *mirrored into every part's header*. A part whose `h_mt` still holds the
  official token stays read-only in the editor even when the master part was
  unlocked; fan every edit across all parts.
- Each part also has its own independent script.

## `c_scrpt` — the embedded map script

The map's C# script is stored **Base64-encoded**:

```
[7]"c_scrpt" | length-prefixed string = Base64( UTF-8( C# source ) )
```

It is not compressed or encrypted, a plain
`Convert.FromBase64String` recovers the source. The game writes canonical Base64
(no line breaks). Empty maps still carry the section with an empty payload.

## `h_img` (thumbnail)

`int32 length` followed by a JPEG blob. Only the master part of a campaign has one.
The game validates the image dimensions before accepting it.

## Editing pitfalls

1. **Double bookkeeping**: `h_*` fields mirror `c_wp` properties (name, author,
   description, tags, category, players, template, edit lock, publish ID). Write
   both or lose the change on the next editor save.
2. **`h_mt` has no length prefix**: it is always exactly 10 raw characters.
3. **`h_pt` positions are absolute offsets**: any size-changing edit before a
   part's start must re-emit the table with shifted positions.
4. **Campaign mirrors**: metadata edits must fan out to every part.
