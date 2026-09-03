# Binary World Format

The `.sfdm` (map) and `.sfde` (extension script) files share one binary container: a
sequential stream of length-prefixed section tokens. This page documents the parts
both formats have in common: primitives, the `h_*` header sections, and the body
sections. Format-specific parts live in [SFDM Format](../Mapmaking/SFDM%20Format.md)
and [SFDE Format](../Scripting/SFDE%20Format.md).

## Primitive encodings

Everything is little-endian, matching .NET `BinaryWriter`/`BinaryReader` defaults.

| Primitive | Encoding |
| --------- | -------- |
| String | 7-bit encoded length prefix (LEB128, low bits first) + UTF-8 bytes |
| Int32 | 4 bytes, little-endian |
| Float32 | 4 bytes, little-endian IEEE 754 |
| Bool | 1 byte (`00` = false, `01` = true) |
| GUID | 16 raw bytes (`Guid.ToByteArray()` order) |
| Null-delimited string | Raw UTF-8 bytes terminated by `00` (no length prefix) — used only by `h_exscript` |

A section token is a **string** whose payload follows immediately. The header ends at
the first token that does **not** start with `h`; body tokens start with `c_`. The
game's reader (`MapInfo.ReadMapHeader`) throws on any unknown `h_*` token.

## Header sections (`h_*`)

Listed in the order the game writes them.

| Token | Payload | Notes |
| ----- | ------- | ----- |
| `h_gv` | GUID + string | Save GUID + game version that wrote the file, e.g. `v.1.6.0.1` |
| `h_or` | GUID + string | Original GUID + owner hash (~27 chars, identifies the creator) |
| `h_tmp` | bool | Template flag |
| `h_el` | bool | Author edit-lock flag |
| `h_wn` | string | World name |
| `h_wa` | string | Author name |
| `h_mtp` | int32 + int32 | Map category, max players |
| `h_tg` | string | Tag ids, comma separated, e.g. `3,5,6` |
| `h_wd` | string | Description |
| `h_wdt` | 5 × int32 | Save date: year, month, day, hour, minute |
| `h_pei` | string | Workshop publish ID (empty when unpublished) |
| `h_mt` | 10 chars, raw | Official lock marker — see below |
| `h_ext` | string | Game modes list — `.sfde` only |
| `h_exscript\n` | null-delimited string | C# source — `.sfde` only; the token itself ends with `\n` |
| `h_pt` | parts table | See [SFDM Format](../Mapmaking/SFDM%20Format.md) |
| `h_img` | int32 + bytes | Thumbnail (JPEG), length-prefixed blob |

### `h_mt` (the official lock marker)

The payload is **exactly 10 characters, written raw (no length prefix)** — the game
reads it with `ReadChars(10)`. Since the characters often exceed U+007F, the byte
length varies between 10 and 30.

- Editable files store the plain ASCII text `SFDMAPEDIT` (10 bytes).
- Officially locked files store the token computed from `Name + Author` — a
  ready-to-use JavaScript implementation:

```js
function officialToken(author, name) {
  const header = name + author;

  let array = "0123456789".split('');
  const length = array.length;

  for (let i = 0; i < header.length; i++) {
      let index = i % length;

      let newCharCode = array[index].charCodeAt(0) + header.charCodeAt(index);
      array[index] = String.fromCharCode(newCharCode);
  }

  array[0] = '1';

  const bytes = new TextEncoder().encode(array.join(''));
  const token = Array.from(bytes)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .toUpperCase();

  return token;
}

console.log(officialToken("MythoFame", "Bogus"));
```

