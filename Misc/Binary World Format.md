# Binary World Format

The `.sfdm` (map) and `.sfde` (extension script) files share one binary container: a
sequential stream of length-prefixed section tokens. This page covers the parts both
formats have in common: primitives, the `h_*` headers and the body sections.
Format-specific parts live in [SFDM Format](../Mapmaking/SFDM%20Format.md) and
[SFDE Format](../Scripting/SFDE%20Format.md).

## Primitive encodings

Everything is little-endian, matching .NET `BinaryWriter`/`BinaryReader` defaults.

| Primitive             | Encoding                                                                         |
| --------------------- | -------------------------------------------------------------------------------- |
| String                | 7-bit encoded length prefix (LEB128, low bits first) + UTF-8 bytes               |
| Int32                 | 4 bytes, little-endian                                                           |
| Float32               | 4 bytes, little-endian IEEE 754                                                  |
| Bool                  | 1 byte (`00` = false, `01` = true)                                               |
| GUID                  | 16 raw bytes (`Guid.ToByteArray()` order)                                        |
| Null-delimited string | Raw UTF-8 bytes terminated by `00` (no length prefix), used only by `h_exscript` |

A section token is a **string** whose payload follows immediately. The header ends at the
first token that does **not** start with `h`, and body tokens start with `c_`. The game's
reader (`MapInfo.ReadMapHeader`) throws on any unknown `h_*` token.

## Header sections (`h_*`)

Listed in the order the game writes them.

| Token          | Payload               | Notes                                                          |
| -------------- | --------------------- | -------------------------------------------------------------- |
| `h_gv`         | GUID + string         | Save GUID + game version that wrote the file, e.g. `v.1.6.0.1` |
| `h_or`         | GUID + string         | Original GUID + owner hash (~27 chars, identifies the creator) |
| `h_tmp`        | bool                  | Template flag                                                  |
| `h_el`         | bool                  | Author edit-lock flag                                          |
| `h_wn`         | string                | World name                                                     |
| `h_wa`         | string                | Author name                                                    |
| `h_mtp`        | int32 + int32         | Map category, max players                                      |
| `h_tg`         | string                | Tag ids, comma separated, e.g. `3,5,6`                         |
| `h_wd`         | string                | Description                                                    |
| `h_wdt`        | 5 × int32             | Save date: year, month, day, hour, minute                      |
| `h_pei`        | string                | Workshop publish ID (empty when unpublished)                   |
| `h_mt`         | 10 chars, raw         | Official lock marker, see below                                |
| `h_ext`        | string                | Game modes list, `.sfde` only                                  |
| `h_exscript\n` | null-delimited string | C# source, `.sfde` only; the token itself ends with `\n`       |
| `h_pt`         | parts table           | See [SFDM Format](../Mapmaking/SFDM%20Format.md)               |
| `h_img`        | int32 + bytes         | Thumbnail (JPEG), length-prefixed blob                         |

### `h_mt` (the official lock marker)

The payload is **exactly 10 characters, written raw (no length prefix)**, because the
game reads it with `ReadChars(10)`. Since the characters often exceed U+007F, the byte
length varies between 10 and 30.

- Editable files store the plain ASCII text `SFDMAPEDIT` (10 bytes).
- Officially locked files store the token computed from `Name + Author`. A
  ready-to-use JavaScript implementation:

