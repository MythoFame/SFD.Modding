# Collisions Filter

In SFD you can alter collisions between different layers by using mask filters, via scripts or with the `AlterCollision` trigger.  
The collisions values can be found at: `Content/Data/Tiles/collisionGroups/collisionGroups.sfdx`.

**Note**: collisions masks are actually a feature of the Box2D library, which is in SFD for physics.

## Hexadeciaml system

To make it simple, hexadecimal is a number format ranging from 0 to F.
Decimal format is a base 10 numerical system, hexadecimal is a base 16 instead.

Here's their digits and their translation:

| Hex  | Binary | Decimal |
| ---- | ------ | ------- |
| `0`  | `0000` | `0`     |
| `1`  | `0001` | `1`     |
| `2`  | `0010` | `2`     |
| `3`  | `0011` | `3`     |
| `4`  | `0100` | `4`     |
| `5`  | `0101` | `5`     |
| `6`  | `0110` | `6`     |
| `7`  | `0111` | `7`     |
| `8`  | `1000` | `8`     |
| `9`  | `1001` | `9`     |
| `10` | `1010` | `A`     |
| `11` | `1011` | `B`     |
| `12` | `1100` | `C`     |
| `13` | `1101` | `D`     |
| `14` | `1110` | `E`     |
| `15` | `1111` | `F`     |

## Pratical Example

Let's say we want to disable the collisions between players and a crate.

Open `collisionGroups.sfdx` and you will notice that there are the binary values for the maskbytes, categorybytes and abovebytes of different items.
Take note of the maskbytes and categorybytes of the player and of the crates

### Why they collide?

They collide when one byte in the categorybyte of the first object is to `1` while the same byte of the maskbytes of the second object is the same value.
Note that it apply reversally, with categorybytes from the second object and maskbytes from the first object.

So, what do we do?

First, check the categorybytes of the crate(dynamic_g1), which is `0000 0000 0000 1000`.
as you can see, the fourth byte (starting from right) is `1`; meaning that if the player's fourth maskbyte is `1` too, then there will be a collision.

The player's maskbytes are `0000 0000 0000 1011`
you see that the player's fourth maskbyte is `1` as well, that mean that players will collide with crates.

As you may have noticed, altercollisiontiles disable category and mask bytes, so, if we want to make so that the crate can't hit players, we will have to either:

- disable players fourth maskbyte
- disable crate's fourth categorybyte

it's easier to handle the crate, then we will go for the second solution.

### Disabling the collision

Link your `AtlerCollisionTile` to the crate and disable the bytes you want to disable.

For instance, you want to disable the fourth byte of the crate's categorybytes, that translate to `0000 0000 0000 1000` in binary

But, since altercollisiontiles use hexadecimal rather than binary, you have to translate the binary number into a hexadecimal one:

| Binary                | Hex    |
| --------------------- | ------ |
| `0000 0000 0000 1000` | `0008` |

Write `0008` into the 'disable categorybytes' section of the altercollision tile.

Now we want to apply the same logic but to crate's maskbytes (`1111 1111 1110 1111`) and player's categorybytes (`0000 0000 0000 0100`) this time
thus, we want to set to `0` the third (and only the third) byte on the crate's maskbytes, so they won't collide:

The value `0000 0000 0000 0100` translates to `0006` in hex. Put it in the disable maskbytes section, et voilà! You cannot collide with the crate anymore.

## Summary

You will have to do these few steps to disable the collision between two objects:

1. Check and take note of the categorybytes and maskbytes of both object.
2. Find the conflicting bytes in first object's categorybytes and second object's maskbytes.
3. Disable the category bytes of the object that is easier to manipulate according to the previous step.
4. Repeat: Disable the maskbytes of the same object, depending of conflicting bytes between first object's maskbytes and second objectt's category bytes.
