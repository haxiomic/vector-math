package pga;

import VectorMath;

/**
 * Blade4 - 4D Blade algebra (16 components)
 *
 * Low-level implementation for G(3,0,1) - 3D Projective Geometric Algebra (PGA).
 *
 * Metric signature: G(3,0,1) - three positive, one degenerate (null) generator
 *   e0² = 0 (degenerate - ideal/infinite direction)
 *   e1² = e2² = e3² = 1 (Euclidean)
 *
 * 16 basis elements:
 *   Grade 0: 1 (scalar)
 *   Grade 1: e0, e1, e2, e3 (planes)
 *   Grade 2: e01, e02, e03, e23, e31, e12 (lines)
 *   Grade 3: e021, e013, e032, e123 (points)
 *   Grade 4: e0123 (pseudoscalar)
 *
 * Geometric interpretation:
 *   - Planes: grade 1 (ax + by + cz + d = 0 as d*e0 + a*e1 + b*e2 + c*e3)
 *   - Lines: grade 2 (Plücker coordinates)
 *   - Points: grade 3 (homogeneous coordinates)
 *
 * The even subalgebra is isomorphic to dual quaternions.
 *
 * References:
 *   - bivector.net/3DPGA.pdf
 *   - Klein library (github.com/jeremyong/klein)
 *   - Gunn, "Geometric Algebra for Computer Graphics"
 *
 * @see PGA3 for the higher-level API
 */
