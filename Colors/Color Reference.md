# Color Reference

SFD colors work using a list of colors combined with a palette system:

- [Colors](Colors.md): holds individual colors.
- [Palettes](Palettes.md): groups of several colors.

Colors are stored in:

- `Content/Data/Colors/Colors/ItemColors.sfdx`
- `Content/Data/Colors/Colors/TileColors.sfdx`
- `Content/Data/Colors/Palettes/ItemPalettes.sfdx`
- `Content/Data/Colors/Palettes/TilePalettes.sfdx`

## Summary

Below a list of all colors available in the game (since v1.3.7).

| Type     | Count                  |
| -------- | ---------------------- |
| Colors   | 124 (87 tile, 37 item) |
| Palettes | 19 (15 tile, 4 item)   |

> **Adjusted** marks colors that `Textures.NormalizeAwayFromShadeColor` silently rewrites at load time because a shade collides with a marker value. The table shows the _written_ values.

## Colors

### Tile colors (`TileColors.sfdx`)

| Name             | Shades | Ramp                                                                      | Adjusted | Used by                                                                                       |
| ---------------- | ------ | ------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------- |
| `White`          | 3      | `(255,255,255)` `(255,255,255)` `(255,255,255)`                           |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Metal`, `Moon`, `Sky`, `Stone`, `Tile`, `Wood`, `palNone` |
| `Black`          | 3      | `(0,0,0)` `(0,0,0)` `(0,0,0)`                                             |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Metal`, `Moon`, `Sky`, `Stone`, `Tile`, `Wood`            |
| `Transparent`    | 4      | `(0,0,0)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                   |          | `Concrete`, `Dirt`, `Metal`, `Stone`, `Tile`, `Wood`                                          |
| `StoneGray`      | 3      | `(255,255,255)` `(200,200,200)` `(120,120,120)`                           |          | `Concrete`, `Stone`                                                                           |
| `StoneYellow`    | 3      | `(255,255,255)` `(255,208,128)` `(208,128,0)`                             |          | `Concrete`, `Stone`                                                                           |
| `StoneRed`       | 3      | `(255,192,128)` `(255,120,80)` `(208,48,32)`                              |          | `Concrete`, `Stone`                                                                           |
| `StoneBlue`      | 3      | `(224,224,255)` `(160,160,255)` `(96,96,192)`                             |          | —                                                                                             |
| `StoneCyan`      | 3      | `(40,128,128)` `(24,64,96)` `(24,64,64)`                                  |          | —                                                                                             |
| `Wood0`          | 3      | `(224,211,181)` `(224,172,116)` `(96,64,56)`                              |          | `Wood`                                                                                        |
| `Wood1`          | 3      | `(255,211,181)` `(255,172,116)` `(128,0,0)`                               | 🟢       | `Wood`                                                                                        |
| `MetalGray`      | 5      | `(255,255,255)` `(192,192,192)` `(128,128,128)` `(64,64,64)` `(32,32,32)` |          | `Metal`                                                                                       |
| `MetalRed`       | 3      | `(255,160,160)` `(255,64,64)` `(192,24,24)`                               |          | `Metal`                                                                                       |
| `MetalPink`      | 3      | `(255,224,192)` `(255,128,104)` `(192,64,48)`                             |          | `Metal`                                                                                       |
| `MetalBlue`      | 3      | `(255,255,255)` `(180,180,255)` `(128,128,255)`                           |          | `Metal`                                                                                       |
| `MetalCyan`      | 3      | `(0,255,255)` `(0,128,128)` `(0,64,64)`                                   |          | `Metal`                                                                                       |
| `MetalYellow`    | 3      | `(255,255,192)` `(255,192,0)` `(240,160,0)`                               |          | `Metal`                                                                                       |
| `NeonBlue`       | 5      | `(192,224,255)` `(96,128,255)` `(0,64,192)` `(0,32,128)` `(0,16,64)`      |          | `Neon`                                                                                        |
| `NeonCyan`       | 5      | `(192,255,255)` `(0,208,208)` `(0,192,192)` `(0,128,128)` `(0,64,64)`     |          | `Neon`                                                                                        |
| `NeonGreen`      | 5      | `(224,255,224)` `(64,255,0)` `(32,192,0)` `(0,128,0)` `(0,64,0)`          | 🟢       | `Neon`                                                                                        |
| `NeonPink`       | 5      | `(255,224,255)` `(255,0,224)` `(192,0,160)` `(128,0,96)` `(64,0,48)`      |          | `Neon`                                                                                        |
| `NeonRed`        | 5      | `(255,224,224)` `(255,64,0)` `(192,32,0)` `(128,0,0)` `(64,0,0)`          | 🟢       | `Neon`                                                                                        |
| `NeonYellow`     | 5      | `(255,255,224)` `(255,224,0)` `(192,160,0)` `(128,96,0)` `(64,48,0)`      |          | `Neon`                                                                                        |
| `DirtYellow`     | 3      | `(255,224,128)` `(192,192,0)` `(128,96,0)`                                |          | `Dirt`                                                                                        |
| `DirtBrown`      | 3      | `(255,192,0)` `(192,128,0)` `(96,48,0)`                                   |          | `Dirt`                                                                                        |
| `DirtBlue`       | 3      | `(96,160,255)` `(40,104,136)` `(16,48,64)`                                |          | `Dirt`                                                                                        |
| `TileGray`       | 5      | `(192,192,204)` `(128,128,138)` `(64,64,96)` `(40,40,48)` `(24,24,32)`    |          | `Tile`                                                                                        |
| `TileOrange`     | 5      | `(255,198,136)` `(255,128,0)` `(128,64,0)` `(64,32,0)` `(32,16,0)`        |          | `Tile`                                                                                        |
| `TileCyan`       | 5      | `(128,255,255)` `(0,192,192)` `(0,128,128)` `(0,64,64)` `(0,32,32)`       |          | `Tile`                                                                                        |
| `Gray`           | 5      | `(192,192,192)` `(128,128,128)` `(64,64,64)` `(32,32,32)` `(16,16,16)`    |          | `Cloth`, `Solid`                                                                              |
| `Red`            | 5      | `(255,0,0)` `(192,0,0)` `(128,0,0)` `(64,0,0)` `(32,0,0)`                 | 🟢       | `Cloth`, `Solid`                                                                              |
| `Green`          | 5      | `(0,255,0)` `(0,192,0)` `(0,128,0)` `(0,64,0)` `(0,32,0)`                 | 🟢       | `Solid`                                                                                       |
| `Blue`           | 5      | `(0,0,255)` `(0,0,192)` `(0,0,128)` `(0,0,64)` `(0,0,32)`                 | 🟢       | `Cloth`, `Solid`                                                                              |
| `Yellow`         | 5      | `(255,255,0)` `(192,192,0)` `(128,128,0)` `(64,64,0)` `(32,32,0)`         |          | `Cloth`, `Solid`                                                                              |
| `Cyan`           | 5      | `(0,255,255)` `(0,128,128)` `(32,96,96)` `(0,64,64)` `(0,32,32)`          |          | `Cloth`, `Solid`                                                                              |
| `Magenta`        | 5      | `(255,0,255)` `(192,0,192)` `(128,0,128)` `(64,0,64)` `(32,0,32)`         |          | `Cloth`, `Solid`                                                                              |
| `Brown`          | 3      | `(200,146,78)` `(216,136,29)` `(162,102,21)`                              |          | `Cloth`                                                                                       |
| `BgLightGray`    | 4      | `(192,192,200)` `(128,128,136)` `(64,64,64)` `(16,16,16)`                 |          | `BG`                                                                                          |
| `BgLightRed`     | 4      | `(255,72,0)` `(192,48,0)` `(160,32,0)` `(96,12,0)`                        |          | `BG`, `Moon`                                                                                  |
| `BgLightPink`    | 4      | `(255,104,104)` `(255,64,64)` `(192,24,24)` `(128,12,12)`                 |          | `BG`                                                                                          |
| `BgLightGreen`   | 4      | `(0,176,16)` `(0,128,12)` `(0,96,8)` `(0,64,2)`                           |          | `BG`                                                                                          |
| `BgLightBlue`    | 4      | `(64,64,255)` `(48,48,255)` `(32,32,192)` `(16,16,128)`                   |          | `BG`, `Moon`                                                                                  |
| `BgLightYellow`  | 4      | `(255,216,32)` `(208,160,16)` `(208,140,8)` `(160,96,4)`                  |          | `BG`, `Moon`                                                                                  |
| `BgLightOrange`  | 4      | `(255,192,40)` `(255,128,24)` `(160,64,16)` `(96,32,8)`                   |          | `BG`                                                                                          |
| `BgLightBrown`   | 4      | `(136,128,80)` `(104,96,32)` `(64,56,16)` `(48,40,8)`                     |          | `BG`                                                                                          |
| `BgLightCyan`    | 4      | `(24,144,160)` `(16,104,104)` `(12,64,64)` `(6,32,32)`                    |          | `BG`                                                                                          |
| `BgLightMagenta` | 4      | `(224,64,224)` `(192,32,192)` `(128,16,112)` `(80,8,72)`                  |          | `BG`                                                                                          |
| `BgGray`         | 4      | `(96,96,104)` `(64,64,72)` `(32,32,32)` `(0,0,0)`                         |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgRed`          | 4      | `(200,32,0)` `(146,24,0)` `(104,12,0)` `(0,0,0)`                          |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgPink`         | 4      | `(255,64,64)` `(204,32,32)` `(136,16,16)` `(0,0,0)`                       |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgGreen`        | 4      | `(0,112,12)` `(0,80,8)` `(0,48,4)` `(0,0,0)`                              |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgBlue`         | 4      | `(56,56,192)` `(40,40,128)` `(24,24,80)` `(0,0,0)`                        |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgYellow`       | 4      | `(180,176,16)` `(160,136,8)` `(144,104,4)` `(0,0,0)`                      |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgOrange`       | 4      | `(208,136,0)` `(192,96,0)` `(136,56,0)` `(0,0,0)`                         |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgBrown`        | 4      | `(96,88,48)` `(64,56,16)` `(32,24,8)` `(0,0,0)`                           |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgCyan`         | 4      | `(16,104,104)` `(12,64,64)` `(8,32,32)` `(0,0,0)`                         |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgMagenta`      | 4      | `(160,32,160)` `(128,16,128)` `(96,8,80)` `(0,0,0)`                       |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkGray`     | 4      | `(64,64,72)` `(32,32,32)` `(16,16,16)` `(0,0,0)`                          |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkRed`      | 4      | `(136,24,0)` `(104,16,0)` `(72,8,0)` `(0,0,0)`                            |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkPink`     | 4      | `(160,24,24)` `(128,12,12)` `(80,4,4)` `(0,0,0)`                          |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkGreen`    | 4      | `(0,80,8)` `(0,48,4)` `(0,24,0)` `(0,0,0)`                                |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkBlue`     | 4      | `(32,32,104)` `(24,24,72)` `(16,16,56)` `(0,0,0)`                         |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkYellow`   | 4      | `(104,96,8)` `(96,64,4)` `(64,32,2)` `(0,0,0)`                            |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkOrange`   | 4      | `(160,80,0)` `(144,48,0)` `(80,24,0)` `(0,0,0)`                           |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkBrown`    | 4      | `(64,56,16)` `(32,28,8)` `(16,12,4)` `(0,0,0)`                            |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkCyan`     | 4      | `(16,64,64)` `(8,32,32)` `(4,16,16)` `(0,0,0)`                            |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgDarkMagenta`  | 4      | `(96,0,96)` `(64,0,64)` `(32,0,32)` `(0,0,0)`                             |          | `BG`, `FarBG`, `Sky`                                                                          |
| `BgBlackGray`    | 4      | `(16,16,16)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                |          | `BG`                                                                                          |
| `BgBlackRed`     | 4      | `(72,8,0)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                  |          | `BG`                                                                                          |
| `BgBlackPink`    | 4      | `(80,4,4)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                  |          | `BG`                                                                                          |
| `BgBlackGreen`   | 4      | `(0,24,0)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                  |          | `BG`                                                                                          |
| `BgBlackBlue`    | 4      | `(16,16,56)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                |          | `BG`                                                                                          |
| `BgBlackYellow`  | 4      | `(64,32,0)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                 |          | `BG`                                                                                          |
| `BgBlackOrange`  | 4      | `(80,24,0)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                 |          | `BG`                                                                                          |
| `BgBlackBrown`   | 4      | `(16,12,4)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                 |          | `BG`                                                                                          |
| `BgBlackCyan`    | 4      | `(4,16,16)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                 |          | `BG`                                                                                          |
| `BgBlackMagenta` | 4      | `(32,0,32)` `(0,0,0)` `(0,0,0)` `(0,0,0)`                                 |          | `BG`                                                                                          |
| `LightYellow`    | 4      | `(255,216,32)` `(208,160,16)` `(208,140,8)` `(192,128,4)`                 |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Lamp`, `Metal`, `Sky`, `Stone`, `Tile`, `Wood`            |
| `LightOrange`    | 4      | `(255,192,0)` `(255,160,0)` `(255,136,0)` `(192,104,0)`                   |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Lamp`, `Metal`, `Sky`, `Stone`, `Tile`, `Wood`            |
| `LightRed`       | 4      | `(255,64,16)` `(255,16,0)` `(224,8,0)` `(128,4,0)`                        |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Metal`, `Sky`, `Stone`, `Tile`, `Wood`                    |
| `LightBlue`      | 4      | `(144,144,255)` `(120,120,224)` `(96,96,192)` `(56,52,128)`               |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Lamp`, `Metal`, `Sky`, `Stone`, `Tile`, `Wood`            |
| `LightGreen`     | 4      | `(192,255,128)` `(140,255,128)` `(128,224,96)` `(104,192,80)`             |          | `BG`, `Concrete`, `Dirt`, `FarBG`, `Lamp`, `Metal`, `Sky`, `Stone`, `Tile`, `Wood`            |
| `bgTest1`        | 2      | `(192,192,72)` `(144,128,192)`                                            |          | —                                                                                             |
| `bgTest2`        | 2      | `(96,128,146)` `(96,104,192)`                                             |          | —                                                                                             |
| `bgTest3`        | 2      | `(240,160,64)` `(216,128,204)`                                            |          | —                                                                                             |
| `SkyDarkRed`     | 3      | `(48,8,0)` `(40,6,0)` `(32,4,0)`                                          |          | `Sky`                                                                                         |
| `SkyDarkBlue`    | 3      | `(8,8,32)` `(6,6,24)` `(4,4,16)`                                          |          | `Sky`                                                                                         |
| `SkyDarkGray`    | 3      | `(24,24,24)` `(16,16,16)` `(8,8,8)`                                       |          | `Sky`                                                                                         |

### Item colors (`ItemColors.sfdx`)

| Name                  | Shades | Ramp                                            | Adjusted | Used by                                                  |
| --------------------- | ------ | ----------------------------------------------- | -------- | -------------------------------------------------------- |
| `Skin1`               | 3      | `(135,83,48)` `(116,71,41)` `(96,58,34)`        |          | `Skin`                                                   |
| `Skin2`               | 3      | `(255,149,98)` `(255,124,62)` `(192,118,92)`    |          | `Skin`                                                   |
| `Skin3`               | 3      | `(255,172,132)` `(255,156,108)` `(192,96,48)`   |          | `Skin`                                                   |
| `Skin4`               | 3      | `(255,192,160)` `(255,172,132)` `(224,128,114)` |          | `Skin`                                                   |
| `Skin5`               | 3      | `(224,224,224)` `(208,192,192)` `(192,160,160)` |          | `Skin`                                                   |
| `ClothingLightGray`   | 3      | `(224,224,224)` `(192,192,192)` `(128,128,128)` |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightPink`   | 3      | `(255,192,192)` `(255,160,160)` `(255,128,128)` |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightRed`    | 3      | `(255,64,48)` `(224,48,32)` `(192,32,16)`       |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightOrange` | 3      | `(255,160,64)` `(255,128,32)` `(192,96,16)`     |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightYellow` | 3      | `(255,224,0)` `(240,192,0)` `(208,150,0)`       |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightGreen`  | 3      | `(96,192,64)` `(16,160,0)` `(8,128,0)`          |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightCyan`   | 3      | `(24,192,192)` `(16,160,160)` `(8,128,128)`     |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightBlue`   | 3      | `(160,160,255)` `(128,128,255)` `(96,96,192)`   |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightPurple` | 3      | `(224,128,224)` `(192,64,192)` `(160,32,160)`   |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingLightBrown`  | 3      | `(192,108,96)` `(160,96,64)` `(128,64,32)`      |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingGray`        | 3      | `(96,96,96)` `(64,64,64)` `(32,32,32)`          |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingPink`        | 3      | `(255,128,128)` `(232,96,96)` `(192,64,64)`     |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingRed`         | 3      | `(232,40,0)` `(180,32,0)` `(136,16,0)`          |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingOrange`      | 3      | `(255,128,0)` `(192,96,0)` `(128,64,0)`         |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingYellow`      | 3      | `(240,224,0)` `(208,192,0)` `(176,160,0)`       |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingGreen`       | 3      | `(32,160,0)` `(16,128,0)` `(8,96,0)`            |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingCyan`        | 3      | `(16,128,128)` `(8,96,96)` `(0,64,64)`          |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingBlue`        | 3      | `(64,64,224)` `(48,48,192)` `(36,36,160)`       |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingPurple`      | 3      | `(192,64,192)` `(160,32,160)` `(128,16,128)`    |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingBrown`       | 3      | `(128,64,48)` `(96,48,32)` `(64,32,16)`         |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkGray`    | 3      | `(48,48,48)` `(24,24,24)` `(12,12,12)`          |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkPink`    | 3      | `(160,64,64)` `(128,48,48)` `(96,32,32)`        |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkRed`     | 3      | `(128,16,0)` `(96,8,0)` `(64,0,0)`              | 🟢       | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkOrange`  | 3      | `(128,64,0)` `(96,32,0)` `(64,32,0)`            |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkYellow`  | 3      | `(128,128,0)` `(96,96,0)` `(64,64,0)`           |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkGreen`   | 3      | `(16,128,0)` `(12,96,0)` `(8,48,0)`             |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkCyan`    | 3      | `(8,96,96)` `(0,64,64)` `(0,32,32)`             |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkBlue`    | 3      | `(64,64,160)` `(32,32,128)` `(24,24,96)`        |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkPurple`  | 3      | `(128,0,128)` `(96,0,96)` `(64,0,64)`           |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingDarkBrown`   | 3      | `(96,48,32)` `(64,32,16)` `(48,24,8)`           |          | `Clothing1`, `ClothingDark1`, `ClothingGoggles1`, `Skin` |
| `ClothingWhite`       | 3      | `(255,255,255)` `(192,192,192)` `(160,160,160)` |          | —                                                        |
| `ClothingBlack`       | 3      | `(0,0,0)` `(0,0,0)` `(0,0,0)`                   |          | —                                                        |