The token algorithm (mirrors the game's `MapInfo.CalcOfficialMap`):

```c
header = Name + Author
array  = "0123456789"
for i = 0 .. header.length-1:
    array[i % 10] += header[i % 10]   // char addition, round-robin
array[0] = '1'
// the 10 chars, UTF-8 encoded, are the h_mt payload
```

The gotcha: the round-robin indexes **both** the accumulator and the header with
`i % 10`; only the first ten characters of the header are ever read (repeatedly),
not a running sum over the whole string.

Writing a length prefix here (a common mistake) shifts the whole stream and corrupts
the file.

## Body sections (`c_*`)

The save order of the current game version:

| Token | Payload | Notes |
| ----- | ------- | ----- |
| `c_wp` | World property stream | See next section |
| `c_scrpt` | string | Base64(UTF-8(C# source)) — maps only |
| `c_lr` | Layer list | int32 categoryCount; per category: string name, int32 layerCount; per layer: bool locked, bool visible, string name |
| `c_lrp` | Layer properties | int32 categoryCount; per category: string name, int32 layerCount; per layer: one world property stream |
| `c_tl` | Custom ID table | int32 count; per entry: string customId, int32 index |
| `c_sobjs` | Object stream | int32 count + serialized objects/tiles |
| `EOF` | — | `[3]"EOF"`, terminates the file |

The loader also accepts `c_fbgp` (a property stream) and `c_so` / `c_do` (object
streams) — these are **legacy sections no longer written** by the current game.

## World properties (`c_wp`)

A flat list of typed key/value pairs, mirrored across every part of the file:

```
int32 count
count × {
    int32 propertyId
    int32 type      // 0 = string, 1 = float32, 2 = int32, 3 = bool
    value           // string: length-prefixed; others: fixed width
}
```

| ID | Name | Type | Observed value |
| -- | ---- | ---- | -------------- |
| 2 | Map_Name | string | mirror of `h_wn` |
| 3 | Map_Author | string | mirror of `h_wa` |
| 8 | World_CameraArea | string | `240,-320,-240,320` — `top,left,bottom,right` |
| 9 | World_Bottom | string | `-250` |
| 12 | World_Weather | string | `None` \| `Snow` \| `Rain` |
| 61 | World_StartCommands | string | semicolon separated chat commands |
| 103 | Map_MapType | int | mirror of `h_mtp` category |
| 118 | World_WeaponSpawnChances | string | |
| 208 | World_DeathSequenceEnabled | bool | `true` |
| 209 | World_StartupSequenceEnabled | bool | |
| 258 | World_ActiveCameraArea | int | |
| 259 | MapPart_Name | string | |
| 260 | MapPart_Selectable | bool | |
| 262 | Map_TotalPlayers | int | mirror of `h_mtp` players |
| 294 | World_StartupIrisSwipeEnabled | bool | |
| 311 | Map_ThumbnailImage | string | |
| 330 | Map_AutoFillWithBots | bool | |
| 331 | Map_IsTemplate | bool | mirror of `h_tmp` |
| 332 | Map_EditLock | bool | mirror of `h_el` |
| 333 | Map_PublishExternalID | string | mirror of `h_pei` |
| 334 | Map_Description | string | mirror of `h_wd` |
| 337 | Map_Tags | string | mirror of `h_tg` |
| 339 | Map_ScriptTypes | string | `Versus,Custom,Campaign,Survival` |
| 340 | Object_StickyFeet | int | |
| 341 | Object_BodyMass | float | `-1.0` |
| 342 | Object_CollisionFilter | string | |
| 343 | Object_Script_Colors | string | |
| 364 | World_CameraFixedIndividualZoom | float | `-1.0` |
| 372 | World_ShowDistanceMarkers | bool | `true` |

**Editing hazard:** every `h_*` metadata field listed as a mirror above exists
*twice*. Updating only the header section is reverted the next time the editor saves
the file — both locations must be written.

## Reference values

### Map categories (`h_mtp` first int32 / property 103)

| Value | Category |
| ----- | -------- |
| 0 | Versus (legacy, same as 1) |
| 1 | Versus |
| 2 | Custom |
| 3 | Campaign |
| 4 | Survival |
| 5 | Challenge |

### Tags (`h_tg` / property 337)

Stored as comma separated ids, e.g. `3,5,6`.

| ID | Tag |
| -- | --- |
| 1 | Adventure Map |
| 2 | Melee Map |
| 3 | Bot Support |
| 4 | Singleplayer |
| 5 | Multiplayer |
| 6 | Optimized For 16 Players |
| 7 | Customized Gameplay/Rules |

### Game modes (property 339, mirrored in `h_ext` on scripts)

Comma separated: `Versus`, `Custom`, `Campaign`, `Survival`.
