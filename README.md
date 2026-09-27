<div align="center">

[![Superfighters Deluxe Logo](https://raw.githubusercontent.com/MythoFame/.github/refs/heads/master/assets/SFD_titleLoop.gif)](https://store.steampowered.com/app/855860)

# Modding

Reverse engineering and useful information for modding, map making and scripting in Superfighters Deluxe

[![GitHub License](https://img.shields.io/github/license/MythoFame/SFD.Modding)](LICENSE)

</div>

<!--

## Textures

-->

## Colors

| Name                                           | Description                                                                            |
| ---------------------------------------------- | -------------------------------------------------------------------------------------- |
| [Colors](Colors/Colors.md)                     | How recoloring works: marker pixels, the five shade slots, the `color()` format.       |
| [Color Palettes](Colors/Palettes.md)           | The `colorPalette()` format, the three color levels, and how objects pick colors.      |
| [Color Reference](Colors/Color%20Reference.md) | All 124 shipped colors and 19 palettes, with the colors and items each one is used by. |

## Sounds

| Name                            | Description                                                         |
| ------------------------------- | ------------------------------------------------------------------- |
| [Sounds.tsv](Sounds/Sounds.tsv) | Game sound events mapped to sound files, with their default volume. |

## Mapmaking

| Name                                      | Description                                                                 |
| ----------------------------------------- | --------------------------------------------------------------------------- |
| [SFDM Format](Mapmaking/SFDM%20Format.md) | The .sfdm binary format: headers, campaigns, chapters and embedded scripts. |

## Scripting

| Name                                      | Description                                                        |
| ----------------------------------------- | ------------------------------------------------------------------ |
| [SFDE Format](Scripting/SFDE%20Format.md) | The .sfde binary format: h_ext, h_exscript and embedded C# source. |

## Cosmetics

| Name                                                      | Description                                |
| --------------------------------------------------------- | ------------------------------------------ |
| [Cosmetics Internals](Cosmetics/Cosmetics%20Internals.md) | How cosmetics internally work in the game. |

## Misc

| Name                                                   | Description                                                                                               |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| [Binary World Format](Misc/Binary%20World%20Format.md) | Binary container shared by .sfdm and .sfde: primitives, h\_\* headers and world properties.               |
| [SFDX Format](Misc/SFDX%20Format.md)                   | Human-readable game content format: tiles, fixtures, animations, materials, collision groups and weapons. |
| [Special Characters](Misc/Special%20Characters.md)     | Broken and special characters that somehow work in Superfighters Deluxe.                                  |