## Palettes

### Tile palettes (`TilePalettes.sfdx`)

| Name       | `colors1`                                                                                | `colors2`                                                                                     | `colors3`         |
| ---------- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------- |
| `palNone`  | `White`                                                                                  | —                                                                                             | —                 |
| `Solid`    | `Gray` `Red` `Green` `Blue` `Yellow` `Cyan` `Magenta`                                    | same as `colors1`                                                                             | same as `colors1` |
| `Concrete` | `StoneGray` `StoneYellow` `StoneRed`                                                     | `LightYellow` `LightOrange` `LightBlue` `LightRed` `LightGreen` `White` `Black` `Transparent` | —                 |
| `Stone`    | `StoneGray` `StoneYellow` `StoneRed`                                                     | same as `Concrete.colors2`                                                                    | —                 |
| `Cloth`    | `Gray` `Red` `Blue` `Yellow` `Brown` `Cyan` `Magenta`                                    | —                                                                                             | —                 |
| `Metal`    | `MetalGray` `MetalBlue` `MetalRed` `MetalCyan` `MetalPink` `MetalYellow`                 | same as `Concrete.colors2`                                                                    | —                 |
| `Tile`     | `TileOrange` `TileCyan` `TileGray`                                                       | same as `Concrete.colors2`                                                                    | —                 |
| `Wood`     | `Wood0` `Wood1`                                                                          | same as `Concrete.colors2`                                                                    | —                 |
| `Lamp`     | `LightYellow` `LightOrange` `LightBlue` `LightGreen`                                     | —                                                                                             | —                 |
| `Neon`     | `NeonBlue` `NeonGreen` `NeonRed` `NeonPink` `NeonYellow` `NeonCyan`                      | same as `colors1`                                                                             | —                 |
| `Dirt`     | `DirtYellow` `DirtBrown` `DirtBlue`                                                      | same as `Concrete.colors2`                                                                    | —                 |
| `BG`       | 41: the ten `BgLight*`, ten `Bg*`, ten `BgDark*`, ten `BgBlack*`, then `Black`           | `LightYellow` `LightOrange` `LightBlue` `LightRed` `LightGreen` `White` `Black`               | —                 |
| `Moon`     | `BgLightYellow` `BgLightBlue` `BgLightRed` `White` `Black`                               | —                                                                                             | —                 |
| `FarBG`    | 21: the ten `Bg*`, ten `BgDark*`, then `Black`                                           | same as `BG.colors2`                                                                          | —                 |
| `Sky`      | 24: the ten `Bg*`, ten `BgDark*`, then `Black`, `SkyDarkRed` `SkyDarkBlue` `SkyDarkGray` | same as `BG.colors2`                                                                          | —                 |

