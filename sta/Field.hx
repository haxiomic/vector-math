package sta;

import VectorMath;

/**
 * Electromagnetic field tensor as a bivector.
 *
 * F = E + IB where I is the pseudoscalar.
 * In components: F = Ex e01 + Ey e02 + Ez e03 + Bx e23 + By e31 + Bz e12
 *
 * The electric field lives in time-space bivectors (e01, e02, e03).
 * The magnetic field lives in space-space bivectors (e23, e31, e12).
 */
@:nullSafety
abstract Field(Blade4) from Blade4 to Blade4 {
	/** Create EM field from E and B vectors */
	public inline function new(ex:Float, ey:Float, ez:Float, bx:Float, by:Float, bz:Float) {
		this = Blade4.emField(ex, ey, ez, bx, by, bz);
	}

	/** Zero field */
	public static inline function zero():Field {
		return new Field(0, 0, 0, 0, 0, 0);
	}

	/** Pure electric field */
	public static inline function electric(ex:Float, ey:Float, ez:Float):Field {
		return new Field(ex, ey, ez, 0, 0, 0);
	}

	/** Electric field from Vec3 */
	public static inline function electricVec(e:Vec3):Field {
		return electric(e.x, e.y, e.z);
	}

	/** Pure magnetic field */
	public static inline function magnetic(bx:Float, by:Float, bz:Float):Field {
		return new Field(0, 0, 0, bx, by, bz);
	}

	/** Magnetic field from Vec3 */
	public static inline function magneticVec(b:Vec3):Field {
		return magnetic(b.x, b.y, b.z);
	}

	/** Create from E and B Vec3s */
	public static inline function fromEB(e:Vec3, b:Vec3):Field {
		return new Field(e.x, e.y, e.z, b.x, b.y, b.z);
	}

	/** Get electric field as Vec3 (creates new Vec3) */
	public inline function getE():Vec3 {
		return this.electricPart();
	}

	/** Get magnetic field as Vec3 (creates new Vec3) */
	public inline function getB():Vec3 {
		return this.magneticPart();
	}

	/** Electric field x component */
	public var Ex(get, never):Float;

	inline function get_Ex():Float
		return this.e01;

	/** Electric field y component */
	public var Ey(get, never):Float;

	inline function get_Ey():Float
		return this.e02;

	/** Electric field z component */
	public var Ez(get, never):Float;

	inline function get_Ez():Float
		return this.e03;

	/** Magnetic field x component */
	public var Bx(get, never):Float;

	inline function get_Bx():Float
		return this.e23;

	/** Magnetic field y component */
	public var By(get, never):Float;

	inline function get_By():Float
		return this.e31;

	/** Magnetic field z component */
	public var Bz(get, never):Float;

	inline function get_Bz():Float
		return this.e12;

	/** First Lorentz invariant: F·F = 2(B² - E²) */
	public inline function invariant1():Float {
		var e2 = this.e01 * this.e01 + this.e02 * this.e02 + this.e03 * this.e03;
		var b2 = this.e12 * this.e12 + this.e23 * this.e23 + this.e31 * this.e31;
		return 2 * (b2 - e2);
	}

	/** Second Lorentz invariant: F∧F (proportional to E·B) */
	public inline function invariant2():Float {
		return 2 * (this.e01 * this.e23 + this.e02 * this.e31 + this.e03 * this.e12);
	}

	/** Energy density: (E² + B²) / 2 */
	public inline function energyDensity():Float {
		var e2 = this.e01 * this.e01 + this.e02 * this.e02 + this.e03 * this.e03;
		var b2 = this.e12 * this.e12 + this.e23 * this.e23 + this.e31 * this.e31;
		return (e2 + b2) * 0.5;
	}

	/** Poynting vector: S = E × B (energy flux, creates new Vec3) */
	public inline function getPoyntingVector():Vec3 {
		var e = getE();
		var b = getB();
		return vec3(e.y * b.z - e.z * b.y, e.z * b.x - e.x * b.z, e.x * b.y - e.y * b.x);
	}

	/** Hodge dual: *F swaps E and B (with sign) */
	public inline function dual():Field {
		// *F has E' = B, B' = -E
		return new Field(this.e23, this.e31, this.e12, -this.e01, -this.e02, -this.e03);
	}

	@:op(a + b)
	public static inline function add(a:Field, b:Field):Field {
		return cast((cast a : Blade4) + (cast b : Blade4));
	}

	@:op(a - b)
	public static inline function sub(a:Field, b:Field):Field {
		return cast((cast a : Blade4) - (cast b : Blade4));
	}

	@:op(a * b)
	@:commutative
	public static inline function scale(a:Field, s:Float):Field {
		return cast((cast a : Blade4) * s);
	}

	@:op(-a)
	public static inline function neg(a:Field):Field {
		return cast(-(cast a : Blade4));
	}
}

/** Shorthand for EM field */
inline function field(ex:Float, ey:Float, ez:Float, bx:Float, by:Float, bz:Float):Field {
	return new Field(ex, ey, ez, bx, by, bz);
}
