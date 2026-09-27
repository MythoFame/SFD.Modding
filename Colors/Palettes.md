# Color Palettes

A **color** (see [Colors](Colors.md)) is a named shade ramp. A **color palette** is a named
list of colors, split across three levels, that an object may draw from. A palette makes a
tile colorable and constrains the player to sensible choices, since the map editor only
offers colors from the selected object's palette.

Palettes live in `Content/Data/Colors/Palettes/`:

| File | Palettes | Used by |
| ---- | -------- | ------- |
| `TilePalettes.sfdx` | 15 | map objects, weapons |
| `ItemPalettes.sfdx` | 4 | clothing and cosmetics |

## Defining a palette

```sfdx
colorPalette(ClothingGoggles1) {
    colors1 = ClothingDarkGray,ClothingDarkPink,ClothingDarkRed,ClothingDarkOrange;
    colors2 = ClothingLightGray,ClothingLightPink,ClothingLightRed,ClothingLightOrange;
}
```

| Property | Type | Script name | Description |
| -------- | ---- | ----------- | ----------- |
| `colors1` | list of color names | `PrimaryColorPackages` | Level 0, recolors red markers |
| `colors2` | list of color names | `SecondaryColorPackages` | Level 1, recolors green markers |
| `colors3` | list of color names | `TertiaryColorPackages` | Level 2, recolors blue markers |

Each level is an independent list. Order matters only for the default: the **first** entry
is what a freshly spawned object gets. An omitted or empty level has no members, and
`GetFirstColorFromLevel` returns `""` for it, meaning "draw the texture uncolored".

The marker colors each level drives are described in [Colors](Colors.md#the-shading-model).

## Attaching a palette

### Map objects

A tile declares its palette with the `colorPalette` property:

```sfdx
tile(Concrete00A) { material = concrete; colorPalette = Concrete; }
```

The lookup is case-insensitive, so `colorPalette=palNone`, `colorPalette=Stone` and
`colorPalette=metal` are all fine. The internal default for a tile structure is
`PALNONE`, but the string that actually disables recoloring is `none`:

- `none`: the tile has no palette at all. `SFD.Tiles/Tile.cs:383` skips palette loading and
  the tile is never recolored.
- Any other unresolvable name is **fatal**, including a literal `PALNONE`. Loading aborts on
  `Error: Could not find color palette 'X'` while the tile is being constructed.

Per-object color selection is stored in map property 343 `Object_Script_Colors` as
`color1|color2|color3`. See [Binary World Format](../Misc/Binary%20World%20Format.md).

### Clothing

Each `.item` binary carries a `colorPalette` string naming the palette it draws from,
alongside its other metadata. See [Cosmetics Internals](../Cosmetics/Cosmetics%20Internals.md).

## Behaviour and gotchas

**Each tile trims its own copy of the palette.**
This is the most surprising behaviour in the system. When a tile finishes loading,
`Tile.CalculateUsableColors` (`SFD.Tiles/Tile.cs:183`) works out which of the fifteen
(level, shade) slots its texture paints, then calls `ColorPalette.AdjustColorFields` on a
**copy** of the shared palette to drop every color that would not touch a single pixel. The
`BG` palette offers 41 colors on level 0, yet a given background tile may keep only the
handful matching its marker slots.

Consequences:

- `Game.GetColorPalette(name)` returns the **untrimmed** definition, so it can list colors
  that `SetColor1` still rejects for a given object.
- `obj.GetColorPaletteName()` gives the tile's palette name, but the trimmed set is per-tile
  and never exposed to scripts. Expect some "valid" entries to fail on specific objects.
- This is why the map editor's colour dialog lists fewer colors than the palette file
  suggests, and why two tiles sharing `colorPalette=Concrete` can offer different sets.

**Duplicate palette names are fatal; duplicate colors are not.**
A second `colorPalette()` with an existing name throws `Error: Color 'X' already exist` and
stops loading. The same situation for `color()` only logs an error and overwrites. Rename
anything you copy into a new file, or you will hard-fail.

**The leading comment in the shipped palette files is stale.**
Both files open with:

```sfdx
// inserting unique colors into a palette (r,g,b) or (r,g,b,a) instead of color-id only
```

Raw tuples are **not** supported. `ColorPaletteDatabase.ConstructColorPalette` only splits
the value on `,` and stores the resulting strings verbatim; a later `ColorDatabase.GetColor`
lookup uppercases the string and finds nothing, so the entry resolves to `null` and is
skipped without any warning. Only color names go in a palette.

**Unresolvable names fail silently.** As above, a typo in a palette entry produces a color
that never renders. Check your palette references by hand.

**Membership is case-sensitive, lookup is not.**
`ContainsColorPackageForLevel` is a plain `List<string>.Contains`, so an entry written as
`StoneGray` will not match a request for `stonegray`. Entries are stored exactly as written,
so take names from `GetColorPalette(...)` instead of hardcoding them.

**The editor shows the union of the selection, then applies per object.**
`SFDMapEditor` builds one palette with `ColorPalette.CombineFrom` (a union) across all
selected objects and hands that to `SFDColorDialog`, so the dialog lists every color any
selected object could take. But `GameWorld.EditSetSelectedColor` re-checks
`CanSetColor` per object, so picking a color present in one object's palette silently does
nothing to the others. Multi-select a mixed set and expect partial application.

**`palNone` is not the same as `none`.**
`colorPalette(palNone) { colors1 = White; }` is a real palette that resolves, and a tile
using it gets `["White", "", ""]`. Since `White` is non-empty the texture still runs through
the recolor pipeline, but it has no markers, so the result matches the original.
`colorPalette=none` bypasses the pipeline entirely.

**`Solid` is a deliberate hack.**
`Solid` lists the same seven colors in all three levels, so whichever level an object's
markers use, the picker offers the identical set. It is how the engine gives a generic
seven-color choice to arbitrary textures without caring which channel they were authored
in.

## How palettes compose

Two operations on the palette type are not used for authoring but explain editor
behaviour, and are occasionally useful when reasoning about multi-select:

- `Union` / `CombineFrom`: appends the other palette's entries per level, skipping
  duplicates. This is how the multi-select colour dialog is built.
- `Intersect`: keeps only entries present in both, per level.

A palette's levels are usually far wider than the textures using them need. Of the 65
background textures that paint green markers, 45 use only shade 1 and 58 use at most shades 1
to 2, yet `BG.colors2` offers five `Light*` colors with four shades each. Offering a color
whose shades a texture never references is harmless: it produces no visible change, and
per-tile trimming drops it anyway.

## Scripting

```csharp
ColorPalette pal = Game.GetColorPalette("Clothing1");   // null if unknown
if (pal != null)
{
    string[] l1 = pal.PrimaryColorPackages;
    string[] l2 = pal.SecondaryColorPackages;
    string[] l3 = pal.TertiaryColorPackages;            // empty if colors3 is unset
}
```

To test whether a color is valid before setting it, compare against the object's palette
rather than relying on the setter's return value alone:

```csharp
IObject obj = ...;
ColorPalette pal = Game.GetColorPalette(obj.GetColorPaletteName());
if (pal != null && Array.IndexOf(pal.PrimaryColorPackages, "ClothingRed") >= 0)
{
    obj.SetColor1("ClothingRed");
}
```

`Game.GetClothingItemColorPaletteName(itemName)` resolves the palette for a clothing item
by name, which is the cleanest way to check a cosmetic before scripting an outfit.
