package pga;

#if (vector_math_f32 && (cpp || hl || cs || java))
@:eager private typedef Float = Single;
#end

private inline var EPSILON = 1e-6;

/**
 * Blade3: 3D Euclidean Geometric Algebra - G(3,0,0)
 *
 * The algebra of 3D Euclidean space with 8 basis elements (2³):
 *
 *   Grade 0 (scalar):     1
 *   Grade 1 (vectors):    e1, e2, e3
 *   Grade 2 (bivectors):  e23, e31, e12
 *   Grade 3 (trivector):  e123 (pseudoscalar)
 *
 * Metric: e1² = e2² = e3² = +1
 *
 * The even subalgebra (grades 0 and 2) is isomorphic to quaternions:
 *   scalar ↔ w, e23 ↔ i, e31 ↔ j, e12 ↔ k
 *
 * Bivector naming convention uses e23, e31, e12 (not e23, e13, e12) to match
 * the quaternion cross-product cycle: i→j→k→i
 */
@:nullSafety
abstract Blade3(Blade3Data) to Blade3Data from Blade3Data {

	#if !macro

	// Grade 0: Scalar
	public var s(get, set):Float;

	inline function get_s()
		return this.s;

	inline function set_s(v:Float)
		return this.s = v;

	// Grade 1: Vector components
	public var e1(get, set):Float;

	inline function get_e1()
		return this.e1;

	inline function set_e1(v:Float)
		return this.e1 = v;

	public var e2(get, set):Float;

	inline function get_e2()
		return this.e2;

	inline function set_e2(v:Float)
		return this.e2 = v;

	public var e3(get, set):Float;

	inline function get_e3()
		return this.e3;

	inline function set_e3(v:Float)
		return this.e3 = v;

	// Grade 2: Bivector components
	public var e23(get, set):Float;

	inline function get_e23()
		return this.e23;

	inline function set_e23(v:Float)
		return this.e23 = v;

	public var e31(get, set):Float;

	inline function get_e31()
		return this.e31;

	inline function set_e31(v:Float)
		return this.e31 = v;

	public var e12(get, set):Float;

	inline function get_e12()
		return this.e12;

	inline function set_e12(v:Float)
		return this.e12 = v;

	// Grade 3: Pseudoscalar
	public var e123(get, set):Float;

	inline function get_e123()
		return this.e123;

	inline function set_e123(v:Float)
		return this.e123 = v;

	public inline function new(s:Float, e1:Float, e2:Float, e3:Float, e23:Float, e31:Float, e12:Float, e123:Float) {
		this = new Blade3Data(s, e1, e2, e3, e23, e31, e12, e123);
	}

	public inline function clone():Blade3 {
		return new Blade3(s, e1, e2, e3, e23, e31, e12, e123);
	}

	// ==================== Constructors ====================

	/** Zero multivector */
	public static inline function zero():Blade3 {
		return new Blade3(0, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Scalar (grade 0) */
	public static inline function scalar(s:Float):Blade3 {
		return new Blade3(s, 0, 0, 0, 0, 0, 0, 0);
	}

	/** Vector (grade 1) from Vec3 */
	public static inline function vector(v:Vec3):Blade3 {
		return new Blade3(0, v.x, v.y, v.z, 0, 0, 0, 0);
	}

	/** Vector (grade 1) from components - shorthand without Vec3 */
	public static inline function vec(x:Float, y:Float, z:Float):Blade3 {
		return new Blade3(0, x, y, z, 0, 0, 0, 0);
	}

	/** Bivector (grade 2) from Vec3 representing the axis
	 *  The bivector b.x*e23 + b.y*e31 + b.z*e12 represents rotation in the
	 *  planes perpendicular to the axis (b.x, b.y, b.z).
	 */
	public static inline function bivector(b:Vec3):Blade3 {
		return new Blade3(0, 0, 0, 0, b.x, b.y, b.z, 0);
	}

	/** Bivector (grade 2) from components - shorthand without Vec3
	 *  Components are (e23, e31, e12) representing rotation planes.
	 */
	public static inline function biv(e23:Float, e31:Float, e12:Float):Blade3 {
		return new Blade3(0, 0, 0, 0, e23, e31, e12, 0);
	}

	/** Pseudoscalar (grade 3) */
	public static inline function pseudoscalar(p:Float):Blade3 {
		return new Blade3(0, 0, 0, 0, 0, 0, 0, p);
	}

	// ==================== Basis Elements ====================
	// These are useful for building expressions: 2*Blade3.E1 + 3*Blade3.E2
	// Uppercase to distinguish from component accessors (e1, e2, etc.)

	/** Basis vector e1 */
	public static var E1(get, never):Blade3;
	static inline function get_E1():Blade3 return new Blade3(0, 1, 0, 0, 0, 0, 0, 0);

	/** Basis vector e2 */
	public static var E2(get, never):Blade3;
	static inline function get_E2():Blade3 return new Blade3(0, 0, 1, 0, 0, 0, 0, 0);

	/** Basis vector e3 */
	public static var E3(get, never):Blade3;
	static inline function get_E3():Blade3 return new Blade3(0, 0, 0, 1, 0, 0, 0, 0);

	/** Basis bivector e23 (yz-plane) */
	public static var E23(get, never):Blade3;
	static inline function get_E23():Blade3 return new Blade3(0, 0, 0, 0, 1, 0, 0, 0);

	/** Basis bivector e31 (zx-plane) */
	public static var E31(get, never):Blade3;
	static inline function get_E31():Blade3 return new Blade3(0, 0, 0, 0, 0, 1, 0, 0);

	/** Basis bivector e12 (xy-plane) */
	public static var E12(get, never):Blade3;
	static inline function get_E12():Blade3 return new Blade3(0, 0, 0, 0, 0, 0, 1, 0);

	/** Basis trivector e123 (pseudoscalar) */
	public static var E123(get, never):Blade3;
	static inline function get_E123():Blade3 return new Blade3(0, 0, 0, 0, 0, 0, 0, 1);

	/** Unit scalar */
	public static var ONE(get, never):Blade3;
	static inline function get_ONE():Blade3 return new Blade3(1, 0, 0, 0, 0, 0, 0, 0);

	/** Rotor from scalar and bivector - represents a rotation.
	 *  The even subalgebra (s + bivector) is closed under multiplication.
	 */
	public static inline function rotor(scalar:Float, bivector:Vec3):Blade3 {
		return new Blade3(scalar, 0, 0, 0, bivector.x, bivector.y, bivector.z, 0);
	}

	/** Rotor from axis-angle representation.
	 *  R = cos(θ/2) - sin(θ/2) * B where B is the unit bivector for the rotation plane.
	 *  The negative sign comes from the convention that e23*e31*e12 = -1.
	 */
	public static inline function fromAxisAngle(axis:Vec3, angle:Float):Blade3 {
		var halfAngle = angle * 0.5;
		var c = Math.cos(halfAngle);
		var s = -Math.sin(halfAngle); // negative for GA convention
		var a = axis.normalize();
		return new Blade3(c, 0, 0, 0, a.x * s, a.y * s, a.z * s, 0);
	}

	/** Convert from quaternion (w, x, y, z) to rotor.
	 *  Quaternion i,j,k map to -e23, -e31, -e12 bivectors.
	 */
	public static inline function fromQuat(q:Quat):Blade3 {
		return new Blade3(q.w, 0, 0, 0, -q.x, -q.y, -q.z, 0);
	}

	// ==================== Grade Extraction ====================

	/** Extract scalar (grade 0) */
	public inline function grade0():Float {
		return s;
	}

	/** Extract vector (grade 1) as Vec3 */
	public inline function grade1():Vec3 {
		return new Vec3(e1, e2, e3);
	}

	/** Extract bivector (grade 2) as Vec3 representing the axis */
	public inline function grade2():Vec3 {
		return new Vec3(e23, e31, e12);
	}

	/** Extract pseudoscalar (grade 3) */
	public inline function grade3():Float {
		return e123;
	}

	/** Project to specific grade, zeroing other components */
	public inline function gradeProject(g:Int):Blade3 {
		return switch (g) {
			case 0: new Blade3(s, 0, 0, 0, 0, 0, 0, 0);
			case 1: new Blade3(0, e1, e2, e3, 0, 0, 0, 0);
			case 2: new Blade3(0, 0, 0, 0, e23, e31, e12, 0);
			case 3: new Blade3(0, 0, 0, 0, 0, 0, 0, e123);
			default: zero();
		};
	}

	/** Even part (grades 0, 2) - the rotor subalgebra */
	public inline function even():Blade3 {
		return new Blade3(s, 0, 0, 0, e23, e31, e12, 0);
	}

	/** Odd part (grades 1, 3) */
	public inline function odd():Blade3 {
		return new Blade3(0, e1, e2, e3, 0, 0, 0, e123);
	}

	// ==================== Geometric Product ====================

	/**
	 * The geometric product - the fundamental operation of GA.
	 * Combines the inner (dot) and outer (wedge) products.
	 *
	 * For vectors: ab = a·b + a∧b (scalar + bivector)
	 *
	 * Multiplication table derived from:
	 *   e1² = e2² = e3² = 1
	 *   eiej = -ejei for i≠j
	 */
	@:op(a * b)
	public static function mul(a:Blade3, b:Blade3):Blade3 {
		return new Blade3(
			// Scalar (grade 0)
			a.s * b.s + a.e1 * b.e1 + a.e2 * b.e2 + a.e3 * b.e3
				- a.e23 * b.e23 - a.e31 * b.e31 - a.e12 * b.e12 - a.e123 * b.e123,
			// e1 (grade 1)
			a.s * b.e1 + a.e1 * b.s - a.e2 * b.e12 + a.e3 * b.e31
				+ a.e12 * b.e2 - a.e31 * b.e3 - a.e23 * b.e123 - a.e123 * b.e23,
			// e2 (grade 1)
			a.s * b.e2 + a.e1 * b.e12 + a.e2 * b.s - a.e3 * b.e23
				- a.e12 * b.e1 + a.e23 * b.e3 - a.e31 * b.e123 - a.e123 * b.e31,
			// e3 (grade 1)
			a.s * b.e3 - a.e1 * b.e31 + a.e2 * b.e23 + a.e3 * b.s
				+ a.e31 * b.e1 - a.e23 * b.e2 - a.e12 * b.e123 - a.e123 * b.e12,
			// e23 (grade 2)
			a.s * b.e23 + a.e2 * b.e3 - a.e3 * b.e2 + a.e23 * b.s
				- a.e31 * b.e12 + a.e12 * b.e31 + a.e1 * b.e123 + a.e123 * b.e1,
			// e31 (grade 2)
			a.s * b.e31 - a.e1 * b.e3 + a.e3 * b.e1 + a.e31 * b.s
				+ a.e23 * b.e12 - a.e12 * b.e23 + a.e2 * b.e123 + a.e123 * b.e2,
			// e12 (grade 2)
			a.s * b.e12 + a.e1 * b.e2 - a.e2 * b.e1 + a.e12 * b.s
				- a.e23 * b.e31 + a.e31 * b.e23 + a.e3 * b.e123 + a.e123 * b.e3,
			// e123 (grade 3)
			a.s * b.e123 + a.e1 * b.e23 + a.e2 * b.e31 + a.e3 * b.e12
				+ a.e23 * b.e1 + a.e31 * b.e2 + a.e12 * b.e3 + a.e123 * b.s
		);
	}

	// ==================== Derived Products ====================

	/** Wedge (outer) product - extracts the antisymmetric part.
	 *  For vectors: a ∧ b is a bivector representing the plane spanned by a and b.
	 *  Satisfies: a ∧ b = -b ∧ a, a ∧ a = 0
	 */
	public function wedge(b:Blade3):Blade3 {
		return new Blade3(
			// No scalar from wedge
			0,
			// No vector-scalar wedge contribution either
			0,
			0,
			0,
			// e23: from e2∧e3
			e2 * b.e3 - e3 * b.e2,
			// e31: from e3∧e1
			e3 * b.e1 - e1 * b.e3,
			// e12: from e1∧e2
			e1 * b.e2 - e2 * b.e1,
			// e123: from vector∧bivector + bivector∧vector
			e1 * b.e23 + e2 * b.e31 + e3 * b.e12 + e23 * b.e1 + e31 * b.e2 + e12 * b.e3
		);
	}

	/** Inner (dot) product - contracts grades.
	 *  For vectors: a · b is a scalar (the usual dot product).
	 *  For a vector and bivector: contracts to a vector.
	 */
	public function dot(b:Blade3):Blade3 {
		return new Blade3(
			// Scalar: from vector·vector and bivector·bivector
			e1 * b.e1 + e2 * b.e2 + e3 * b.e3 - e23 * b.e23 - e31 * b.e31 - e12 * b.e12,
			// Vector: from bivector·vector
			e12 * b.e2 - e31 * b.e3 + e23 * b.e123 - e2 * b.e12 + e3 * b.e31 - e123 * b.e23,
			-e12 * b.e1 + e23 * b.e3 + e31 * b.e123 + e1 * b.e12 - e3 * b.e23 - e123 * b.e31,
			e31 * b.e1 - e23 * b.e2 + e12 * b.e123 - e1 * b.e31 + e2 * b.e23 - e123 * b.e12,
			// Bivector: from trivector·vector
			e123 * b.e1 + e1 * b.e123, e123 * b.e2 + e2 * b.e123, e123 * b.e3 + e3 * b.e123,
			// No trivector from inner
			0
		);
	}

	/** Left contraction: a ⌋ b
	 *  The part of the inner product that lowers grade.
	 */
	public function leftContract(b:Blade3):Blade3 {
		// Simplified: for most uses, same as dot
		return dot(b);
	}

	/** Scalar product: ⟨ab⟩₀
	 *  Extracts only the scalar part of the geometric product.
	 */
	public inline function scalarProduct(b:Blade3):Float {
		return s * b.s + e1 * b.e1 + e2 * b.e2 + e3 * b.e3 - e23 * b.e23 - e31 * b.e31 - e12 * b.e12 - e123 * b.e123;
	}

	// ==================== Involutions ====================

	/** Reverse: reverses the order of basis vectors in each blade.
	 *  (ab)† = b†a†
	 *  Grade 0, 1: unchanged
	 *  Grade 2, 3: sign flip
	 */
	public inline function reverse():Blade3 {
		return new Blade3(s, e1, e2, e3, -e23, -e31, -e12, -e123);
	}

	/** Grade involution (main involution): negates odd grades.
	 *  â = (-1)^grade * a
	 */
	public inline function involute():Blade3 {
		return new Blade3(s, -e1, -e2, -e3, e23, e31, e12, -e123);
	}

	/** Clifford conjugate: reverse followed by grade involution.
	 *  Combines both sign changes.
	 */
	public inline function conjugate():Blade3 {
		return new Blade3(s, -e1, -e2, -e3, -e23, -e31, -e12, e123);
	}

	// ==================== Norms ====================

	/** Squared norm: a * reverse(a) for simple elements.
	 *  For a rotor (unit quaternion), this equals 1.
	 */
	public inline function normSquared():Float {
		return s * s + e1 * e1 + e2 * e2 + e3 * e3 + e23 * e23 + e31 * e31 + e12 * e12 + e123 * e123;
	}

	/** Euclidean norm */
	public inline function norm():Float {
		return Math.sqrt(normSquared());
	}

	/** Normalize to unit norm */
	public inline function normalize():Blade3 {
		var n = norm();
		var invN = n < EPSILON ? 1.0 : 1.0 / n;
		return new Blade3(s * invN, e1 * invN, e2 * invN, e3 * invN, e23 * invN, e31 * invN, e12 * invN, e123 * invN);
	}

	/** Inverse: a⁻¹ such that a * a⁻¹ = 1
	 *  For rotors: inverse = reverse (since |R| = 1)
	 *  General case: a⁻¹ = reverse(a) / (a * reverse(a))
	 */
	public inline function inverse():Blade3 {
		var rev = reverse();
		var normSq = scalarProduct(rev);
		var invNormSq = Math.abs(normSq) < EPSILON ? 1.0 : 1.0 / normSq;
		return new Blade3(rev.s * invNormSq, rev.e1 * invNormSq, rev.e2 * invNormSq, rev.e3 * invNormSq,
			rev.e23 * invNormSq, rev.e31 * invNormSq, rev.e12 * invNormSq, rev.e123 * invNormSq);
	}

	// ==================== Dual ====================

	/** Dual: multiply by pseudoscalar inverse.
	 *  In G3: dual(x) = x * e123⁻¹ = x * (-e123) since e123² = -1
	 *  Maps: scalar ↔ pseudoscalar, vector ↔ bivector
	 *  Satisfies: dual(dual(x)) = -x
	 */
	public inline function dual():Blade3 {
		// e123⁻¹ = -e123 (since e123² = -1)
		// Component mapping (computed from x * (-e123)):
		// s → -e123, e1 → -e23, e2 → -e31, e3 → -e12
		// e23 → e1, e31 → e2, e12 → e3, e123 → s
		return new Blade3(e123, e23, e31, e12, -e1, -e2, -e3, -s);
	}

	/** Undual: inverse of dual operation.
	 *  undual(dual(x)) = x
	 */
	public inline function undual():Blade3 {
		// Multiply by e123 (not inverse)
		// This is the inverse mapping of dual
		return new Blade3(-e123, -e23, -e31, -e12, e1, e2, e3, s);
	}

	// ==================== Rotation Operations ====================

	/** Sandwich product: R * x * R†
	 *  This is how rotors apply transformations.
	 *  For a rotor R, sandwich(x) rotates x.
	 */
	public inline function sandwich(x:Blade3):Blade3 {
		return this * x * reverse();
	}

	/** Apply this rotor to rotate a vector.
	 *  Optimized version of sandwich for pure vectors.
	 */
	public function rotateVector(v:Vec3):Vec3 {
		// For a unit rotor R = s + e23*b.x + e31*b.y + e12*b.z
		// and vector V = e1*v.x + e2*v.y + e3*v.z
		// R V R† can be computed more efficiently

		var vg = vector(v);
		var result = sandwich(vg);
		return result.grade1();
	}

	// ==================== Conversion ====================

	/** Convert rotor to quaternion.
	 *  Only valid for even multivectors (rotors).
	 *  Note: Quaternion i,j,k map to -e23, -e31, -e12 due to sign conventions.
	 */
	public inline function toQuat():Quat {
		// GA rotor: s - sin(θ/2)*(nx*e23 + ny*e31 + nz*e12)
		// Quat: cos(θ/2) + sin(θ/2)*(nx*i + ny*j + nz*k)
		// So: i↔-e23, j↔-e31, k↔-e12
		return new Quat(-e23, -e31, -e12, s);
	}

	/** Extract axis-angle from rotor.
	 *  Returns Vec4(axis.x, axis.y, axis.z, angle)
	 */
	public inline function toAxisAngle():Vec4 {
		return toQuat().toAxisAngle();
	}

	// ==================== Arithmetic ====================

	@:op(a + b)
	public static inline function add(a:Blade3, b:Blade3):Blade3 {
		return new Blade3(a.s + b.s, a.e1 + b.e1, a.e2 + b.e2, a.e3 + b.e3, a.e23 + b.e23, a.e31 + b.e31, a.e12 + b.e12, a.e123 + b.e123);
	}

	@:op(a - b)
	public static inline function sub(a:Blade3, b:Blade3):Blade3 {
		return new Blade3(a.s - b.s, a.e1 - b.e1, a.e2 - b.e2, a.e3 - b.e3, a.e23 - b.e23, a.e31 - b.e31, a.e12 - b.e12, a.e123 - b.e123);
	}

	@:op(a * b)
	@:commutative
	public static inline function mulScalar(a:Blade3, s:Float):Blade3 {
		return new Blade3(a.s * s, a.e1 * s, a.e2 * s, a.e3 * s, a.e23 * s, a.e31 * s, a.e12 * s, a.e123 * s);
	}

	@:op(a / b)
	public static inline function divScalar(a:Blade3, s:Float):Blade3 {
		return a * (1.0 / s);
	}

	@:op(-a)
	public static inline function neg(a:Blade3):Blade3 {
		return new Blade3(-a.s, -a.e1, -a.e2, -a.e3, -a.e23, -a.e31, -a.e12, -a.e123);
	}

	@:op(a == b)
	public static inline function eq(a:Blade3, b:Blade3):Bool {
		return a.s == b.s && a.e1 == b.e1 && a.e2 == b.e2 && a.e3 == b.e3 && a.e23 == b.e23 && a.e31 == b.e31 && a.e12 == b.e12 && a.e123 == b.e123;
	}

	@:op(a != b)
	public static inline function neq(a:Blade3, b:Blade3):Bool {
		return !(a == b);
	}

	// ==================== Extended Operators ====================

	/** Wedge product operator: a ^ b
	 *  Computes the outer/exterior product.
	 *  For vectors: a ^ b gives a bivector representing the plane spanned by a and b.
	 */
	@:op(a ^ b)
	public inline function opWedge(b:Blade3):Blade3 {
		return wedge(b);
	}

	/** Inner product operator: a | b
	 *  Computes the left contraction (dot product).
	 *  Reduces grade: vec | bivec = vec
	 */
	@:op(a | b)
	public inline function opInner(b:Blade3):Blade3 {
		return dot(b);
	}

	/** Regressive product operator: a & b
	 *  Computes the meet/vee product: dual(dual(a) ^ dual(b))
	 *  In G3 this is less commonly used but included for completeness.
	 */
	@:op(a & b)
	public inline function opVee(b:Blade3):Blade3 {
		return dual().wedge(b.dual()).dual();
	}

	/** Reverse operator: ~a
	 *  Reverses the order of basis vectors in each blade.
	 *  For rotors: ~R gives the inverse rotation.
	 */
	@:op(~a)
	public static inline function opReverse(a:Blade3):Blade3 {
		return a.reverse();
	}

	/** Dual operator: !a
	 *  Maps between complementary grades via the pseudoscalar.
	 *  !vector = bivector, !bivector = vector, !scalar = pseudoscalar
	 */
	@:op(!a)
	public static inline function opDual(a:Blade3):Blade3 {
		return a.dual();
	}

	/** Grade extraction operator: a[k]
	 *  Extracts grade-k component as a new multivector.
	 *  a[0] = scalar part, a[1] = vector part, a[2] = bivector part, a[3] = trivector part
	 */
	@:op([])
	public function opGrade(k:Int):Blade3 {
		return switch (k) {
			case 0: new Blade3(s, 0, 0, 0, 0, 0, 0, 0);
			case 1: new Blade3(0, e1, e2, e3, 0, 0, 0, 0);
			case 2: new Blade3(0, 0, 0, 0, e23, e31, e12, 0);
			case 3: new Blade3(0, 0, 0, 0, 0, 0, 0, e123);
			default: Blade3.zero();
		};
	}

	public inline function toString():String {
		return 'Blade3($s + ${e1}e1 + ${e2}e2 + ${e3}e3 + ${e23}e23 + ${e31}e31 + ${e12}e12 + ${e123}e123)';
	}

	#end // !macro
}

@:noCompletion
class Blade3Data {
	#if !macro
	public var s:Float;
	public var e1:Float;
	public var e2:Float;
	public var e3:Float;
	public var e23:Float;
	public var e31:Float;
	public var e12:Float;
	public var e123:Float;

	public inline function new(s:Float, e1:Float, e2:Float, e3:Float, e23:Float, e31:Float, e12:Float, e123:Float) {
		this.s = s;
		this.e1 = e1;
		this.e2 = e2;
		this.e3 = e3;
		this.e23 = e23;
		this.e31 = e31;
		this.e12 = e12;
		this.e123 = e123;
	}
	#end
}