@:nullSafety
abstract Blade4(Blade4Data) to Blade4Data from Blade4Data {
	// Numerical tolerance for comparisons
	public static inline var EPSILON:Float = 1e-6;

	// Component accessors
	public var s(get, set):Float; // scalar (grade 0)
	public var e0(get, set):Float; // plane components (grade 1)
	public var e1(get, set):Float;
	public var e2(get, set):Float;
	public var e3(get, set):Float;
	public var e01(get, set):Float; // line components (grade 2)
	public var e02(get, set):Float;
	public var e03(get, set):Float;
	public var e23(get, set):Float;
	public var e31(get, set):Float;
	public var e12(get, set):Float;
	public var e021(get, set):Float; // point components (grade 3)
	public var e013(get, set):Float;
	public var e032(get, set):Float;
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

	inline function get_e23():Float
		return this.e23;

	inline function set_e23(v:Float):Float
		return this.e23 = v;

	inline function get_e31():Float
		return this.e31;

	inline function set_e31(v:Float):Float
		return this.e31 = v;

	inline function get_e12():Float
		return this.e12;

	inline function set_e12(v:Float):Float
		return this.e12 = v;

	inline function get_e021():Float
		return this.e021;

	inline function set_e021(v:Float):Float
		return this.e021 = v;

	inline function get_e013():Float
		return this.e013;

	inline function set_e013(v:Float):Float
		return this.e013 = v;

	inline function get_e032():Float
		return this.e032;

	inline function set_e032(v:Float):Float
		return this.e032 = v;

	inline function get_e123():Float
		return this.e123;

	inline function set_e123(v:Float):Float
		return this.e123 = v;

	inline function get_e0123():Float
		return this.e0123;

	inline function set_e0123(v:Float):Float
		return this.e0123 = v;

	// ==================== Constructors ====================

	public inline function new(s:Float, e0:Float, e1:Float, e2:Float, e3:Float, e01:Float, e02:Float, e03:Float, e23:Float, e31:Float, e12:Float, e021:Float,
			e013:Float, e032:Float, e123:Float, e0123:Float) {
		this = new Blade4Data(s, e0, e1, e2, e3, e01, e02, e03, e23, e31, e12, e021, e013, e032, e123, e0123);
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

	// ==================== Geometric Object Constructors ====================

	/** Create a plane from equation ax + by + cz + d = 0.
	 *  The plane is represented as d*e0 + a*e1 + b*e2 + c*e3.
	 */
	public static inline function plane(a:Float, b:Float, c:Float, d:Float):Blade4 {
		return new Blade4(0, d, a, b, c, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a normalized plane from normal vector and distance from origin. */
	public static inline function planeFromNormalDist(normal:Vec3, dist:Float):Blade4 {
		var n = normal.normalize();
		return new Blade4(0, dist, n.x, n.y, n.z, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a plane through a point with given normal. */
	public static inline function planeFromPointNormal(point:Vec3, normal:Vec3):Blade4 {
		var n = normal.normalize();
		var d = -VectorMath.dot(n, point);
		return new Blade4(0, d, n.x, n.y, n.z, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a point at position (x, y, z).
	 *  In PGA, a finite point is: e123 + x*e032 + y*e013 + z*e021
	 */
	public static inline function point(x:Float, y:Float, z:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, z, y, x, 1, 0);
	}

	/** Shorthand for point */
	public static inline function pt(x:Float, y:Float, z:Float):Blade4 {
		return point(x, y, z);
	}

	/** Create a point from Vec3 */
	public static inline function pointFromVec3(v:Vec3):Blade4 {
		return point(v.x, v.y, v.z);
	}

	/** Create an ideal point (point at infinity) representing direction (x, y, z).
	 *  This is just the direction components without the e123 term.
	 */
	public static inline function direction(x:Float, y:Float, z:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, z, y, x, 0, 0);
	}

	/** Shorthand for direction (ideal point) */
	public static inline function dir(x:Float, y:Float, z:Float):Blade4 {
		return direction(x, y, z);
	}

	/** Create a line through the origin along direction (dx, dy, dz).
	 *  Line direction: dx*e23 + dy*e31 + dz*e12
	 */
	public static inline function lineThruOrigin(dx:Float, dy:Float, dz:Float):Blade4 {
		return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, dx, dy, dz, 0, 0, 0, 0, 0);
	}

	/** Create a line through point p in direction d.
	 *  Uses Plücker coordinates.
	 */
	public static inline function line(px:Float, py:Float, pz:Float, dx:Float, dy:Float, dz:Float):Blade4 {
		// Direction part
		var l = dx;
		var m = dy;
		var n = dz;
		// Moment part: p × d
		var mx = py * dz - pz * dy;
		var my = pz * dx - px * dz;
		var mz = px * dy - py * dx;
		return new Blade4(0, 0, 0, 0, 0, mx, my, mz, l, m, n, 0, 0, 0, 0, 0);
	}

	// ==================== Basis Elements ====================
	// Useful for building expressions: 2*Blade4.E1 + 3*Blade4.E2
	// Uppercase to distinguish from component accessors (e0, e1, etc.)

	/** Origin point (e123) */
	public static var ORIGIN(get, never):Blade4;
	static inline function get_ORIGIN():Blade4 return new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

	/** Basis plane e0 (ideal plane at infinity) */
	public static var E0(get, never):Blade4;
	static inline function get_E0():Blade4 return new Blade4(0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Basis plane e1 (x=0, yz-plane) */
	public static var E1(get, never):Blade4;
	static inline function get_E1():Blade4 return new Blade4(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Basis plane e2 (y=0, xz-plane) */
	public static var E2(get, never):Blade4;
	static inline function get_E2():Blade4 return new Blade4(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Basis plane e3 (z=0, xy-plane) */
	public static var E3(get, never):Blade4;
	static inline function get_E3():Blade4 return new Blade4(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	// ==================== Grade Extraction ====================

	/** Extract scalar (grade 0) */
	public inline function grade0():Float {
		return s;
	}

	/** Extract plane coefficients (grade 1) as (e0, e1, e2, e3) = (d, a, b, c) */
	public inline function grade1():Vec4 {
		return vec4(e0, e1, e2, e3);
	}

	/** Extract line bivector (grade 2) */
	public inline function grade2():{e01:Float, e02:Float, e03:Float, e23:Float, e31:Float, e12:Float} {
		return {e01: e01, e02: e02, e03: e03, e23: e23, e31: e31, e12: e12};
	}

	/** Extract point trivector (grade 3) */
	public inline function grade3():Vec4 {
		// Return as (e021, e013, e032, e123) = (z, y, x, w)
		return vec4(e021, e013, e032, e123);
	}

	/** Extract pseudoscalar (grade 4) */
	public inline function grade4():Float {
		return e0123;
	}

	/** Extract Euclidean point coordinates from trivector (normalizes by e123) */
	public inline function toPoint():Vec3 {
		var w = e123;
		if (Math.abs(w) < EPSILON)
			return vec3(e032, e013, e021); // Ideal point (direction)
		return vec3(e032 / w, e013 / w, e021 / w);
	}

	/** Extract plane equation coefficients (a, b, c, d) where ax + by + cz + d = 0 */
	public inline function toPlane():Vec4 {
		return vec4(e1, e2, e3, e0);
	}

	// ==================== Geometric Product ====================

	/** Full geometric product.
	 *  This is the fundamental operation in Geometric Algebra.
	 *  Computed using the metric: e0²=0, e1²=e2²=e3²=1
	 *  Generated using CliffordAlgebra module with correct sign handling for non-canonical blade naming.
	 */
	@:op(a * b)
	public static function mul(a:Blade4, b:Blade4):Blade4 {
		return new Blade4(
			// s
			a.s * b.s + a.e1 * b.e1 + a.e2 * b.e2 + a.e3 * b.e3 - a.e23 * b.e23 - a.e31 * b.e31 - a.e12 * b.e12 - a.e123 * b.e123,
			// e0
			a.s * b.e0 + a.e0 * b.s - a.e1 * b.e01 - a.e2 * b.e02 - a.e3 * b.e03 + a.e01 * b.e1 + a.e02 * b.e2 + a.e03 * b.e3 + a.e23 * b.e032 + a.e31 * b.e013 +
			a.e12 * b.e021 + a.e021 * b.e12 + a.e013 * b.e31 + a.e032 * b.e23 + a.e123 * b.e0123 - a.e0123 * b.e123,
			// e1
			a.s * b.e1 + a.e1 * b.s - a.e2 * b.e12 + a.e3 * b.e31 - a.e23 * b.e123 - a.e31 * b.e3 + a.e12 * b.e2 - a.e123 * b.e23,
			// e2
			a.s * b.e2 + a.e1 * b.e12 + a.e2 * b.s - a.e3 * b.e23 + a.e23 * b.e3 - a.e31 * b.e123 - a.e12 * b.e1 - a.e123 * b.e31,
			// e3
			a.s * b.e3 - a.e1 * b.e31 + a.e2 * b.e23 + a.e3 * b.s - a.e23 * b.e2 + a.e31 * b.e1 - a.e12 * b.e123 - a.e123 * b.e12,
			// e01
			a.s * b.e01 + a.e0 * b.e1 - a.e1 * b.e0 - a.e2 * b.e021 + a.e3 * b.e013 + a.e01 * b.s - a.e02 * b.e12 + a.e03 * b.e31 - a.e23 * b.e0123 - a.e31 * b.e03 +
			a.e12 * b.e02 - a.e021 * b.e2 + a.e013 * b.e3 + a.e032 * b.e123 - a.e123 * b.e032 - a.e0123 * b.e23,
			// e02
			a.s * b.e02 + a.e0 * b.e2 + a.e1 * b.e021 - a.e2 * b.e0 - a.e3 * b.e032 + a.e01 * b.e12 + a.e02 * b.s - a.e03 * b.e23 + a.e23 * b.e03 - a.e31 * b.e0123 -
			a.e12 * b.e01 + a.e021 * b.e1 + a.e013 * b.e123 - a.e032 * b.e3 - a.e123 * b.e013 - a.e0123 * b.e31,
			// e03
			a.s * b.e03 + a.e0 * b.e3 - a.e1 * b.e013 + a.e2 * b.e032 - a.e3 * b.e0 - a.e01 * b.e31 + a.e02 * b.e23 + a.e03 * b.s - a.e23 * b.e02 + a.e31 * b.e01 -
			a.e12 * b.e0123 + a.e021 * b.e123 - a.e013 * b.e1 + a.e032 * b.e2 - a.e123 * b.e021 - a.e0123 * b.e12,
			// e23
			a.s * b.e23 + a.e1 * b.e123 + a.e2 * b.e3 - a.e3 * b.e2 + a.e23 * b.s - a.e31 * b.e12 + a.e12 * b.e31 + a.e123 * b.e1,
			// e31
			a.s * b.e31 - a.e1 * b.e3 + a.e2 * b.e123 + a.e3 * b.e1 + a.e23 * b.e12 + a.e31 * b.s - a.e12 * b.e23 + a.e123 * b.e2,
			// e12
			a.s * b.e12 + a.e1 * b.e2 - a.e2 * b.e1 + a.e3 * b.e123 - a.e23 * b.e31 + a.e31 * b.e23 + a.e12 * b.s + a.e123 * b.e3,
			// e021
			a.s * b.e021 - a.e0 * b.e12 + a.e1 * b.e02 - a.e2 * b.e01 + a.e3 * b.e0123 - a.e01 * b.e2 + a.e02 * b.e1 - a.e03 * b.e123 - a.e23 * b.e013 +
			a.e31 * b.e032 - a.e12 * b.e0 + a.e021 * b.s + a.e013 * b.e23 - a.e032 * b.e31 + a.e123 * b.e03 - a.e0123 * b.e3,
			// e013
			a.s * b.e013 - a.e0 * b.e31 - a.e1 * b.e03 + a.e2 * b.e0123 + a.e3 * b.e01 + a.e01 * b.e3 - a.e02 * b.e123 - a.e03 * b.e1 + a.e23 * b.e021 -
			a.e31 * b.e0 - a.e12 * b.e032 - a.e021 * b.e23 + a.e013 * b.s + a.e032 * b.e12 + a.e123 * b.e02 - a.e0123 * b.e2,
			// e032
			a.s * b.e032 - a.e0 * b.e23 + a.e1 * b.e0123 + a.e2 * b.e03 - a.e3 * b.e02 - a.e01 * b.e123 - a.e02 * b.e3 + a.e03 * b.e2 - a.e23 * b.e0 -
			a.e31 * b.e021 + a.e12 * b.e013 + a.e021 * b.e31 - a.e013 * b.e12 + a.e032 * b.s + a.e123 * b.e01 - a.e0123 * b.e1,
			// e123
			a.s * b.e123 + a.e1 * b.e23 + a.e2 * b.e31 + a.e3 * b.e12 + a.e23 * b.e1 + a.e31 * b.e2 + a.e12 * b.e3 + a.e123 * b.s,
			// e0123
			a.s * b.e0123 + a.e0 * b.e123 + a.e1 * b.e032 + a.e2 * b.e013 + a.e3 * b.e021 + a.e01 * b.e23 + a.e02 * b.e31 + a.e03 * b.e12 + a.e23 * b.e01 +
			a.e31 * b.e02 + a.e12 * b.e03 - a.e021 * b.e3 - a.e013 * b.e2 - a.e032 * b.e1 - a.e123 * b.e0 + a.e0123 * b.s);
	}

	// ==================== Wedge Product (Join) ====================

	/** Wedge (outer) product - the "join" operation in projective geometry.
	 *  Used to construct higher-grade elements from lower-grade ones.
	 *  Example: point ∧ point = line, point ∧ line = plane
	 */
	public function wedge(b:Blade4):Blade4 {
		return new Blade4(
			// Scalar - no wedge contribution
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
			// e23
			s * b.e23 + e2 * b.e3 - e3 * b.e2 + e23 * b.s,
			// e31
			s * b.e31 + e3 * b.e1 - e1 * b.e3 + e31 * b.s,
			// e12
			s * b.e12 + e1 * b.e2 - e2 * b.e1 + e12 * b.s,
			// e021
			s * b.e021 + e0 * b.e12 + e1 * b.e02 - e2 * b.e01 - e01 * b.e2 + e02 * b.e1 + e12 * b.e0 + e021 * b.s,
			// e013
			s * b.e013 + e0 * b.e31 - e1 * b.e03 + e3 * b.e01 + e01 * b.e3 - e03 * b.e1 + e31 * b.e0 + e013 * b.s,
			// e032
			s * b.e032 + e0 * b.e23 + e2 * b.e03 - e3 * b.e02 - e02 * b.e3 + e03 * b.e2 + e23 * b.e0 + e032 * b.s,
			// e123
			s * b.e123 + e1 * b.e23 + e2 * b.e31 + e3 * b.e12 + e23 * b.e1 + e31 * b.e2 + e12 * b.e3 + e123 * b.s,
			// e0123
			s * b.e0123 + e0 * b.e123 + e1 * b.e032 + e2 * b.e013 + e3 * b.e021 + e01 * b.e23 + e02 * b.e31 + e03 * b.e12 + e23 * b.e01 + e31 * b.e02 + e12 * b.e03 +
			e021 * b.e3 + e013 * b.e2 + e032 * b.e1 + e123 * b.e0 + e0123 * b.s);
	}

	// ==================== Regressive Product (Meet) ====================

	/** Regressive product (vee) - the "meet" operation in projective geometry.
	 *  Computes intersection: plane ∨ plane = line, line ∨ plane = point
	 *  Defined as: a ∨ b = dual(dual(a) ∧ dual(b))
	 */
	public inline function vee(b:Blade4):Blade4 {
		return dual().wedge(b.dual()).dual();
	}

	// ==================== Inner Product ====================

	/** Left contraction (inner product).
	 *  a ⌋ b lowers the grade of b by the grade of a.
	 */
	public function dot(b:Blade4):Blade4 {
		return new Blade4(
			// Scalar
			s * b.s + e1 * b.e1 + e2 * b.e2 + e3 * b.e3 - e23 * b.e23 - e31 * b.e31 - e12 * b.e12 - e123 * b.e123,
			// e0
			s * b.e0 + e1 * b.e01 + e2 * b.e02 + e3 * b.e03 - e23 * b.e032 - e31 * b.e013 - e12 * b.e021 - e123 * b.e0123,
			// e1
			s * b.e1 - e2 * b.e12 + e3 * b.e31 - e23 * b.e123,
			// e2
			s * b.e2 + e1 * b.e12 - e3 * b.e23 - e31 * b.e123,
			// e3
			s * b.e3 - e1 * b.e31 + e2 * b.e23 - e12 * b.e123,
			// e01
			s * b.e01 - e2 * b.e021 + e3 * b.e013 - e23 * b.e0123,
			// e02
			s * b.e02 + e1 * b.e021 - e3 * b.e032 - e31 * b.e0123,
			// e03
			s * b.e03 - e1 * b.e013 + e2 * b.e032 - e12 * b.e0123,
			// e23
			s * b.e23 + e1 * b.e123,
			// e31
			s * b.e31 + e2 * b.e123,
			// e12
			s * b.e12 + e3 * b.e123,
			// e021
			s * b.e021 + e3 * b.e0123,
			// e013
			s * b.e013 + e2 * b.e0123,
			// e032
			s * b.e032 + e1 * b.e0123,
			// e123
			s * b.e123,
			// e0123
			s * b.e0123);
	}

	// ==================== Involutions ====================

	/** Reverse: reverses the order of basis vectors in each blade.
	 *  Flips sign for grades 2, 3 (bivectors and trivectors).
	 *  For motors: reverse gives the inverse transformation.
	 */
	public inline function reverse():Blade4 {
		return new Blade4(s, e0, e1, e2, e3, -e01, -e02, -e03, -e23, -e31, -e12, -e021, -e013, -e032, -e123, e0123);
	}

	/** Grade involution (main involution): flips sign of odd grades.
	 *  Grades 1, 3 get negated.
	 */
	public inline function involute():Blade4 {
		return new Blade4(s, -e0, -e1, -e2, -e3, e01, e02, e03, e23, e31, e12, -e021, -e013, -e032, -e123, e0123);
	}

	/** Clifford conjugate: combination of reverse and involute.
	 *  Conjugate = reverse ∘ involute = involute ∘ reverse
	 */
	public inline function conjugate():Blade4 {
		return new Blade4(s, -e0, -e1, -e2, -e3, -e01, -e02, -e03, -e23, -e31, -e12, e021, e013, e032, e123, e0123);
	}

	// ==================== Dual ====================

	/** Dual: map between grades k and (n-k) where n=4 for Blade4.
	 *  Uses the pseudoscalar e0123.
	 *  dual(plane) = point, dual(point) = plane, dual(line) = line
	 *
	 *  Grade-2 bivector mappings (complements in indices 0123):
	 *    e01 ↔ e23, e02 ↔ e31, e03 ↔ e12
	 */
	public inline function dual():Blade4 {
		// Parameter order: (s, e0, e1, e2, e3, e01, e02, e03, e23, e31, e12, e021, e013, e032, e123, e0123)
		// Mapping: grade k → grade (4-k)
		// - s ↔ e0123 (grade 0 ↔ 4)
		// - e0,e1,e2,e3 ↔ e123,e032,e013,e021 (grade 1 ↔ 3)
		// - e01↔e23, e02↔e31, e03↔e12 (grade 2 ↔ 2)
		return new Blade4(e0123, e123, e032, e013, e021, e23, e31, e12, e01, e02, e03, e3, e2, e1, e0, s);
	}

	/** Undual: inverse of dual operation.
	 *  In Blade4, dual is an involution (dual ∘ dual = identity), so undual = dual.
	 */
	public inline function undual():Blade4 {
		return new Blade4(e0123, e123, e032, e013, e021, e23, e31, e12, e01, e02, e03, e3, e2, e1, e0, s);
	}

	// ==================== Norms ====================

	/** Squared norm (for Euclidean part).
	 *  For a normalized motor, this equals 1.
	 */
	public inline function normSquared():Float {
		return s * s + e23 * e23 + e31 * e31 + e12 * e12;
	}

	/** Euclidean norm */
	public inline function norm():Float {
		return Math.sqrt(normSquared());
	}

	/** Ideal norm squared (the "weight" of degenerate components) */
	public inline function idealNormSquared():Float {
		return e01 * e01 + e02 * e02 + e03 * e03;
	}

	/** Normalize to unit motor */
	public inline function normalize():Blade4 {
		var n = norm();
		if (n < EPSILON)
			return this;
		var invN = 1.0 / n;
		return new Blade4(s * invN, e0 * invN, e1 * invN, e2 * invN, e3 * invN, e01 * invN, e02 * invN, e03 * invN, e23 * invN, e31 * invN, e12 * invN, e021 * invN,
			e013 * invN, e032 * invN, e123 * invN, e0123 * invN);
	}

	// ==================== Motors (Rigid Transforms) ====================

	/** Create a rotor (pure rotation) around axis through origin by angle.
	 *  Rotor = cos(θ/2) - sin(θ/2) * (ax*e23 + ay*e31 + az*e12)
	 *  The negative sign ensures positive angle rotates counterclockwise when
	 *  looking along the positive axis direction (right-hand rule).
	 */
	public static inline function rotor(axis:Vec3, angle:Float):Blade4 {
		var halfAngle = angle * 0.5;
		var c = Math.cos(halfAngle);
		var s = -Math.sin(halfAngle);
		var a = axis.normalize();
		return new Blade4(c, 0, 0, 0, 0, 0, 0, 0, a.x * s, a.y * s, a.z * s, 0, 0, 0, 0, 0);
	}

	/** Create a translator (pure translation) by vector (tx, ty, tz).
	 *  Translator = 1 - (t/2) * (tx*e01 + ty*e02 + tz*e03)
	 *  The negative sign arises from the PGA convention where e0i bivectors
	 *  translate in the negative direction when positive.
	 */
	public static inline function translator(tx:Float, ty:Float, tz:Float):Blade4 {
		return new Blade4(1, 0, 0, 0, 0, -tx * 0.5, -ty * 0.5, -tz * 0.5, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Create a translator from Vec3 */
	public static inline function translatorFromVec3(t:Vec3):Blade4 {
		return translator(t.x, t.y, t.z);
	}

	/** Create a motor from rotation and translation.
	 *  Motor = translator * rotor (translation applied after rotation)
	 */
	public static inline function motor(axis:Vec3, angle:Float, translation:Vec3):Blade4 {
		var r = rotor(axis, angle);
		var t = translatorFromVec3(translation);
		return mul(t, r);
	}

	/** Convert motor to dual quaternion.
	 *  The even subalgebra of Blade4 is isomorphic to dual quaternions.
	 */
	public function toDualQuat():DualQuat {
		// Real part: rotation quaternion from (s, e23, e31, e12)
		// Note: sign convention matches our G3 conventions
		var realQuat = new Quat(-e23, -e31, -e12, s);
		// Dual part: from (e01, e02, e03)
		// The dual part encodes translation as: d = 0.5 * t * r
		var dualQuat = new Quat(-e01, -e02, -e03, 0);
		return new DualQuat(realQuat, dualQuat);
	}

	/** Create motor from dual quaternion */
	public static function fromDualQuat(dq:DualQuat):Blade4 {
		// Convert back using the same sign conventions
		return new Blade4(dq.real.w, // s
			0, 0, 0, 0, // planes
			-dq.dual.x, -dq.dual.y, -dq.dual.z, // e01, e02, e03
			-dq.real.x, -dq.real.y, -dq.real.z, // e23, e31, e12
			0, 0, 0, 0, // points
			0 // pseudoscalar
		);
	}

	// ==================== Transformation Operations ====================

	/** Apply motor to a point: m * p * reverse(m)
	 *  This is the "sandwich product" that transforms geometric elements.
	 */
	public inline function transformPoint(p:Blade4):Blade4 {
		return mul(mul(this, p), reverse());
	}

	/** Apply motor to a plane */
	public inline function transformPlane(p:Blade4):Blade4 {
		return mul(mul(this, p), reverse());
	}

	/** Apply motor to a line */
	public inline function transformLine(l:Blade4):Blade4 {
		return mul(mul(this, l), reverse());
	}

	/** Transform a Vec3 point and return the result as Vec3 */
	public inline function applyToPoint(p:Vec3):Vec3 {
		return transformPoint(pointFromVec3(p)).toPoint();
	}

	// ==================== Arithmetic ====================

	@:op(a + b)
	public static inline function add(a:Blade4, b:Blade4):Blade4 {
		return new Blade4(a.s + b.s, a.e0 + b.e0, a.e1 + b.e1, a.e2 + b.e2, a.e3 + b.e3, a.e01 + b.e01, a.e02 + b.e02, a.e03 + b.e03, a.e23 + b.e23, a.e31 + b.e31,
			a.e12 + b.e12, a.e021 + b.e021, a.e013 + b.e013, a.e032 + b.e032, a.e123 + b.e123, a.e0123 + b.e0123);
	}

	@:op(a - b)
	public static inline function sub(a:Blade4, b:Blade4):Blade4 {
		return new Blade4(a.s - b.s, a.e0 - b.e0, a.e1 - b.e1, a.e2 - b.e2, a.e3 - b.e3, a.e01 - b.e01, a.e02 - b.e02, a.e03 - b.e03, a.e23 - b.e23, a.e31 - b.e31,
			a.e12 - b.e12, a.e021 - b.e021, a.e013 - b.e013, a.e032 - b.e032, a.e123 - b.e123, a.e0123 - b.e0123);
	}

	@:op(a * b)
	@:commutative
	public static inline function mulScalar(a:Blade4, s:Float):Blade4 {
		return new Blade4(a.s * s, a.e0 * s, a.e1 * s, a.e2 * s, a.e3 * s, a.e01 * s, a.e02 * s, a.e03 * s, a.e23 * s, a.e31 * s, a.e12 * s, a.e021 * s, a.e013 * s,
			a.e032 * s, a.e123 * s, a.e0123 * s);
	}

	@:op(a / b)
	public static inline function divScalar(a:Blade4, s:Float):Blade4 {
		return mulScalar(a, 1.0 / s);
	}

	@:op(-a)
	public static inline function neg(a:Blade4):Blade4 {
		return new Blade4(-a.s, -a.e0, -a.e1, -a.e2, -a.e3, -a.e01, -a.e02, -a.e03, -a.e23, -a.e31, -a.e12, -a.e021, -a.e013, -a.e032, -a.e123, -a.e0123);
	}

	@:op(a == b)
	public static inline function eq(a:Blade4, b:Blade4):Bool {
		return a.s == b.s && a.e0 == b.e0 && a.e1 == b.e1 && a.e2 == b.e2 && a.e3 == b.e3 && a.e01 == b.e01 && a.e02 == b.e02 && a.e03 == b.e03 && a.e23 == b.e23 &&
			a.e31 == b.e31 && a.e12 == b.e12 && a.e021 == b.e021 && a.e013 == b.e013 && a.e032 == b.e032 && a.e123 == b.e123 && a.e0123 == b.e0123;
	}

	@:op(a != b)
	public static inline function neq(a:Blade4, b:Blade4):Bool {
		return !(a == b);
	}

	// ==================== Extended Operators ====================

	/** Wedge product operator: a ^ b (join)
	 *  Constructs higher-grade elements from lower-grade ones.
	 *  point ^ point = line, point ^ line = plane, line ^ line = 0
	 */
	@:op(a ^ b)
	public inline function opWedge(b:Blade4):Blade4 {
		return wedge(b);
	}

	/** Regressive product operator: a & b (meet)
	 *  Computes intersection of geometric elements.
	 *  plane & plane = line, plane & line = point, line & line = 0
	 */
	@:op(a & b)
	public inline function opVee(b:Blade4):Blade4 {
		return vee(b);
	}

	/** Inner product operator: a | b
	 *  Left contraction - reduces grade.
	 */
	@:op(a | b)
	public inline function opInner(b:Blade4):Blade4 {
		return dot(b);
	}

	/** Reverse operator: ~a
	 *  For motors: ~m gives the inverse transformation.
	 *  Useful for sandwich products: m * x * ~m
	 */
	@:op(~a)
	public static inline function opReverse(a:Blade4):Blade4 {
		return a.reverse();
	}

	/** Dual operator: !a
	 *  Maps between complementary grades.
	 *  !point = plane, !plane = point, !line = line
	 */
	@:op(!a)
	public static inline function opDual(a:Blade4):Blade4 {
		return a.dual();
	}

	/** Grade extraction operator: a[k]
	 *  Extracts grade-k component.
	 *  a[0] = scalar, a[1] = planes, a[2] = lines, a[3] = points, a[4] = pseudoscalar
	 */
	@:op([])
	public function opGrade(k:Int):Blade4 {
		return switch (k) {
			case 0: new Blade4(s, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			case 1: new Blade4(0, e0, e1, e2, e3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			case 2: new Blade4(0, 0, 0, 0, 0, e01, e02, e03, e23, e31, e12, 0, 0, 0, 0, 0);
			case 3: new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, e021, e013, e032, e123, 0);
			case 4: new Blade4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, e0123);
			default: Blade4.zero();
		};
	}
}

/** Data class for Blade4 - stores 16 components */
@:noCompletion
class Blade4Data {
	public var s:Float; // scalar
	public var e0:Float; // planes (grade 1)
	public var e1:Float;
	public var e2:Float;
	public var e3:Float;
	public var e01:Float; // lines (grade 2)
	public var e02:Float;
	public var e03:Float;
	public var e23:Float;
	public var e31:Float;
	public var e12:Float;
	public var e021:Float; // points (grade 3)
	public var e013:Float;
	public var e032:Float;
	public var e123:Float;
	public var e0123:Float; // pseudoscalar (grade 4)

	public inline function new(s:Float, e0:Float, e1:Float, e2:Float, e3:Float, e01:Float, e02:Float, e03:Float, e23:Float, e31:Float, e12:Float, e021:Float,
			e013:Float, e032:Float, e123:Float, e0123:Float) {
		this.s = s;
		this.e0 = e0;
		this.e1 = e1;
		this.e2 = e2;
		this.e3 = e3;
		this.e01 = e01;
		this.e02 = e02;
		this.e03 = e03;
		this.e23 = e23;
		this.e31 = e31;
		this.e12 = e12;
		this.e021 = e021;
		this.e013 = e013;
		this.e032 = e032;
		this.e123 = e123;
		this.e0123 = e0123;
	}
}
