# Colors

Superfighters Deluxe does not tint its sprites. Every recolorable pixel in a tile or clothing texture is **painted with a marker color** at author time, and the game swaps those markers for the colors you pick at runtime. That one fact explains every oddity in the `.sfdx` color files.

Two separate databases load from two separate folders at startup:

| Database               | Folder                          | Files                                    | Contents              |
| ---------------------- | ------------------------------- | ---------------------------------------- | --------------------- |
| `ColorDatabase`        | `Content/Data/Colors/Colors/`   | `ItemColors.sfdx`, `TileColors.sfdx`     | 124 named color ramps |
| `ColorPaletteDatabase` | `Content/Data/Colors/Palettes/` | `ItemPalettes.sfdx`, `TilePalettes.sfdx` | 19 named palettes     |

Colors are the ramps. Palettes are the lists of ramps an object may use, split across three **levels**. This page covers colors. See [Color Palettes](Palettes.md) for palettes and [Color Reference](Color%20Reference.md) for the shipped values.

## The shading model

There are five shade slots. Their values are hardcoded in the engine:

```csharp
private static readonly int[] shades = new int[5] { 255, 192, 128, 64, 32 };
```

Each palette level owns one **primary channel**. A pixel is a marker for level _L_, shade _S_ if it equals the shade value in channel _L_ and is `0` in the other two channels.

Levels are zero-indexed in code (`GetColor1`, `SetColor1`, `GetFirstColorFromLevel(0)`) but one-indexed in the `.sfdx` palette files, which is where the names below come from:

| Level | Palette key | Script name              | Channel | Marker pixels (shade 1 to 5)                              |
| ----- | ----------- | ------------------------ | ------- | --------------------------------------------------------- |
| 0     | `colors1`   | `PrimaryColorPackages`   | Red     | `(255,0,0)` `(192,0,0)` `(128,0,0)` `(64,0,0)` `(32,0,0)` |
| 1     | `colors2`   | `SecondaryColorPackages` | Green   | `(0,255,0)` `(0,192,0)` `(0,128,0)` `(0,64,0)` `(0,32,0)` |
| 2     | `colors3`   | `TertiaryColorPackages`  | Blue    | `(0,0,255)` `(0,0,192)` `(0,0,128)` `(0,0,64)` `(0,0,32)` |

Recoloring is a straight pixel substitution. For every pixel matching marker (_L_, _S_), replace it with shade _S_ of the color selected for level _L_ (`Textures.RecolorTexture`). The marker's alpha channel is **not** compared.

### A real example

`Content/Data/Images/Tiles/Solid/Concrete/Concrete00A.png` is 8x8, or 64 pixels:

| Pixel       | Count | Meaning                   |
| ----------- | ----- | ------------------------- |
| `(192,0,0)` | 32    | level 0, shade 2          |
| `(255,0,0)` | 8     | level 0, shade 1          |
| `(128,0,0)` | 8     | level 0, shade 3          |
| `(0,0,0)`   | 16    | not a marker, stays black |

`Concrete00A` uses the `Concrete` palette, whose `colors1` starts with `StoneGray` (`(255,255,255) (200,200,200) (120,120,120)`). Shade 1 becomes white, shade 2 becomes `(200,200,200)`, shade 3 becomes `(120,120,120)`. The texture contains no gray at all. Every shade was authored as a marker.

### Rules for authoring markers

- **A ramp need not be contiguous.** `Normal.item` (layer 0) declares R shades 1 and 2 and
  G shades 1, 2 and 3, skipping R shade 3. Any subset of the five slots may be used, per
  level, independently.
- **A ramp need not reach shade 5.** The substitution loop is bounded by
  `Math.Min(colorLength, 5)`, so a 3-shade color only ever replaces shades 1 to 3.
- **Under-supplied shades leak through literally.** A shade 4 or 5 marker with no matching
  shade in the selected color is left as the raw marker color, rendering as pure
  `(64,0,0)` or `(0,32,0)`. This already happens: `BgRadar00A.png` has 737 pixels of
  `(0,32,0)` (level 1, shade 5), but every `colors2` entry of the `BG` palette has only 4
  shades. That radar glow always renders as literal dark green.
