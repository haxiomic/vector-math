package sta;

import VectorMath;

/**
 * A Lorentz transformation as an even-grade multivector (rotor).
 *
 * Combines boosts and rotations. Applied via sandwich product: v' = R v R̃
 *
 * - Pure rotations: R = cos(θ/2) - sin(θ/2)(nx e23 + ny e31 + nz e12)
 * - Pure boosts: R = cosh(φ/2) - sinh(φ/2)(nx e01 + ny e02 + nz e03)
 * - General: composition of boosts and rotations
 */
@:nullSafety
abstract Rotor(Blade4) from Blade4 to Blade4 {
	/** Create rotor from blade */
	inline function new(blade:Blade4) {
		this = blade;
	}

	/** Scalar component (for inspection) */
	public var scalar(get, never):Float;

	inline function get_scalar():Float
		return this.s;

	/** Identity transformation */
	public static inline function identity():Rotor {
		return cast Blade4.one();
	}

	/** Pure spatial rotation around axis by angle (radians) */
	public static inline function rotation(axis:Vec3, angle:Float):Rotor {
		return cast Blade4.rotation(axis.x, axis.y, axis.z, angle);
	}

	/** Rotation around x-axis */
	public static inline function rotationX(angle:Float):Rotor {
		return rotation(vec3(1, 0, 0), angle);
	}

	/** Rotation around y-axis */
	public static inline function rotationY(angle:Float):Rotor {
		return rotation(vec3(0, 1, 0), angle);
	}

	/** Rotation around z-axis */
	public static inline function rotationZ(angle:Float):Rotor {
		return rotation(vec3(0, 0, 1), angle);
	}

	/** Pure boost in direction with given rapidity.
	 *  Rapidity φ relates to velocity by: v = tanh(φ), γ = cosh(φ)
	 */
	public static inline function boost(direction:Vec3, rapidity:Float):Rotor {
		return cast Blade4.boost(direction.x, direction.y, direction.z, rapidity);
	}

	/** Boost along x-axis with rapidity */
	public static inline function boostX(rapidity:Float):Rotor {
		return boost(vec3(1, 0, 0), rapidity);
	}

	/** Boost along y-axis with rapidity */
	public static inline function boostY(rapidity:Float):Rotor {
		return boost(vec3(0, 1, 0), rapidity);
	}

	/** Boost along z-axis with rapidity */
	public static inline function boostZ(rapidity:Float):Rotor {
		return boost(vec3(0, 0, 1), rapidity);
	}

	/** Boost from ordinary velocity (|v| < 1) */
	public static inline function boostFromVelocity(v:Vec3):Rotor {
		return cast Blade4.boostFromVelocity(v.x, v.y, v.z);
	}

	/** Boost from velocity components */
	public static inline function boostFromVelocityXYZ(vx:Float, vy:Float, vz:Float):Rotor {
		return cast Blade4.boostFromVelocity(vx, vy, vz);
	}

	/** Convert rapidity to velocity: v = tanh(φ) */
	public static inline function rapidityToVelocity(rapidity:Float):Float {
		var ex = Math.exp(rapidity);
		var emx = 1.0 / ex;
		return (ex - emx) / (ex + emx); // tanh
	}

	/** Convert velocity to rapidity: φ = arctanh(v) */
	public static inline function velocityToRapidity(v:Float):Float {
		if (v >= 1.0)
			v = 1.0 - Blade4.EPSILON;
		if (v <= -1.0)
			v = -1.0 + Blade4.EPSILON;
		return 0.5 * Math.log((1 + v) / (1 - v));
	}

	/** Apply transformation to an event */
	public inline function apply(e:Event):Event {
		return cast this.transform(cast e);
	}

	/** Apply transformation to a 4-vector */
	public inline function applyVector(v:FourVector):FourVector {
		return cast this.transform(cast v);
	}

	/** Apply transformation to an EM field.
	 *  For bivectors: F' = R F R̃
	 */
	public inline function applyField(f:Field):Field {
		return cast this.transform(cast f);
	}

	/** Compose transformations: result applies this first, then other */
	@:op(a * b)
	public static inline function compose(a:Rotor, b:Rotor):Rotor {
		return cast((cast a : Blade4) * (cast b : Blade4));
	}

	/** Inverse transformation */
	public inline function inverse():Rotor {
		return cast this.reverse();
	}

	/** Reverse (same as inverse for unit rotors) */
	@:op(~a)
	public static inline function reverse(a:Rotor):Rotor {
		return cast(cast a : Blade4).reverse();
	}
}

/** Shorthand for rotation */
inline function lorentzRotation(axis:Vec3, angle:Float):Rotor {
	return Rotor.rotation(axis, angle);
}

/** Shorthand for boost */
inline function lorentzBoost(direction:Vec3, rapidity:Float):Rotor {
	return Rotor.boost(direction, rapidity);
}