`Concrete` and `Stone` are identical as shipped. `colors1` in both is `StoneGray`, `StoneYellow`, `StoneRed`, with `StoneBlue` and `StoneCyan` commented out. Those two are the only tile colors no palette can reach. The shared eight-color `colors2` block is repeated verbatim in `Concrete`, `Stone`, `Metal`, `Tile`, `Wood` and `Dirt`, and again without `Transparent` in `BG`, `FarBG` and `Sky`.

### Item palettes (`ItemPalettes.sfdx`)

Apart from the five `Skin*` tones, `ClothingWhite` and `ClothingBlack`, the item palettes all draw on the same 30 colors: ten `ClothingLight*`, ten mid-tone `Clothing*` and ten `ClothingDark*`. They are abbreviated below as:

- **Light**: the ten `ClothingLight*` colors
- **Mid**: the ten plain `Clothing*` colors
- **Dark**: the ten `ClothingDark*` colors

| Name               | `colors1`                               | `colors2`          | `colors3` | Assigned to |
| ------------------ | --------------------------------------- | ------------------ | --------- | ----------- |
| `Skin`             | `Skin1` `Skin2` `Skin3` `Skin4` `Skin5` | Light + Mid + Dark | —         | 13 items    |
| `Clothing1`        | Light + Mid + Dark                      | Light + Mid + Dark | —         | 145 items   |
| `ClothingGoggles1` | Dark + Mid                              | Light              | —         | 15 items    |
| `ClothingDark1`    | Dark + Mid                              | Light + Mid + Dark | —         | 40 items    |