- **Alpha `0` means "do not draw".** This is how holes are punched without a second
  texture. `BgRadar00A.png` carries 1904 pixels of `(255,0,255,0)`. The magenta tint only
  makes the region visible while editing the PNG. Since red is non-zero it is not a
  level-2 marker, so it is never substituted.
- **Uncolored pixels are just pixels.** Black, white and any other ordinary color is left
  alone. Only exact marker matches are touched.

## Defining a color

```sfdx
color(ClothingLightRed) {
    c = (255,64,48),(224,48,32),(192,32,16);
}
```

A `color()` node takes one property:

| Property | Type              | Description                                      |
| -------- | ----------------- | ------------------------------------------------ |
| `c`      | list of `(r,g,b)` | The shade ramp, brightest first. 1 to 5 entries. |
| `key`    | string            | Optional. Overrides the name in parentheses.     |

### Parsing, exactly

`SFD.Parser/ColorDatabase.ConstructColor` is very literal:

1. The value is uppercased, then **all** `(` and `)` are removed by a blind string replace, then split on `,`.
2. The element count must be greater than 0 and divisible by 3, or the file is rejected.
3. Each consecutive triple is read with `byte.Parse` and stored as `new Color(r, g, b)`.
4. More than 5 shades throws: `Color 'X' defines too many colors. Max 5 is allowed.`
5. Names and values match case-insensitively. Everything is stored uppercased.

### Gotchas

All of these are real behaviours of the shipped files.

**Alpha is silently discarded, and it shifts your ramp.**
`Transparent` ships as:

```sfdx
color(Transparent){ c=(0,0,0,0),(0,0,0,0),(0,0,0,0); }
```

The four-element tuples still divide evenly into three, so the file parses. It produces **four** shades of `(0,0,0)` with `A = 255`, not three transparent colors. The `// default for r,g,b and a is 255` comment at the top of both color files is misleading: the format has no alpha channel, and `Transparent` is a misnomer for opaque black. Write three-element tuples. For real transparency, use an alpha-0 pixel in the texture.

### A color that looks like a marker gets silently edited

`Textures.NormalizeAwayFromShadeColor` rewrites any shade that equals one shade value in exactly one channel, bumping it by 1 (`255` becomes `254`, otherwise `+1`) so a color can never be mistaken for one of its own markers. Seven shipped colors are affected:

| Color             | Shade  | Written                                           | Loaded as                                         |
| ----------------- | ------ | ------------------------------------------------- | ------------------------------------------------- |
| `Red`             | 1 to 5 | `(255,0,0) (192,0,0) (128,0,0) (64,0,0) (32,0,0)` | `(254,0,0) (193,0,0) (129,0,0) (65,0,0) (33,0,0)` |
| `Green`           | 1 to 5 | `(0,255,0) (0,192,0) …`                           | `(0,254,0) (0,193,0) …`                           |
| `Blue`            | 1 to 5 | `(0,0,255) (0,0,192) …`                           | `(0,0,254) (0,0,193) …`                           |
| `NeonRed`         | 4, 5   | `(128,0,0) (64,0,0)`                              | `(129,0,0) (65,0,0)`                              |
| `NeonGreen`       | 4, 5   | `(0,128,0) (0,64,0)`                              | `(0,129,0) (0,65,0)`                              |
| `Wood1`           | 3      | `(128,0,0)`                                       | `(129,0,0)`                                       |
| `ClothingDarkRed` | 3      | `(64,0,0)`                                        | `(65,0,0)`                                        |

`Red`, `Green` and `Blue` are defined as literal marker ramps on purpose. Do not be surprised when your hex value does not survive a round trip.

**Parentheses are decorative.**
The parser strips them without checking balance. The missing `(` on the first tuple of `ClothingCyan` and `ClothingBrown` in `ItemColors.sfdx` is harmless; both parse correctly. Write `1,2,3` or `(1,2,3)` interchangeably.

