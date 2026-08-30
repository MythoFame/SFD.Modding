# SFDX format guide

SFDX is a readable data format for game content. The core idea is simple:

- `tile` and `defaultTile` define world objects
- `fixture` defines collision shapes
- `animation` defines visual timing
- `Material` defines physical properties
- `collisionGroup` defines physics interaction masks
- `color` and `colorPalette` define render variants
- weapons are stored as tile-like entries with pickup physics

If you can read one `tile(...)` block, one `fixture()` block, and one `Material(...)` block, you can understand most of the format.

## Quick reference

| Type                             | Purpose                                      | Common fields                                                  |
| -------------------------------- | -------------------------------------------- | -------------------------------------------------------------- |
| `tile(...)` / `defaultTile(...)` | Main map object and default object template  | `material`, `colorPalette`, `sizeable`, `kickable`, `type`     |
| `fixture()`                      | Collision shape and body data                | `collisionGroup`, `collisionPoints`, `circle`, `mass`          |
| `animation(...)`                 | Visual timing for animated tiles             | `frameTimes`, `width`, `isSynced`                              |
| `Material(...)`                  | Shared physical behavior                     | `density`, `friction`, `restitution`, `hit.*`, `destroyEffect` |
| `collisionGroup(...)`            | Physics interaction rules between categories | `categoryBits`, `maskBits`, `aboveBits`                        |
| `color(...)`                     | Named color value set                        | `c`                                                            |
| `colorPalette(...)`              | Named palette of colors                      | `colors1`, `colors2`, `colors3`                                |

### Index

