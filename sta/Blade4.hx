package sta;

import VectorMath;

/**
 * Blade4 - Spacetime Algebra (STA) - G(1,3,0)
 *
 * Metric signature: (+,-,-,-) "east coast" / particle physics convention
 *   e0² = +1 (timelike)
 *   e1² = e2² = e3² = -1 (spacelike)
 *
 * 16 basis elements:
 *   Grade 0: 1 (scalar)
 *   Grade 1: e0, e1, e2, e3 (vectors - 4-velocity, 4-momentum)
 *   Grade 2: e01, e02, e03, e12, e23, e31 (bivectors - EM field, Lorentz generators)
 *   Grade 3: e012, e023, e031, e123 (trivectors - pseudovectors)
 *   Grade 4: e0123 (pseudoscalar)
 *
 * Physical interpretations:
 *   - Vectors: spacetime events, 4-velocity, 4-momentum, 4-current
 *   - Bivectors: electromagnetic field F = E + IcB, Lorentz generators
 *   - Even subalgebra: Lorentz rotors (boosts and rotations)
 *
 * The bivector split:
 *   - e01, e02, e03: boost generators (time-space planes)
 *   - e12, e23, e31: rotation generators (space-space planes)
 *
 * References:
 *   - Doran & Lasenby, "Geometric Algebra for Physicists"
 *   - Hestenes, "Space-Time Algebra"
 */
