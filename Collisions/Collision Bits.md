# Collision Bits

In SFD you can alter collisions between different layers by using mask and category bits, via scripts or with the `AlterCollisionTile`.  
The collision values can be found at: `Content/Data/Tiles/CollisionGroups/collisionGroups.sfdx`.

> [!NOTE]  
> Collision bits are a feature of the Box2D library, which SFD uses for physics.

## Practical Example

Let's say we want to disable collisions between players and a crate.

Open `collisionGroups.sfdx` and you will notice the binary values for the `maskBits`, `categoryBits` and `aboveBits` of different items.
Take note of the `maskBits` and `categoryBits` of the player and of the crates.

### Why do they collide?

Two objects collide when either of these is true:

- the first object's `maskBits` and the second object's `categoryBits` share a set bit
- the first object's `categoryBits` and the second object's `maskBits` share a set bit

Either direction is enough, so a disable has to break both.

So, what do we do?

First, check the `categoryBits` of the crate (`dynamic_g1`), which are `0000 0000 0000 1000`.
As you can see, the fourth bit (starting from the right) is `1`, meaning that if the player's fourth mask bit is `1` too, there will be a collision.

The player's `maskBits` are `0000 0000 0000 1011`.
You can see that the player's fourth mask bit is `1` as well, which means players will collide with crates.

As you may have noticed, `AlterCollisionTile`s disable category and mask bits, so if we want to make it so that the crate can't hit players, we will have to either:

- disable the player's fourth mask bit
- disable the crate's fourth category bit

It's easier to handle the crate, so we will go for the second solution.

### Disabling the collision

Link your `AlterCollisionTile` to the crate and disable the bits you want to disable.
The tile clears the disabled bits from the target's own bits, so a `0` bit in the disabled value changes nothing.

For instance, you want to disable the fourth bit of the crate's `categoryBits`, which is `0000 0000 0000 1000` in binary.

Since `AlterCollisionTile`s use [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) rather than binary, you have to translate the binary number into a hexadecimal one:

| Binary                | Hex    |
| --------------------- | ------ |
| `0000 0000 0000 1000` | `0008` |

Write `0008` into the disable category bits section of the `AlterCollisionTile`.

Now we want to apply the same logic to the crate's `maskBits` (`1111 1111 1110 1111`) and the player's `categoryBits` (`0000 0000 0000 0100`) this time.
Thus, we want to set the third (and only the third) bit of the crate's `maskBits` to `0`, so they won't collide:

The value `0000 0000 0000 0100` translates to `0004` in hex. Put it in the disable mask bits section, et voilà! You cannot collide with the crate anymore.

## Summary

You will have to do these few steps to disable the collision between two objects:

1. Check and take note of the `categoryBits` and `maskBits` of both objects.
2. Find the conflicting bits in the first object's `categoryBits` and the second object's `maskBits`.
3. Disable the category bits of the object that is easier to manipulate according to the previous step.
4. Repeat: Disable the `maskBits` of the same object, depending on the conflicting bits between the first object's `maskBits` and the second object's `categoryBits`.