`Skin` is the odd one out: `colors1` is skin tone and `colors2` is clothing colour, so skin and face-paint textures paint red markers for the body and green markers for the warpaint. `Clothing1` and `ClothingDark1` differ only in `colors1`. Dark leads with the muted half of the range, which is what makes an uncoloured item default to a darker garment.

No item palette defines `colors3`, and no shipped clothing item paints a blue marker.

## Notes on the shipped data

**Unreferenced colors.** These are defined but not in any palette, so nothing can select them: `StoneBlue`, `StoneCyan` (commented out of `Concrete` and `Stone`), `ClothingWhite` and `ClothingBlack`.

**Two-shade colors.** Only the `bgTest1`, `bgTest2` and `bgTest3` debug colors have fewer than three shades. A texture painting a third marker with them would leave that marker uncolored.

**Item palette assignment.** Counting the `colorPalette` string across all 213 `.item` files under `Content/Data/Items/`:

| Palette            | Items | Equipment layers          |
| ------------------ | ----- | ------------------------- |
| `Clothing1`        | 145   | 0, 1, 2, 3, 4, 5, 6, 7, 8 |
| `ClothingDark1`    | 40    | 1, 2, 3, 5, 6, 8          |
| `ClothingGoggles1` | 15    | 0, 5, 6, 8                |
| `Skin`             | 13    | 0, 9                      |

**Uncolorable items.** 14 items contain no marker pixels, so no palette can change how they look: `BearSkin`, `Burnt`, `Burnt_fem`, `Zombie`, `Zombie_fem`, `DogTag`, `Earpiece`, `GoalieMask`, `SantaMask`, `RiceHat`, `GrenadeBelt`, `GrenadeBelt_fem`, `HurtLevel1`, `HurtLevel2`.

Of the 199 colorable items, 195 paint red markers and 91 paint green markers. None paint a blue marker, which is why `colors3` is unused on the item side.

**`Transparent` is opaque black.** As explained in [Colors](Colors.md), the shipped `(0,0,0,0)` tuples parse into four opaque black shades. Six palettes reference it (`Concrete`, `Stone`, `Metal`, `Tile`, `Wood` and `Dirt`), always as the last entry of `colors2`, so in practice it acts as an "erase to black" option on level 1.