@:nullSafety
abstract Blade4(Blade4Data) to Blade4Data from Blade4Data {
	// Numerical tolerance for comparisons
	public static inline var EPSILON:Float = 1e-10;

	// Component accessors - using gamma notation internally
	public var s(get, set):Float; // scalar (grade 0)
	public var e0(get, set):Float; // time component (grade 1)
	public var e1(get, set):Float; // space components (grade 1)
	public var e2(get, set):Float;
	public var e3(get, set):Float;
	public var e01(get, set):Float; // boost bivectors (grade 2)
	public var e02(get, set):Float;
	public var e03(get, set):Float;
	public var e12(get, set):Float; // rotation bivectors (grade 2)
	public var e23(get, set):Float;
	public var e31(get, set):Float;
	public var e012(get, set):Float; // trivectors (grade 3)
	public var e023(get, set):Float;
	public var e031(get, set):Float;
	public var e123(get, set):Float;
	public var e0123(get, set):Float; // pseudoscalar (grade 4)

	inline function get_s():Float
		return this.s;

	inline function set_s(v:Float):Float
		return this.s = v;

	inline function get_e0():Float
		return this.e0;

	inline function set_e0(v:Float):Float
		return this.e0 = v;

	inline function get_e1():Float
		return this.e1;

	inline function set_e1(v:Float):Float
		return this.e1 = v;

	inline function get_e2():Float
		return this.e2;

	inline function set_e2(v:Float):Float
		return this.e2 = v;

	inline function get_e3():Float
		return this.e3;

	inline function set_e3(v:Float):Float
		return this.e3 = v;

	inline function get_e01():Float
		return this.e01;

	inline function set_e01(v:Float):Float
		return this.e01 = v;

	inline function get_e02():Float
		return this.e02;

	inline function set_e02(v:Float):Float
		return this.e02 = v;

	inline function get_e03():Float
		return this.e03;

	inline function set_e03(v:Float):Float
		return this.e03 = v;

	inline function get_e12():Float
		return this.e12;

	inline function set_e12(v:Float):Float
		return this.e12 = v;

	inline function get_e23():Float
		return this.e23;

	inline function set_e23(v:Float):Float
		return this.e23 = v;

	inline function get_e31():Float
		return this.e31;

	inline function set_e31(v:Float):Float
		return this.e31 = v;

	inline function get_e012():Float
		return this.e012;

	inline function set_e012(v:Float):Float
		return this.e012 = v;

	inline function get_e023():Float
		return this.e023;

	inline function set_e023(v:Float):Float
		return this.e023 = v;

	inline function get_e031():Float
		return this.e031;

	inline function set_e031(v:Float):Float
		return this.e031 = v;

	inline function get_e123():Float
		return this.e123;

	inline function set_e123(v:Float):Float
		return this.e123 = v;

	inline function get_e0123():Float
		return this.e0123;

	inline function set_e0123(v:Float):Float
		return this.e0123 = v;

	// ==================== Constructors ====================

	public inline function new(s:Float, e0:Float, e1:Float, e2:Float, e3:Float, e01:Float, e02:Float, e03:Float, e12:Float, e23:Float, e31:Float, e012:Float,
			e023:Float, e031:Float, e123:Float, e0123:Float) {
		this = new Blade4Data(s, e0, e1, e2, e3, e01, e02, e03, e12, e23, e31, e012, e023, e031, e123, e0123);
	}

	/** Zero multivector */
	public static inline function zero():Blade4 {
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Unit scalar (multiplicative identity) */
	public static inline function one():Blade4 {
		return new Blade4(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Scalar multivector */
	public static inline function scalar(s:Float):Blade4 {
		return new Blade4(s, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	// ==================== Physical Object Constructors ====================

	/** Create a spacetime vector (4-vector).
	 *  Convention: (t, x, y, z) where t is time component.
	 */
	public static inline function vector(t:Float, x:Float, y:Float, z:Float):Blade4 {
		return new Blade4(0, t, x, y, z, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a spacetime event at (t, x, y, z) */
	public static inline function event(t:Float, x:Float, y:Float, z:Float):Blade4 {
		return vector(t, x, y, z);
	}

	/** Create a 4-velocity from 3-velocity (normalized to unit timelike) */
	public static function fourVelocity(vx:Float, vy:Float, vz:Float):Blade4 {
		// v² = vx² + vy² + vz² (in units where c=1)
		var v2 = vx * vx + vy * vy + vz * vz;
		if (v2 >= 1.0)
			v2 = 1.0 - EPSILON; // Clamp to subluminal
		var gamma = 1.0 / Math.sqrt(1.0 - v2);
		return new Blade4(0, gamma, gamma * vx, gamma * vy, gamma * vz, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a pure spatial vector (3-vector embedded in spacetime) */
	public static inline function spatial(x:Float, y:Float, z:Float):Blade4 {
		return new Blade4(0, 0, x, y, z, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a pure time vector */
	public static inline function temporal(t:Float):Blade4 {
		return new Blade4(0, t, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a bivector from electric and magnetic field components.
	 *  F = E + IB where I = e0123 is the pseudoscalar.
	 *  E field: (Ex, Ey, Ez) stored in (e01, e02, e03)
	 *  B field: (Bx, By, Bz) stored in (e23, e31, e12)
	 */
	public static inline function emField(ex:Float, ey:Float, ez:Float, bx:Float, by:Float, bz:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, ex, ey, ez, bz, bx, by, 0, 0, 0, 0, 0);
	}

	/** Create a pure electric field bivector */
	public static inline function electricField(ex:Float, ey:Float, ez:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, ex, ey, ez, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a pure magnetic field bivector */
	public static inline function magneticField(bx:Float, by:Float, bz:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, bz, bx, by, 0, 0, 0, 0, 0);
	}

	// ==================== Basis Elements ====================

	/** Time basis vector γ0 */
	public static var GAMMA0(get, never):Blade4;

	static inline function get_GAMMA0():Blade4
		return new Blade4(0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Space basis vectors γ1, γ2, γ3 */
	public static var GAMMA1(get, never):Blade4;

	static inline function get_GAMMA1():Blade4
		return new Blade4(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	public static var GAMMA2(get, never):Blade4;

	static inline function get_GAMMA2():Blade4
		return new Blade4(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	public static var GAMMA3(get, never):Blade4;

	static inline function get_GAMMA3():Blade4
		return new Blade4(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Pseudoscalar I = γ0γ1γ2γ3 */
	public static var I(get, never):Blade4;

	static inline function get_I():Blade4
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

	// ==================== Grade Extraction ====================

	/** Extract scalar (grade 0) */
	public inline function grade0():Float {
		return s;
	}

	/** Extract vector (grade 1) as (t, x, y, z) */
	public inline function grade1():Vec4 {
		return vec4(e0, e1, e2, e3);
	}

	/** Extract spatial part of vector */
	public inline function spatial3():Vec3 {
		return vec3(e1, e2, e3);
	}

	/** Extract time part of vector */
	public inline function time():Float {
		return e0;
	}

	/** Extract bivector (grade 2) */
	public inline function grade2():{e01:Float, e02:Float, e03:Float, e12:Float, e23:Float, e31:Float} {
		return {e01: e01, e02: e02, e03: e03, e12: e12, e23: e23, e31: e31};
	}

	/** Extract electric field from bivector (e01, e02, e03) */
	public inline function electricPart():Vec3 {
		return vec3(e01, e02, e03);
	}

	/** Extract magnetic field from bivector (e23, e31, e12) */
	public inline function magneticPart():Vec3 {
		return vec3(e23, e31, e12);
	}

	/** Extract trivector (grade 3) */
	public inline function grade3():Vec4 {
		return vec4(e012, e023, e031, e123);
	}

	/** Extract pseudoscalar (grade 4) */
	public inline function grade4():Float {
		return e0123;
	}

	// ==================== Geometric Product ====================

	/** Full geometric product for STA metric (+,-,-,-).
	 *  e0² = +1, e1² = e2² = e3² = -1
	 */
	@:op(a * b)
	public static function mul(a:Blade4, b:Blade4):Blade4 {
		// Metric: e0²=+1, e1²=e2²=e3²=-1
		// Bivector squares: e01²=e02²=e03²=+1 (boost), e12²=e23²=e31²=-1 (rotation)
		// Trivector squares: e012²=e023²=e031²=-1, e123²=+1
		// Pseudoscalar: e0123²=-1
		return new Blade4(
			// s (scalar)
			a.s * b.s + a.e0 * b.e0 - a.e1 * b.e1 - a.e2 * b.e2 - a.e3 * b.e3 + a.e01 * b.e01 + a.e02 * b.e02 + a.e03 * b.e03 - a.e12 * b.e12 - a.e23 * b.e23 -
			a.e31 * b.e31 - a.e012 * b.e012 - a.e023 * b.e023 - a.e031 * b.e031 + a.e123 * b.e123 - a.e0123 * b.e0123,
			// e0
			a.s * b.e0 + a.e0 * b.s - a.e1 * b.e01 - a.e2 * b.e02 - a.e3 * b.e03 + a.e01 * b.e1 + a.e02 * b.e2 + a.e03 * b.e3 + a.e12 * b.e012 + a.e23 * b.e023 +
			a.e31 * b.e031 + a.e012 * b.e12 + a.e023 * b.e23 + a.e031 * b.e31 + a.e123 * b.e0123 - a.e0123 * b.e123,
			// e1
			a.s * b.e1 + a.e0 * b.e01 + a.e1 * b.s - a.e2 * b.e12 + a.e3 * b.e31 - a.e01 * b.e0 - a.e02 * b.e012 + a.e03 * b.e031 + a.e12 * b.e2 + a.e23 * b.e123 -
			a.e31 * b.e3 - a.e012 * b.e02 + a.e023 * b.e0123 + a.e031 * b.e03 + a.e123 * b.e23 - a.e0123 * b.e023,
			// e2
			a.s * b.e2 + a.e0 * b.e02 + a.e1 * b.e12 + a.e2 * b.s - a.e3 * b.e23 + a.e01 * b.e012 - a.e02 * b.e0 - a.e03 * b.e023 - a.e12 * b.e1 + a.e23 * b.e3 +
			a.e31 * b.e123 + a.e012 * b.e01 - a.e023 * b.e03 + a.e031 * b.e0123 + a.e123 * b.e31 - a.e0123 * b.e031,
			// e3
			a.s * b.e3 + a.e0 * b.e03 - a.e1 * b.e31 + a.e2 * b.e23 + a.e3 * b.s - a.e01 * b.e031 + a.e02 * b.e023 - a.e03 * b.e0 + a.e12 * b.e123 - a.e23 * b.e2 +
			a.e31 * b.e1 + a.e012 * b.e0123 + a.e023 * b.e02 - a.e031 * b.e01 + a.e123 * b.e12 - a.e0123 * b.e012,
			// e01
			a.s * b.e01 + a.e0 * b.e1 - a.e1 * b.e0 + a.e2 * b.e012 - a.e3 * b.e031 + a.e01 * b.s + a.e02 * b.e12 - a.e03 * b.e31 + a.e12 * b.e02 - a.e23 * b.e0123 -
			a.e31 * b.e03 + a.e012 * b.e2 - a.e023 * b.e123 - a.e031 * b.e3 - a.e123 * b.e023 + a.e0123 * b.e23,
			// e02
			a.s * b.e02 + a.e0 * b.e2 - a.e1 * b.e012 - a.e2 * b.e0 + a.e3 * b.e023 - a.e01 * b.e12 + a.e02 * b.s + a.e03 * b.e23 - a.e12 * b.e01 - a.e23 * b.e03 +
			a.e31 * b.e0123 - a.e012 * b.e1 + a.e023 * b.e3 - a.e031 * b.e123 - a.e123 * b.e031 + a.e0123 * b.e31,
			// e03
			a.s * b.e03 + a.e0 * b.e3 + a.e1 * b.e031 - a.e2 * b.e023 - a.e3 * b.e0 + a.e01 * b.e31 - a.e02 * b.e23 + a.e03 * b.s + a.e12 * b.e0123 + a.e23 * b.e02 -
			a.e31 * b.e01 - a.e012 * b.e123 - a.e023 * b.e2 + a.e031 * b.e1 - a.e123 * b.e012 + a.e0123 * b.e12,
			// e12
			a.s * b.e12 + a.e0 * b.e012 + a.e1 * b.e2 - a.e2 * b.e1 - a.e3 * b.e123 + a.e01 * b.e02 - a.e02 * b.e01 + a.e03 * b.e0123 + a.e12 * b.s + a.e23 * b.e31 -
			a.e31 * b.e23 + a.e012 * b.e0 + a.e023 * b.e031 - a.e031 * b.e023 - a.e123 * b.e3 + a.e0123 * b.e03,
			// e23
			a.s * b.e23 + a.e0 * b.e023 + a.e1 * b.e123 + a.e2 * b.e3 - a.e3 * b.e2 - a.e01 * b.e0123 + a.e02 * b.e03 - a.e03 * b.e02 - a.e12 * b.e31 + a.e23 * b.s +
			a.e31 * b.e12 - a.e012 * b.e031 + a.e023 * b.e0 + a.e031 * b.e012 - a.e123 * b.e1 + a.e0123 * b.e01,
			// e31
			a.s * b.e31 + a.e0 * b.e031 + a.e1 * b.e3 + a.e2 * b.e123 - a.e3 * b.e1 + a.e01 * b.e03 + a.e02 * b.e0123 - a.e03 * b.e01 + a.e12 * b.e23 - a.e23 * b.e12 +
			a.e31 * b.s + a.e012 * b.e023 - a.e023 * b.e012 + a.e031 * b.e0 - a.e123 * b.e2 + a.e0123 * b.e02,
			// e012
			a.s * b.e012 + a.e0 * b.e12 + a.e1 * b.e02 - a.e2 * b.e01 - a.e3 * b.e0123 + a.e01 * b.e2 - a.e02 * b.e1 - a.e03 * b.e123 + a.e12 * b.e0 + a.e23 * b.e031 -
			a.e31 * b.e023 + a.e012 * b.s - a.e023 * b.e31 + a.e031 * b.e23 - a.e123 * b.e03 + a.e0123 * b.e3,
			// e023
			a.s * b.e023 + a.e0 * b.e23 + a.e1 * b.e0123 + a.e2 * b.e03 - a.e3 * b.e02 + a.e01 * b.e123 + a.e02 * b.e3 - a.e03 * b.e2 - a.e12 * b.e031 + a.e23 * b.e0 +
			a.e31 * b.e012 + a.e012 * b.e31 + a.e023 * b.s - a.e031 * b.e12 + a.e123 * b.e01 + a.e0123 * b.e1,
			// e031
			a.s * b.e031 + a.e0 * b.e31 + a.e1 * b.e03 + a.e2 * b.e0123 - a.e3 * b.e01 + a.e01 * b.e3 - a.e02 * b.e123 - a.e03 * b.e1 + a.e12 * b.e023 + a.e23 * b.e012 +
			a.e31 * b.e0 - a.e012 * b.e23 + a.e023 * b.e12 + a.e031 * b.s - a.e123 * b.e02 + a.e0123 * b.e2,
			// e123
			a.s * b.e123 + a.e0 * b.e0123 + a.e1 * b.e23 + a.e2 * b.e31 + a.e3 * b.e12 - a.e01 * b.e023 - a.e02 * b.e031 - a.e03 * b.e012 + a.e12 * b.e3 + a.e23 * b.e1 +
			a.e31 * b.e2 + a.e012 * b.e03 + a.e023 * b.e01 + a.e031 * b.e02 + a.e123 * b.s - a.e0123 * b.e0,
			// e0123
			a.s * b.e0123 + a.e0 * b.e123 - a.e1 * b.e023 - a.e2 * b.e031 - a.e3 * b.e012 + a.e01 * b.e23 + a.e02 * b.e31 + a.e03 * b.e12 - a.e12 * b.e03 -
			a.e23 * b.e01 - a.e31 * b.e02 + a.e012 * b.e3 + a.e023 * b.e1 + a.e031 * b.e2 - a.e123 * b.e0 + a.e0123 * b.s);
	}

	// ==================== Wedge Product ====================

	/** Wedge (outer) product */
	public function wedge(b:Blade4):Blade4 {
		return new Blade4(
			// s
			s * b.s,
			// e0
			s * b.e0 + e0 * b.s,
			// e1
			s * b.e1 + e1 * b.s,
			// e2
			s * b.e2 + e2 * b.s,
			// e3
			s * b.e3 + e3 * b.s,
			// e01
			s * b.e01 + e0 * b.e1 - e1 * b.e0 + e01 * b.s,
			// e02
			s * b.e02 + e0 * b.e2 - e2 * b.e0 + e02 * b.s,
			// e03
			s * b.e03 + e0 * b.e3 - e3 * b.e0 + e03 * b.s,
			// e12
			s * b.e12 + e1 * b.e2 - e2 * b.e1 + e12 * b.s,
			// e23
			s * b.e23 + e2 * b.e3 - e3 * b.e2 + e23 * b.s,
			// e31
			s * b.e31 + e3 * b.e1 - e1 * b.e3 + e31 * b.s,
			// e012
			s * b.e012 + e0 * b.e12 + e1 * b.e02 - e2 * b.e01 - e01 * b.e2 + e02 * b.e1 + e12 * b.e0 + e012 * b.s,
			// e023
			s * b.e023 + e0 * b.e23 + e2 * b.e03 - e3 * b.e02 - e02 * b.e3 + e03 * b.e2 + e23 * b.e0 + e023 * b.s,
			// e031
			s * b.e031 + e0 * b.e31 + e3 * b.e01 - e1 * b.e03 - e03 * b.e1 + e01 * b.e3 + e31 * b.e0 + e031 * b.s,
			// e123
			s * b.e123 + e1 * b.e23 + e2 * b.e31 + e3 * b.e12 + e12 * b.e3 + e23 * b.e1 + e31 * b.e2 + e123 * b.s,
			// e0123
			s * b.e0123 + e0 * b.e123 + e1 * b.e023 + e2 * b.e031 + e3 * b.e012 + e01 * b.e23 + e02 * b.e31 + e03 * b.e12 + e12 * b.e03 + e23 * b.e01 + e31 * b.e02 +
			e012 * b.e3 + e023 * b.e1 + e031 * b.e2 + e123 * b.e0 + e0123 * b.s);
	}

	// ==================== Inner Product ====================

	/** Left contraction (inner product) */
	public function dot(b:Blade4):Blade4 {
		// Metric: e0²=+1, e1²=e2²=e3²=-1
		return new Blade4(
			// s
			s * b.s + e0 * b.e0 - e1 * b.e1 - e2 * b.e2 - e3 * b.e3 - e01 * b.e01 - e02 * b.e02 - e03 * b.e03 + e12 * b.e12 + e23 * b.e23 + e31 * b.e31 -
			e012 * b.e012 - e023 * b.e023 - e031 * b.e031 + e123 * b.e123 + e0123 * b.e0123,
			// e0
			s * b.e0 - e1 * b.e01 - e2 * b.e02 - e3 * b.e03 - e12 * b.e012 - e23 * b.e023 - e31 * b.e031 + e123 * b.e0123,
			// e1
			s * b.e1 + e0 * b.e01 - e2 * b.e12 + e3 * b.e31 + e02 * b.e012 - e03 * b.e031 - e23 * b.e123 + e023 * b.e0123,
			// e2
			s * b.e2 + e0 * b.e02 + e1 * b.e12 - e3 * b.e23 - e01 * b.e012 + e03 * b.e023 - e31 * b.e123 + e031 * b.e0123,
			// e3
			s * b.e3 + e0 * b.e03 - e1 * b.e31 + e2 * b.e23 + e01 * b.e031 - e02 * b.e023 - e12 * b.e123 + e012 * b.e0123,
			// e01
			s * b.e01 - e2 * b.e012 + e3 * b.e031 + e23 * b.e0123,
			// e02
			s * b.e02 + e1 * b.e012 - e3 * b.e023 + e31 * b.e0123,
			// e03
			s * b.e03 - e1 * b.e031 + e2 * b.e023 + e12 * b.e0123,
			// e12
			s * b.e12 + e0 * b.e012 + e3 * b.e123 - e03 * b.e0123,
			// e23
			s * b.e23 + e0 * b.e023 + e1 * b.e123 + e01 * b.e0123,
			// e31
			s * b.e31 + e0 * b.e031 + e2 * b.e123 + e02 * b.e0123,
			// e012
			s * b.e012 + e3 * b.e0123,
			// e023
			s * b.e023 + e1 * b.e0123,
			// e031
			s * b.e031 + e2 * b.e0123,
			// e123
			s * b.e123 + e0 * b.e0123,
			// e0123
			s * b.e0123);
	}

	// ==================== Involutions ====================

	/** Reverse: reverses the order of basis vectors.
	 *  Flips sign for grades 2, 3.
	 */
	public inline function reverse():Blade4 {
		return new Blade4(s, e0, e1, e2, e3, -e01, -e02, -e03, -e12, -e23, -e31, -e012, -e023, -e031, -e123, e0123);
	}

	/** Grade involution: flips sign of odd grades (1, 3) */
	public inline function involute():Blade4 {
		return new Blade4(s, -e0, -e1, -e2, -e3, e01, e02, e03, e12, e23, e31, -e012, -e023, -e031, -e123, e0123);
	}

	/** Clifford conjugate: reverse ∘ involute */
	public inline function conjugate():Blade4 {
		return new Blade4(s, -e0, -e1, -e2, -e3, -e01, -e02, -e03, -e12, -e23, -e31, e012, e023, e031, e123, e0123);
	}

	// ==================== Dual ====================

	/** Dual: multiplication by pseudoscalar inverse.
	 *  In STA with (+,-,-,-), I² = -1, so dual(a) = a * I⁻¹ = -a * I
	 */
	public inline function dual():Blade4 {
		// I = e0123, I² = e0²e1²e2²e3² = 1*(-1)*(-1)*(-1) = -1
		// I⁻¹ = -I
		// dual(a) = a * (-I) = -a * I
		return new Blade4(-e0123, -e123, e023, e031, e012, -e23, -e31, -e12, e03, e01, e02, -e3, -e1, -e2, e0, -s);
	}

	// ==================== Norms ====================

	/** Squared magnitude (can be positive, negative, or zero).
	 *  For vectors: positive = timelike, negative = spacelike, zero = lightlike
	 */
	public inline function normSquared():Float {
		return s * s + e0 * e0 - e1 * e1 - e2 * e2 - e3 * e3;
	}

	/** Magnitude (real for timelike, imaginary for spacelike - returns |norm|) */
	public inline function norm():Float {
		var n2 = normSquared();
		return Math.sqrt(Math.abs(n2));
	}

	/** Is this a timelike vector? (positive norm²) */
	public inline function isTimelike():Bool {
		return normSquared() > EPSILON;
	}

	/** Is this a spacelike vector? (negative norm²) */
	public inline function isSpacelike():Bool {
		return normSquared() < -EPSILON;
	}

	/** Is this a lightlike/null vector? (zero norm²) */
	public inline function isLightlike():Bool {
		return Math.abs(normSquared()) < EPSILON;
	}

	// ==================== Lorentz Transformations ====================

	// Hyperbolic functions (not in Haxe std Math)
	static inline function cosh(x:Float):Float {
		var ex = Math.exp(x);
		return (ex + 1.0 / ex) * 0.5;
	}

	static inline function sinh(x:Float):Float {
		var ex = Math.exp(x);
		return (ex - 1.0 / ex) * 0.5;
	}

	/** Create a boost rotor in direction (nx, ny, nz) with rapidity φ.
	 *  Rapidity relates to velocity by: v = tanh(φ), γ = cosh(φ)
	 *  Rotor: R = exp(-φ/2 * n·σ) = cosh(φ/2) - sinh(φ/2) * (nx*e01 + ny*e02 + nz*e03)
	 */
	public static function boost(nx:Float, ny:Float, nz:Float, rapidity:Float):Blade4 {
		var len = Math.sqrt(nx * nx + ny * ny + nz * nz);
		if (len < EPSILON)
			return one();
		nx /= len;
		ny /= len;
		nz /= len;

		var halfPhi = rapidity * 0.5;
		var c = cosh(halfPhi);
		var s = sinh(halfPhi);

		return new Blade4(c, 0, 0, 0, 0, -s * nx, -s * ny, -s * nz, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a boost from 3-velocity (vx, vy, vz) where |v| < 1 (c=1 units) */
	public static function boostFromVelocity(vx:Float, vy:Float, vz:Float):Blade4 {
		var v2 = vx * vx + vy * vy + vz * vz;
		if (v2 < EPSILON)
			return one();
		if (v2 >= 1.0)
			v2 = 1.0 - EPSILON;

		var v = Math.sqrt(v2);
		var rapidity = 0.5 * Math.log((1 + v) / (1 - v)); // arctanh(v)

		return boost(vx / v, vy / v, vz / v, rapidity);
	}

	/** Create a spatial rotation rotor around axis (nx, ny, nz) by angle θ.
	 *  Rotor: R = exp(-θ/2 * n·B) = cos(θ/2) - sin(θ/2) * (nx*e23 + ny*e31 + nz*e12)
	 */
	public static function rotation(nx:Float, ny:Float, nz:Float, angle:Float):Blade4 {
		var len = Math.sqrt(nx * nx + ny * ny + nz * nz);
		if (len < EPSILON)
			return one();
		nx /= len;
		ny /= len;
		nz /= len;

		var halfAngle = angle * 0.5;
		var c = Math.cos(halfAngle);
		var s = Math.sin(halfAngle);

		return new Blade4(c, 0, 0, 0, 0, 0, 0, 0, -s * nz, -s * nx, -s * ny, 0, 0, 0, 0, 0);
	}

	/** Apply Lorentz rotor to a vector: v' = R v R̃ */
	public inline function transform(v:Blade4):Blade4 {
		return mul(mul(this, v), reverse());
	}

	// ==================== Arithmetic ====================

	@:op(a + b)
	public static inline function add(a:Blade4, b:Blade4):Blade4 {
		return new Blade4(a.s + b.s, a.e0 + b.e0, a.e1 + b.e1, a.e2 + b.e2, a.e3 + b.e3, a.e01 + b.e01, a.e02 + b.e02, a.e03 + b.e03, a.e12 + b.e12, a.e23 + b.e23,
			a.e31 + b.e31, a.e012 + b.e012, a.e023 + b.e023, a.e031 + b.e031, a.e123 + b.e123, a.e0123 + b.e0123);
	}

	@:op(a - b)
	public static inline function sub(a:Blade4, b:Blade4):Blade4 {
		return new Blade4(a.s - b.s, a.e0 - b.e0, a.e1 - b.e1, a.e2 - b.e2, a.e3 - b.e3, a.e01 - b.e01, a.e02 - b.e02, a.e03 - b.e03, a.e12 - b.e12, a.e23 - b.e23,
			a.e31 - b.e31, a.e012 - b.e012, a.e023 - b.e023, a.e031 - b.e031, a.e123 - b.e123, a.e0123 - b.e0123);
	}

	@:op(a * b)
	@:commutative
	public static inline function mulScalar(a:Blade4, s:Float):Blade4 {
		return new Blade4(a.s * s, a.e0 * s, a.e1 * s, a.e2 * s, a.e3 * s, a.e01 * s, a.e02 * s, a.e03 * s, a.e12 * s, a.e23 * s, a.e31 * s, a.e012 * s, a.e023 * s,
			a.e031 * s, a.e123 * s, a.e0123 * s);
	}

	@:op(a / b)
	public static inline function divScalar(a:Blade4, s:Float):Blade4 {
		return mulScalar(a, 1.0 / s);
	}

	@:op(-a)
	public static inline function neg(a:Blade4):Blade4 {
		return new Blade4(-a.s, -a.e0, -a.e1, -a.e2, -a.e3, -a.e01, -a.e02, -a.e03, -a.e12, -a.e23, -a.e31, -a.e012, -a.e023, -a.e031, -a.e123, -a.e0123);
	}

	@:op(a == b)
	public static inline function eq(a:Blade4, b:Blade4):Bool {
		return a.s == b.s && a.e0 == b.e0 && a.e1 == b.e1 && a.e2 == b.e2 && a.e3 == b.e3 && a.e01 == b.e01 && a.e02 == b.e02 && a.e03 == b.e03 && a.e12 == b.e12 &&
			a.e23 == b.e23 && a.e31 == b.e31 && a.e012 == b.e012 && a.e023 == b.e023 && a.e031 == b.e031 && a.e123 == b.e123 && a.e0123 == b.e0123;
	}

	@:op(a != b)
	public static inline function neq(a:Blade4, b:Blade4):Bool {
		return !(a == b);
	}

	// ==================== Extended Operators ====================

	@:op(a ^ b)
	public inline function opWedge(b:Blade4):Blade4 {
		return wedge(b);
	}

	@:op(a | b)
	public inline function opInner(b:Blade4):Blade4 {
		return dot(b);
	}

	@:op(~a)
	public static inline function opReverse(a:Blade4):Blade4 {
		return a.reverse();
	}

	@:op(!a)
	public static inline function opDual(a:Blade4):Blade4 {
		return a.dual();
	}
}

/** Data class for STA Blade4 - stores 16 components */
@:noCompletion
class Blade4Data {
	public var s:Float; // scalar
	public var e0:Float; // time (grade 1)
	public var e1:Float; // space (grade 1)
	public var e2:Float;
	public var e3:Float;
	public var e01:Float; // boost bivectors (grade 2)
	public var e02:Float;
	public var e03:Float;
	public var e12:Float; // rotation bivectors (grade 2)
	public var e23:Float;
	public var e31:Float;
	public var e012:Float; // trivectors (grade 3)
	public var e023:Float;
	public var e031:Float;
	public var e123:Float;
	public var e0123:Float; // pseudoscalar (grade 4)

	public inline function new(s:Float, e0:Float, e1:Float, e2:Float, e3:Float, e01:Float, e02:Float, e03:Float, e12:Float, e23:Float, e31:Float, e012:Float,
			e023:Float, e031:Float, e123:Float, e0123:Float) {
		this.s = s;
		this.e0 = e0;
		this.e1 = e1;
		this.e2 = e2;
		this.e3 = e3;
		this.e01 = e01;
		this.e02 = e02;
		this.e03 = e03;
		this.e12 = e12;
		this.e23 = e23;
		this.e31 = e31;
		this.e012 = e012;
		this.e023 = e023;
		this.e031 = e031;
		this.e123 = e123;
		this.e0123 = e0123;
	}
}
