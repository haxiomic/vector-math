package sta;

import VectorMath;

/**
 * A 4-vector in spacetime.
 *
 * Used for: 4-velocity, 4-momentum, 4-current, 4-potential, etc.
 * Components: (v⁰, v¹, v², v³) = (time component, spatial components)
 */
@:nullSafety
abstract FourVector(Blade4) from Blade4 to Blade4 {
	/** Create a 4-vector with components (v0, v1, v2, v3) */
	public inline function new(v0:Float, v1:Float, v2:Float, v3:Float) {
		this = Blade4.vector(v0, v1, v2, v3);
	}

	/** Zero 4-vector */
	public static inline function zero():FourVector {
		return new FourVector(0, 0, 0, 0);
	}

	/** Create a 4-velocity from 3-velocity (auto-normalizes to unit timelike).
	 *  Input: ordinary velocity (vx, vy, vz) with |v| < 1
	 *  Output: (γ, γvx, γvy, γvz) where γ = 1/√(1-v²)
	 */
	public static inline function velocity(vx:Float, vy:Float, vz:Float):FourVector {
		return cast Blade4.fourVelocity(vx, vy, vz);
	}

	/** Create a 4-velocity from rapidity in direction (nx, ny, nz).
	 *  u = (cosh φ, sinh φ · n̂)
	 */
	public static function velocityFromRapidity(nx:Float, ny:Float, nz:Float, rapidity:Float):FourVector {
		var len = Math.sqrt(nx * nx + ny * ny + nz * nz);
		if (len < Blade4.EPSILON)
			return new FourVector(1, 0, 0, 0); // At rest
		nx /= len;
		ny /= len;
		nz /= len;

		var ex = Math.exp(rapidity);
		var ch = (ex + 1.0 / ex) * 0.5; // cosh
		var sh = (ex - 1.0 / ex) * 0.5; // sinh

		return new FourVector(ch, sh * nx, sh * ny, sh * nz);
	}

	/** 4-momentum from mass and 3-velocity: p = (E, px, py, pz) = (γm, γmv) */
	public static inline function momentum(mass:Float, vx:Float, vy:Float, vz:Float):FourVector {
		var u = velocity(vx, vy, vz);
		return cast((cast u : Blade4) * mass);
	}

	/** 4-momentum of a photon (massless) with energy E and direction */
	public static inline function photon(energy:Float, nx:Float, ny:Float, nz:Float):FourVector {
		var len = Math.sqrt(nx * nx + ny * ny + nz * nz);
		if (len < Blade4.EPSILON)
			return new FourVector(energy, energy, 0, 0);
		return new FourVector(energy, energy * nx / len, energy * ny / len, energy * nz / len);
	}

	/** Pure spatial vector (0, x, y, z) */
	public static inline function spatial(x:Float, y:Float, z:Float):FourVector {
		return new FourVector(0, x, y, z);
	}

	/** Pure temporal vector (t, 0, 0, 0) */
	public static inline function temporal(t:Float):FourVector {
		return new FourVector(t, 0, 0, 0);
	}

	/** Time component (v⁰) */
	public var v0(get, never):Float;

	inline function get_v0():Float
		return this.e0;

	/** Spatial components */
	public var v1(get, never):Float;

	inline function get_v1():Float
		return this.e1;

	public var v2(get, never):Float;

	inline function get_v2():Float
		return this.e2;

	public var v3(get, never):Float;

	inline function get_v3():Float
		return this.e3;

	/** Get spatial part as Vec3 (creates new Vec3) */
	public inline function getSpatial():Vec3 {
		return vec3(this.e1, this.e2, this.e3);
	}

	/** As Vec4 */
	public inline function toVec4():Vec4 {
		return vec4(this.e0, this.e1, this.e2, this.e3);
	}

	/** Squared magnitude: v² = v⁰² - v¹² - v²² - v³² */
	public inline function magnitudeSquared():Float {
		return this.normSquared();
	}

	/** Magnitude (absolute value of √|v²|) */
	public inline function magnitude():Float {
		return this.norm();
	}

	/** Is this a timelike vector? (v² > 0) */
	public inline function isTimelike():Bool {
		return this.isTimelike();
	}

	/** Is this a spacelike vector? (v² < 0) */
	public inline function isSpacelike():Bool {
		return this.isSpacelike();
	}

	/** Is this a lightlike/null vector? (v² = 0) */
	public inline function isLightlike():Bool {
		return this.isLightlike();
	}

	/** Minkowski inner product: a·b = a⁰b⁰ - a¹b¹ - a²b² - a³b³ */
	public inline function dot(other:FourVector):Float {
		var o:Blade4 = cast other;
		return this.e0 * o.e0 - this.e1 * o.e1 - this.e2 * o.e2 - this.e3 * o.e3;
	}

	/** Normalize to unit vector (timelike → u²=1, spacelike → u²=-1) */
	public inline function normalize():FourVector {
		var m2 = magnitudeSquared();
		if (Math.abs(m2) < Blade4.EPSILON)
			return this;
		var scale = 1.0 / Math.sqrt(Math.abs(m2));
		return cast((cast this : Blade4) * scale);
	}

	/** For 4-velocity: extract ordinary 3-velocity (v = p/γ) */
	public inline function toVelocity3():Vec3 {
		var gamma = this.e0;
		if (Math.abs(gamma) < Blade4.EPSILON)
			return vec3(0, 0, 0);
		return vec3(this.e1 / gamma, this.e2 / gamma, this.e3 / gamma);
	}

	/** For 4-momentum: extract energy (p⁰) */
	public var energy(get, never):Float;

	inline function get_energy():Float
		return this.e0;

	/** Get 3-momentum (creates new Vec3) */
	public inline function getMomentum():Vec3 {
		return vec3(this.e1, this.e2, this.e3);
	}

	/** For 4-momentum: extract rest mass (m² = E² - |p|²) */
	public inline function restMass():Float {
		var m2 = magnitudeSquared();
		return if (m2 > 0) Math.sqrt(m2) else 0;
	}

	@:op(a + b)
	public static inline function add(a:FourVector, b:FourVector):FourVector {
		return cast((cast a : Blade4) + (cast b : Blade4));
	}

	@:op(a - b)
	public static inline function sub(a:FourVector, b:FourVector):FourVector {
		return cast((cast a : Blade4) - (cast b : Blade4));
	}

	@:op(a * b)
	@:commutative
	public static inline function scale(a:FourVector, s:Float):FourVector {
		return cast((cast a : Blade4) * s);
	}

	@:op(-a)
	public static inline function neg(a:FourVector):FourVector {
		return cast(-(cast a : Blade4));
	}
}

/** Shorthand for 4-vector */
inline function fourVector(v0:Float, v1:Float, v2:Float, v3:Float):FourVector {
	return new FourVector(v0, v1, v2, v3);
}

/** Shorthand for 4-velocity from 3-velocity */
inline function fourVelocity(vx:Float, vy:Float, vz:Float):FourVector {
	return FourVector.velocity(vx, vy, vz);
}

/** Shorthand for 4-momentum */
inline function fourMomentum(mass:Float, vx:Float, vy:Float, vz:Float):FourVector {
	return FourVector.momentum(mass, vx, vy, vz);
}