- [Base Syntax](SFDX.md#base-syntax)
- [Tiles](SFD.md#tiles)
- [Fixtures](SFD.md#fixtures)
- [Animations](SFD.md#animations)
- [Materials](SFD.md#materials)
- [Collision Groups](SFD.md#collision-groups)
- [Colors and Palettes](SFD.md#colors-and-palettes)
- [Weapons](SFD.md#weapons)

---

## Base Syntax

```sfdx
Name = value;
Type(Name) {
    property = value;
    child() {
        nested = value;
    }
}
```

### Samples

```sfdx
Material(default) {
    density = 30.0kg;
    friction = 0.5;
}

defaultTile(DefaultTile) {
    material = default;
    kickable = true;
}

tile(Concrete00A) {
    material = concrete;
    fixture() {
        collisionPoints = (-8,-8),(8,-8),(8,8),(-8,8);
    }
}
```

### Value types

- booleans: `true`, `false`
- integers: `1`, `16`
- floats: `0.5`, `3.2`
- strings: `Concrete`, `none`, `Metal`
- lists: `Gray,Red,Blue`
- vectors: `(x,y)`
- mass: `20kg`, `0.5b2`
- binary masks: `0000 0000 0000 0001`

### Further info

You can add comments by using `//`.

---

## Tiles

Tiles are the main SFDX object type. They define a world object, its visuals, and its behavior.

```sfdx
defaultTile(DefaultTile) {
    material = default;
    colorPalette = Solid;
    kickable = true;
    type = Static;
    editorEnabled = true;

    fixture() {
        collisionGroup = static_ground;
        collisionPoints = null;
    }
}

tile(Concrete00A) {
    material = concrete;
    colorPalette = Concrete;
    sizeable = A;
}
```

### Default Tile

`defaultTile()` acts as a shared template for all following tiles until another default is set.

```sfdx
defaultTile(d_t) { material=concrete; colorPalette=Concrete; sizeable=A; }
tile(Concrete00A) {}
tile(Concrete00B) {}
```

### Fields

Identity and editor:

- `name`
- `key`
- `helpEntry`
- `uniqueId`
- `editorEnabled`
- `freeRotation`
- `cloudRotation`
- `sizeable`

Visual:

- `tileTexture`
- `listTexture`
- `tileTextureOffset`
- `colorPalette`
- `startColor`
- `drawCategory`
- `mainLayer`
- `weatherGround`
- `weatherStop`

Physics and gameplay:

- `type`
- `material`
- `isCloud`
- `isLadder`
- `kickable`
- `kickableTop`
- `punchable`
- `blockMelee`
- `projectileHit`
- `absorbProjectile`
- `objectStrength`
- `life`
- `instaGibPlayer`
- `breakOnDive`
- `breakOnStagger`
- `allowDynamicPathNodeConnections`

Damage and impact:

- `doTakeDamage.Fire`
- `doTakeDamage.Explosion`
- `doTakeDamage.Projectile`
- `doTakeDamage.Impact`
- `doTakeDamage.PlayerImpact`
- `impactSound`
- `impactEffect`

Missile and debris:

- `canBeMissile`
- `missileDamageFactor`
- `missileDamageFactorThrown`
- `missileDamageFactorDropped`
- `missileDamageFactorDebris`
- `missileDamageBase`
- `missileDamageBaseThrown`
- `missileDamageBaseDropped`
- `missileDamageBaseDebris`
- `missileDamageMax`
- `missileDamageMaxThrown`
- `missileDamageMaxDropped`
- `missileDamageMaxDebri`
- `missileNormalHitSoundID`
- `missileNormalHitEffectID`
- `missileThrownHitSoundID`
- `missileThrownHitEffectID`
- `missileMarkAsHeavyDebris`

Gib pressure:

- `gibPressure.Total`
- `gibPressure.Spike`
- `gibPressure.EnableOneWay`
- `gibPreassure.Total`
- `gibPreassure.Spike`
- `gibPreassure.EnableOneWay`

Pickup:

- `pickupType`
- `pickupRange`

Sync:

- `clientSync.DisableAnglePositionClippingCheck`
- `clientSync.EnableContactsOnDestroyedByPlayerImpact`

---

## Fixtures

### Sample

```sfdx
fixture() {
    collisionGroup = static_ground;
    collisionPoints = (-8,-8),(8,-8),(8,8),(-8,8);
    mass = 0.5kg;
    blockFire = true;
}
```

### Fields

- `collisionGroup`
- `categoryBits`
- `maskBits`
- `aboveBits`
- `groupIndex`
- `collisionPoints`
- `circle`
- `mass`
- `material`
- `blockMelee`
- `kickable`
- `kickableTop`
- `punchable`
- `isCloud`
- `blockFire`
- `absorbProjectile`
- `projectileHit`
- `objectStrength`

---

## Animations

### Sample

```sfdx
animation(Acid00A) {
    frameTimes = 100,120,80;
    width = 16;
    isSynced = true;
}
```

### Fields

- `frameTimes`
- `width`
- `isSynced`

---

## Materials

### Sample

```sfdx
Material(default) {
    density = 30.0kg;
    friction = 0.5;
    restitution = 0.2;
    flammable = false;

    hit.projectile.sound = BulletHitDefault;
    hit.projectile.effect = BulletHitDefault;
    destroyEffect = DestroyDefault;
    destroySound = DestroyDefault;
    stepSound = none;
}
```

### Fields

Core:

- `density`
- `friction`
- `restitution`
- `flammable`
- `canBurn`
- `transparent`
- `blockExplosions`
- `blockExplosion`

Resistance:

- `resistance.fire.modifier`
- `resistance.fire.threshold`
- `resistance.explosion.modifier`
- `resistance.explosion.threshold`
- `resistance.projectile.modifier`
- `resistance.projectile.threshold`
- `resistance.impact.modifier`
- `resistance.impact.threshold`
- `resistance.playerImpact.modifier`
- `resistance.playerImpact.threshold`

Hit and effect keys:

- `hit.melee.power`
- `hit.melee.prio`
- `hit.melee.sound`
- `hit.melee.effect`
- `hit.kick.power`
- `hit.kick.prio`
- `hit.kick.sound`
- `hit.kick.effect`
- `hit.punch.power`
- `hit.punch.prio`
- `hit.punch.sound`
- `hit.punch.effect`
- `hit.explosion.power`
- `hit.projectile.power`
- `hit.projectile.sound`
- `hit.projectile.effect`
- `destroyEffect`
- `destroySound`
- `stepSound`

---

## Collision Groups

### Sample

```sfdx
collisionGroup(static_ground) {
    categoryBits = 0000 0000 0000 0001;
    maskBits = 1110 1111 1110 1101;
    aboveBits = 0000 0000 0000 0000;
}
```

### Fields

- `categoryBits`
- `maskBits`
- `aboveBits`
- `groupIndex`
- `name`
- `key`

### Groups

- `none`
- `static_ground`
- `dynamic_platforms`
- `players`
- `dynamics_g1`
- `dynamics_g2`
- `items`
- `debris`
- `dynamics_thrown`
- `full`

These are binary bitmask values, not normal integers.

---

## Colors and Palettes

### Sample

```sfdx
color(White) {
    c = (255,255,255),(255,255,255),(255,255,255);
}

colorPalette(Concrete) {
    colors1 = StoneGray,StoneYellow,StoneRed;
    colors2 = LightYellow,LightOrange,LightBlue,LightRed,LightGreen,White,Black,Transparent;
}
```

### Color Fields

- `c`

### Palette Fields

- `colors1`
- `colors2`
- `colors3`

### Tile Sample

```sfdx
tile(Concrete00A) {
    colorPalette = Concrete;
}
```

---

## Weapons

Weapon data is not a unique SFDX root type. It is effectively a tile definition with pickup physics.

### Sample

```sfdx
tile(WpnPistol) {
    tileTexture = PistolM;
    pickupType = instant;
    pickupRange = 10.0;
    absorbProjectile = false;
    projectileHit = false;
    impactEffect = ImpactDefault;
    impactSound = WeaponBounce;
    missileDamageMax = 10;
    fixture() {
        collisionGroup = debris;
        mass = 2.5kg;
        collisionPoints = (-3.5,1.5),(3.5,1.5),(3.5,3.5),(-3.5,3.5);
    }
}
```

### Fields

- `pickupType`
- `pickupRange`
- `canBeMissile`
- `absorbProjectile`
- `projectileHit`
- `impactEffect`
- `impactSound`
- `material`
- `material.blockExplosions`
- `material.destroyEffect`
- `material.destroySound`
- `gibPressure.Total`
- `gibPressure.Spike`
- `life`
- `missileDamageMax`
- `missileDamageFactor`
- `missileDamageBase`

### Fixture fields used

- `collisionGroup`
- `mass`
- `collisionPoints`
- `circle`
- `blockFire`
- `material`
- `projectileHit`
- `absorbProjectile`
- `objectStrength`

---
