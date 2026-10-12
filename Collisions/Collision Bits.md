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

## Scripting

Scripts change a filter by writing the object's `CollisionFilter` with `SetCollisionFilter`. The new value applies to every fixture on that object. Players are excluded from this, so the object you change must not be a player. Players can still be read and used as references.

### Reading a filter

```csharp
IObject crate = Game.GetSingleObjectByCustomID<IObject>("Crate");
CollisionFilter filter = crate.GetCollisionFilter();
// filter.CategoryBits, filter.MaskBits, filter.AboveBits (ushort)
```

`GetCollisionFilter()` returns the union of the bits of all the object's fixtures.

### Stopping two objects from colliding

Apply the rule from the start of this page to the target object's own bits. Clear the reference's bits from the target in both directions:

- clear the reference's `maskBits` from the target's `categoryBits`
- clear the reference's `categoryBits` from the target's `maskBits`

```csharp
public void StopCollidingWith(IObject target, IObject reference)
{
    CollisionFilter targetFilter = target.GetCollisionFilter();
    CollisionFilter referenceFilter = reference.GetCollisionFilter();

    targetFilter.CategoryBits &= (ushort)~referenceFilter.MaskBits;
    targetFilter.MaskBits &= (ushort)~referenceFilter.CategoryBits;

    target.SetCollisionFilter(targetFilter);
}
```

The reference is only read, so it keeps its collisions. The target loses every collision that uses the cleared bits, not just the one with the reference.

For example, take a crate as the target and a player as the reference. From the values in `collisionGroups.sfdx`:

- the crate's `categoryBits` are `0000 0000 0000 1000`, and the player's `maskBits` include that bit
- the player's `categoryBits` are `0000 0000 0000 0100`, and the crate's `maskBits` include that bit

Clearing the player's `maskBits` from the crate's `categoryBits` removes `0000 0000 0000 1000` from the crate, and clearing the player's `categoryBits` from the crate's `maskBits` removes `0000 0000 0000 0100`. Those bits are shared with other objects, so the change reaches them too. `0000 0000 0000 1000` is the `dynamics_g1` category, so nothing matches this crate's category anymore. But the crate's own `maskBits` still include that bit, so it still collides with other crates in that direction. Check which objects share a bit before you clear it.

Keep the original filter if you need to restore the collision later:

```csharp
CollisionFilter original = target.GetCollisionFilter();
// ...
target.SetCollisionFilter(original);
```

Restoring writes back every field, including the bits you did not change.