```js
function officialToken(author, name) {
  const header = name + author;

  let array = "0123456789".split("");
  const length = array.length;

  for (let i = 0; i < header.length; i++) {
    let index = i % length;

    let newCharCode = array[index].charCodeAt(0) + header.charCodeAt(index);
    array[index] = String.fromCharCode(newCharCode);
  }

  array[0] = "1";

  const bytes = new TextEncoder().encode(array.join(""));
  const token = Array.from(bytes)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("")
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

The gotcha: the round-robin indexes **both** the accumulator and the header with `i % 10`.
Only the first ten characters of the header are ever read, repeatedly, not a running sum
over the whole string.

Writing a length prefix here, a common mistake, shifts the whole stream and corrupts the
file.

## Body sections (`c_*`)

The save order of the current game version:

| Token     | Payload               | Notes                                                                                                               |
| --------- | --------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `c_wp`    | World property stream | See next section                                                                                                    |
| `c_scrpt` | string                | Base64(UTF-8(C# source)), maps only                                                                                 |
| `c_lr`    | Layer list            | int32 categoryCount; per category: string name, int32 layerCount; per layer: bool locked, bool visible, string name. See "Layers" below |
| `c_lrp`   | Layer properties      | Same category framing as `c_lr`; per layer: one world property stream. See "Layers" below                           |
| `c_tl`    | Custom ID table       | int32 count; per entry: string customId, int32 index. Rebuilt on save, see below                                     |
| `c_sobjs` | Object stream         | int32 count + serialized objects/tiles. See "Object stream" below                                                   |
| `EOF`     | —                     | `[3]"EOF"`, terminates the file                                                                                     |

The loader also accepts `c_fbgp` (a property stream) and `c_so` / `c_do` (object
streams). These are **legacy sections no longer written** by the current game.

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

| ID  | Name                            | Type   | Observed value                                        |
| --- | ------------------------------- | ------ | ----------------------------------------------------- |
| 2   | Map_Name                        | string | mirror of `h_wn`                                      |
| 3   | Map_Author                      | string | mirror of `h_wa`                                      |
| 8   | World_CameraArea                | string | `240,-320,-240,320`, which is `top,left,bottom,right` |
| 9   | World_Bottom                    | string | `-250`                                                |
| 12  | World_Weather                   | string | `None` \| `Snow` \| `Rain`                            |
| 61  | World_StartCommands             | string | semicolon separated chat commands                     |
| 103 | Map_MapType                     | int    | mirror of `h_mtp` category                            |
| 118 | World_WeaponSpawnChances        | string |                                                       |
| 208 | World_DeathSequenceEnabled      | bool   | `true`                                                |
| 209 | World_StartupSequenceEnabled    | bool   |                                                       |
| 258 | World_ActiveCameraArea          | int    |                                                       |
| 259 | MapPart_Name                    | string |                                                       |
| 260 | MapPart_Selectable              | bool   |                                                       |
| 262 | Map_TotalPlayers                | int    | mirror of `h_mtp` players                             |
| 294 | World_StartupIrisSwipeEnabled   | bool   |                                                       |
| 311 | Map_ThumbnailImage              | string |                                                       |
| 330 | Map_AutoFillWithBots            | bool   |                                                       |
| 331 | Map_IsTemplate                  | bool   | mirror of `h_tmp`                                     |
| 332 | Map_EditLock                    | bool   | mirror of `h_el`                                      |
| 333 | Map_PublishExternalID           | string | mirror of `h_pei`                                     |
| 334 | Map_Description                 | string | mirror of `h_wd`                                      |
| 337 | Map_Tags                        | string | mirror of `h_tg`                                      |
| 339 | Map_ScriptTypes                 | string | `Versus,Custom,Campaign,Survival`                     |
| 340 | Object_StickyFeet               | int    |                                                       |
| 341 | Object_BodyMass                 | float  | `-1.0`                                                |
| 342 | Object_CollisionFilter          | string | Base64 of two `int32`s, see below                     |
| 343 | Object_Script_Colors            | string | three color names joined by `\|`, see below           |
| 364 | World_CameraFixedIndividualZoom | float  | `-1.0`                                                |
| 372 | World_ShowDistanceMarkers       | bool   | `true`                                                |

**Editing hazard:** every `h_*` metadata field listed as a mirror above exists
_twice_. Updating only the header section is reverted the next time the editor saves
the file. Both locations must be written.

## Object colors (`Object_Script_Colors`, property 343)

This is where a map object stores the color selected for each of the three color levels.
The value is three color **names** joined by a pipe:

```
ClothingDarkRed||Skin3|
```

Here level 1 is `ClothingDarkRed`, and levels 2 and 3 are empty.

- Split on `|` into exactly three fields. Anything else is ignored and the object falls
  back to the first color of each level of its palette.
- An empty field means "do not recolor that level", so the texture keeps its raw marker
  pixels for that channel.
- Names keep the casing of the object's palette and are matched against it
  case-sensitively.

The palette is **not** stored per object. It comes from the tile definition's
`colorPalette` property, so changing that in an `.sfdx` file can leave unresolvable names
here, which the game silently drops. See [Colors](../Colors/Colors.md) and
[Color Palettes](../Colors/Palettes.md).

## Collision filter (`Object_CollisionFilter`, property 342)

The value is a Base64 string of eight bytes: two little-endian `int32`s.

| Word | High 16 bits | Low 16 bits |
| ---- | ------------ | ----------- |
| 1 | `CategoryBits` | `MaskBits` |
| 2 | `AboveBits` | flags |

The flags in the low 16 bits of word 2:

| Bit | Flag |
| --- | ---- |
| 0 | `ProjectileHit` |
| 1 | `BlockMelee` |
| 2 | `BlockExplosions` |
| 3 | `BlockFire` |
| 4 | `AbsorbProjectile` |

An empty string means no override, so the fixtures keep their tile defaults. A non-empty value replaces the filter of every fixture on the object, except players. See [Collision Bits](../Collisions/Collision%20Bits.md) for what the bits mean.

## Layers (`c_lr` / `c_lrp`)

`c_lr` declares the render layers, `c_lrp` carries one world property stream per
layer in the same category framing:

```
int32 categoryCount
categoryCount × {
    string categoryName     // e.g. "BG", "SLD", "OBJ", "FG", "MAR", "ITM", ...
    int32  layerCount
    layerCount × {
        // c_lr:
        bool   locked
        bool   visible
        string name
        // c_lrp: world property stream (same encoding as c_wp)
    }
}
```

Source: `GameWorld.ReadFromStream` / `WriteToStream` in `Superfighters Deluxe.dll`.
Reader notes:

- `categoryName` is parsed into `SFD.Category.TYPE` (`FBG = 0`, `BG = 2`, `LN = 3`,
  `SLD = 4`, `OBJ = 5`, `DEB = 6`, `PLR = 11`, `ITM = 19`, `THRN = 20`,
  `FG = 21`, `MAR = 25`, plus `UNUSED*` slots). Unknown names resolve to `-1`
  and their layers are **silently skipped** — the data is still consumed, just
  not applied.
- The writer always emits every category (`RenderCategories.Categories.Length`),
  so files disagreeing on category count are normal across game versions.

## Custom ID table (`c_tl`)

```
int32 count
count × {
    string customId
    int32  index     // 1-based, first-seen order
}
```

The writer **rebuilds** this table on every save from the objects' non-empty
`Object_CustomID` property values (`GameWorld.WriteToStream`): each distinct
string gets the next 1-based index in first-seen order. Editors must rewrite
the table (not patch it) whenever objects are added, removed, or renamed.

## Object stream (`c_sobjs`)

```
int32 objectCount
objectCount × { object }
```

One object is a sequence of tagged fields terminated by tag `9999`:

```
object := ( int32 tag + payload )* + int32(9999)
```

Tags (`SFD.ObjectData.ObjectDataValue` in `Superfighters Deluxe.dll`):

| Tag  | Name             | Payload encoding                              | Notes                                                        |
| ---- | ---------------- | --------------------------------------------- | ------------------------------------------------------------ |
| 0    | `MapObjectID`    | string (tile key, e.g. `Concrete00A`)         | First field on save                                          |
| 1    | `CustomID`       | int32 (index into `c_tl`)                     | `0` = none                                                   |
| 10   | `GroupID`        | uint16                                        | Note the width: 2 bytes, not 4                               |
| 2    | `WorldPosition`  | 2 × float32 (`x`, `y`, world units = pixels)  |                                                              |
| 3    | `Angle`          | float32 (radians)                             |                                                              |
| 4    | `LocalRenderLayer` | int32                                       | Layer index within the object's draw category                |
| 5    | `FaceDirection`  | int32 (`1` / `-1`)                            |                                                              |
| 6    | `Colors`         | int32 count + count × string                  | 3 color names on save; padded with `""` to 3 on load          |
| 7    | `Properties`     | world property stream (same encoding as `c_wp`) | Per-object properties (size, mass, overrides, …)           |
| 8    | `LinearVelocity` | 2 × float32                                   | **Load-only**, never written by the current game             |
| 9    | `AngularVelocity` | float32                                      | **Load-only**, never written by the current game             |
| 9999 | `END`            | —                                             | Terminates one object                                        |

The writer (`SFD.ObjectData.Save`) emits tags in the fixed order
`0, 1, 10, 2, 3, 4, 5, 6, 7, 9999`, but the loader reads tag-driven until
`9999`, so order-independent parsing is safe.

Loader notes (`SFD.ObjectData.Load`):

- Unknown `MapObjectID` tile keys fall back to the tile `"error"` — the object
  still loads. Editors can rely on this for forward compatibility, not for
  shipping maps.
- A `Colors` array that is not exactly 3 entries is padded with `""` up to 3.
  `""` means "do not recolor that level" (see `Object_Script_Colors`, property
  343, above — tag 6 and property 343 carry the same three level colors in
  different forms).
- Duplicate tags: the first occurrence wins.
- A truncated stream sets the corrupt-file flag (`EditMapFileIsCorrupt`) instead
  of throwing; the editor still opens the file.

Per-object properties (tag 7) use the same `int32 id / int32 type / value`
encoding as `c_wp`. Which IDs an object carries depends on its tile — e.g.
sizeable tiles add `Size_X` (19) / `Size_Y` (20) — plus universal entries such
as `Object_CustomID`, `Object_BodyType`, `Object_BodyMass`, `Object_StickyFeet`,
`Object_CollisionFilter` (342) and `Object_Script_Colors` (343).

Verification: a tag-driven parser built from this spec reads every object of
all 31 shipped versus maps (47,454 objects, e.g. 1392 in `Alley.sfdm`) and
lands exactly on the trailing `[3]"EOF"` with no unknown tags.

## Reference values

### Map categories (`h_mtp` first int32 / property 103)

| Value | Category                   |
| ----- | -------------------------- |
| 0     | Versus (legacy, same as 1) |
| 1     | Versus                     |
| 2     | Custom                     |
| 3     | Campaign                   |
| 4     | Survival                   |
| 5     | Challenge                  |

### Tags (`h_tg` / property 337)

Stored as comma separated ids, e.g. `3,5,6`.

| ID  | Tag                       |
| --- | ------------------------- |
| 1   | Adventure Map             |
| 2   | Melee Map                 |
| 3   | Bot Support               |
| 4   | Singleplayer              |
| 5   | Multiplayer               |
| 6   | Optimized For 16 Players  |
| 7   | Customized Gameplay/Rules |

### Game modes (property 339, mirrored in `h_ext` on scripts)

Comma separated: `Versus`, `Custom`, `Campaign`, `Survival`.
