# Collision Filter

In SFD you can alter collisions between different layers by using mask and category bytes, via scripts or with the `AlterCollisionTile`.  
The collision values can be found at: `Content/Data/Tiles/collisionGroups/collisionGroups.sfdx`.

**Note**: collision bytes are actually a feature of the Box2D library, which is used by SFD for physics.

## Hexadecimal System

To make it simple, hexadecimal is a number format ranging from `0` to `F`, while binary is composed of only two digits, `0` and `1`.

Here are the digits and their translations:

| Hex | Binary | Decimal |
| --- | ------ | ------- |
| `0` | `0000` | `0`     |
| `1` | `0001` | `1`     |
| `2` | `0010` | `2`     |
| `3` | `0011` | `3`     |
| `4` | `0100` | `4`     |
| `5` | `0101` | `5`     |
| `6` | `0110` | `6`     |
| `7` | `0111` | `7`     |
| `8` | `1000` | `8`     |
| `9` | `1001` | `9`     |
| `A` | `1010` | `10`    |
| `B` | `1011` | `11`    |
| `C` | `1100` | `12`    |
| `D` | `1101` | `13`    |
| `E` | `1110` | `14`    |
| `F` | `1111` | `15`    |

## Practical Example

Let's say we want to disable collisions between players and a crate.

Open `collisionGroups.sfdx` and you will notice the binary values for the `maskbytes`, `categorybytes` and `abovebytes` of different items.
Take note of the `maskbytes` and `categorybytes` of the player and of the crates.

### Why do they collide?

They collide when one byte in the `categorybytes` of the first object is set to `1` while the same byte of the `maskbytes` of the second object is also `1`.
Note that it applies in reverse, with `categorybytes` from the second object and `maskbytes` from the first object.

So, what do we do?

First, check the `categorybytes` of the crate (`dynamic_g1`), which are `0000 0000 0000 1000`.
As you can see, the fourth byte (starting from the right) is `1`, meaning that if the player's fourth `maskbyte` is `1` too, there will be a collision.

The player's `maskbytes` are `0000 0000 0000 1011`.
You can see that the player's fourth `maskbyte` is `1` as well, which means players will collide with crates.

As you may have noticed, `AlterCollisionTile`s disable category and mask bytes, so if we want to make it so that the crate can't hit players, we will have to either:

- disable the player's fourth `maskbyte`
- disable the crate's fourth `categorybyte`

It's easier to handle the crate, so we will go for the second solution.

### Disabling the collision

Link your `AlterCollisionTile` to the crate and disable the bytes you want to disable.

For instance, you want to disable the fourth byte of the crate's `categorybytes`, that translates to `0000 0000 0000 1000` in binary.

But since `AlterCollisionTile`s use hexadecimal rather than binary, you have to translate the binary number into a hexadecimal one:

| Binary                | Hex    |
| --------------------- | ------ |
| `0000 0000 0000 1000` | `0008` |

Write `0008` into the `disable categorybytes` section of the `AlterCollisionTile`.

Now we want to apply the same logic but to the crate's `maskbytes` (`1111 1111 1110 1111`) and the player's `categorybytes` (`0000 0000 0000 0100`) this time.
Thus, we want to set the third (and only the third) byte of the crate's `maskbytes` to `0`, so they won't collide:

The value `0000 0000 0000 0100` translates to `0004` in hex. Put it in the `disable maskbytes` section, et voilà! You cannot collide with the crate anymore.

## Summary

You will have to do these few steps to disable the collision between two objects:

1. Check and take note of the `categorybytes` and `maskbytes` of both objects.
2. Find the conflicting bytes in the first object's `categorybytes` and the second object's `maskbytes`.
3. Disable the category bytes of the object that is easier to manipulate according to the previous step.
4. Repeat: Disable the `maskbytes` of the same object, depending on the conflicting bytes between the first object's `maskbytes` and the second object's `categorybytes`.