**The trailing semicolon is not optional.**
Values end at the first `;`. Omitting it produces `Parse Error: Expected ';' at end of value for property 'c'`.

**A missing `c` yields white.**
`color(Foo) { }` is legal and registers a single white shade.

**Duplicate names overwrite, they do not fail.** A second `color()` with the same name logs `Error: Color 'X' already exist. Will be replaced with new values.` and wins. This depends on file enumeration order, which is not guaranteed. Duplicate _palettes_ are fatal, see [Color Palettes](Palettes.md).

## Where colors are stored

### Map objects

A tile's palette is chosen with `colorPalette` in its tile definition. The color selected for each of the three levels is stored per object in the map file as world property **343 `Object_Script_Colors`**, as three names joined by a pipe. `ClothingDarkRed||Skin3|` means level 0 is `ClothingDarkRed`, level 1 is empty, level 2 is `Skin3`. `ObjectData.SetColorsFrom` mirrors the same field into the live object. See [Binary World Format](../Misc/Binary%20World%20Format.md) for the property table.

### Clothing

Each of the 10 equipment layers independently stores three color names taken from that item's palette. Clothing uses the same marker and ramp system as tiles and calls the same `Textures.RecolorTexture`. See [Cosmetics Internals](../Cosmetics/Cosmetics%20Internals.md).

### Recolored texture cache

Generated textures are cached under a synthetic key `{textureKey}_1:{color1}_2:{color2}_3:{color3}`, uppercased. If all three names are empty the original texture is returned unrecolored. Worth knowing when writing texture-replacement mods.

## Scripting

There is no API to create a color or palette at runtime. The `.sfdx` files are the only source of truth, so everything below is read-only.

### Inspecting colors and palettes

```csharp
ColorPackage cp = Game.GetColorPackage("ClothingDarkRed");
cp.Shade1;   // Color
cp.Shade5;   // Color.Transparent if the color has fewer than 5 shades

ColorPalette pal = Game.GetColorPalette("Clothing1");
pal.PrimaryColorPackages;    // string[], the names in colors1
pal.SecondaryColorPackages;  // string[], the names in colors2
pal.TertiaryColorPackages;   // string[], the names in colors3

// Which palette does this clothing item draw from?
string name = Game.GetClothingItemColorPaletteName("Jacket");
```

`GetColorPackage` returns a `ColorPackage` with `Name` plus `Shade1` to `Shade5`. Shades the color does not define are left as `Color.Transparent`. `GetColorPalette` returns `null` for an unknown name, and empty arrays for levels the palette does not define.

### Recoloring an object

```csharp
string[] colors = myObject.GetColors();   // 3 entries, may contain ""
myObject.SetColor1("ClothingDarkRed");    // false if not in the object's palette
myObject.SetColor2("ClothingLightGray");
myObject.SetColor3("");
myObject.SetColors(new[] { "ClothingDarkRed", "ClothingLightGray", "" });
myObject.GetColorPaletteName();           // the tile's palette name, or "" if it has none
```

Every setter validates the name against **that object's own** palette (`ObjectData.ApplyColor` then `ColorPalette.ContainsColorPackageForLevel`) and returns `false` if the name is not a member. A name valid for one object in a selection can be rejected by another.

To pick a random color from a palette, index the package arrays yourself. The script API exposes no RNG, so bring your own:

```csharp
ColorPalette pal = Game.GetColorPalette("Clothing1");
if (pal.PrimaryColorPackages.Length > 0)
{
    string pick = pal.PrimaryColorPackages[Random.Shared.Next(pal.PrimaryColorPackages.Length)];
    myObject.SetColor1(pick);
}
```

Objects do **not** pick a random color when they spawn. A new object defaults to the first color of each level (`ColorPalette.GetFirstColorFromLevel`). Only clothing randomizes, via `GetRandomColorsFromLevels`, and only when a profile is randomized.
