package pga;

import VectorMath;

/**
 * A motor (rigid body transformation) in 3D.
 *
 * Motors combine rotation and translation into a single algebraic element.
 * They form the even subalgebra of PGA and are isomorphic to dual quaternions.
 *
 * Apply transformations via the sandwich product: m * x * ~m
 */
@:nullSafety
abstract Motor(Blade4) from Blade4 to Blade4 {
	/** Create motor directly from blade */
	inline function new(blade:Blade4) {
		this = blade;
	}

	/** Identity motor (no transformation) */
	public static inline function identity():Motor {
		return cast Blade4.one();
	}

	/** Pure rotation around axis through origin */
	public static inline function rotation(axis:Vec3, angle:Float):Motor {
		return cast Blade4.rotor(axis, angle);
	}

	/** Pure translation */
	public static inline function translation(tx:Float, ty:Float, tz:Float):Motor {
		return cast Blade4.translator(tx, ty, tz);
	}

	/** Pure translation from Vec3 */
	public static inline function translationVec(t:Vec3):Motor {
		return translation(t.x, t.y, t.z);
	}

	/** Combined rotation and translation */
	public static inline function rotationTranslation(axis:Vec3, angle:Float, trans:Vec3):Motor {
		return cast Blade4.motor(axis, angle, trans);
	}

	/** Create from dual quaternion */
	public static inline function fromDualQuat(dq:DualQuat):Motor {
		return cast Blade4.fromDualQuat(dq);
	}

	/** Convert to dual quaternion */
	public inline function toDualQuat():DualQuat {
		return this.toDualQuat();
	}

	/** Apply motor to a point */
	public inline function apply(p:Point):Point {
		return cast this.transformPoint(cast p);
	}

	/** Apply motor to a line */
	public inline function applyLine(l:Line):Line {
		return cast this.transformLine(cast l);
	}

	/** Apply motor to a plane */
	public inline function applyPlane(p:Plane):Plane {
		return cast this.transformPlane(cast p);
	}

	/** Apply motor to a Vec3 point */
	public inline function applyVec3(v:Vec3):Vec3 {
		return this.applyToPoint(v);
	}

	/** Compose with another motor (this applied first, then other) */
	@:op(a * b)
	public static inline function compose(a:Motor, b:Motor):Motor {
		return cast((cast b : Blade4) * (cast a : Blade4));
	}

	/** Inverse motor (reverses the transformation) */
	public inline function inverse():Motor {
		return cast this.reverse();
	}

	/** Reverse operator */
	@:op(~a)
	public static inline function opReverse(a:Motor):Motor {
		return cast(cast a : Blade4).reverse();
	}

	/** Normalize to unit motor */
	public inline function normalize():Motor {
		return cast this.normalize();
	}

	/** Extract rotation as quaternion */
	public inline function getRotation():Quat {
		return toDualQuat().real;
	}

	/** Extract translation as Vec3 */
	public inline function getTranslation():Vec3 {
		return toDualQuat().getTranslation();
	}

	/** Linear interpolation (use slerp for better quality) */
	public static inline function lerp(a:Motor, b:Motor, t:Float):Motor {
		var bladeA:Blade4 = cast a;
		var bladeB:Blade4 = cast b;
		return cast(bladeA * (1 - t) + bladeB * t).normalize();
	}
}

/** Shorthand for Motor.rotation */
inline function rotor(axis:Vec3, angle:Float):Motor {
	return Motor.rotation(axis, angle);
}

/** Shorthand for Motor.translation */
inline function translator(x:Float, y:Float, z:Float):Motor {
	return Motor.translation(x, y, z);
}

/** Shorthand for Motor.rotationTranslation */
inline function motor(axis:Vec3, angle:Float, trans:Vec3):Motor {
	return Motor.rotationTranslation(axis, angle, trans);
}
