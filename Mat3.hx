#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

abstract Mat3(Mat3Data) from Mat3Data to Mat3Data {

	#if !macro

	public inline function new(
		a00: Float, a01: Float, a02: Float,
		a10: Float, a11: Float, a12: Float,
		a20: Float, a21: Float, a22: Float
	) {
		this = new Mat3Data(
			a00, a01, a02,
			a10, a11, a12,
			a20, a21, a22
		);
	}
	
	public inline function copyFrom(v: Mat3) {
		var v: Mat3Data = v;
		this.c0.copyFrom(v.c0);
		this.c1.copyFrom(v.c1);
		this.c2.copyFrom(v.c2);
		return this;
	}

	public inline function clone(): Mat3 {
		return new Mat3(
			this.c0.x, this.c0.y, this.c0.z,
			this.c1.x, this.c1.y, this.c1.z,
			this.c2.x, this.c2.y, this.c2.z
		);
	}

	public inline function matrixCompMult(n: Mat3): Mat3 {
		var n: Mat3Data = n;
		return new Mat3(
			this.c0.x * n.c0.x, this.c0.y * n.c0.y, this.c0.z * n.c0.z,
			this.c1.x * n.c1.x, this.c1.y * n.c1.y, this.c1.z * n.c1.z,
			this.c2.x * n.c2.x, this.c2.y * n.c2.y, this.c2.z * n.c2.z
		);
	}

	// extended methods

	public inline function transpose(): Mat3 {
		return new Mat3(
			this.c0.x, this.c1.x, this.c2.x,
			this.c0.y, this.c1.y, this.c2.y,
			this.c0.z, this.c1.z, this.c2.z
		);
	}

	public inline function determinant(): Float {
		var m = this;
		return (
			m.c0.x * (m.c2.z * m.c1.y - m.c1.z * m.c2.y) +
			m.c0.y * (-m.c2.z * m.c1.x + m.c1.z * m.c2.x) +
			m.c0.z * (m.c2.y * m.c1.x - m.c1.y * m.c2.x)
		);
	}

	public inline function inverse(): Mat3 {
		var m = this;
		var b01 = m.c2.z * m.c1.y - m.c1.z * m.c2.y;
		var b11 = -m.c2.z * m.c1.x + m.c1.z * m.c2.x;
		var b21 = m.c2.y * m.c1.x - m.c1.y * m.c2.x;

		// determinant
		var det = m.c0.x * b01 + m.c0.y * b11 + m.c0.z * b21;

		var f = 1.0 / det;

		return new Mat3(
			b01 * f,
			(-m.c2.z * m.c0.y + m.c0.z * m.c2.y) * f,
			(m.c1.z * m.c0.y - m.c0.z * m.c1.y) * f,
			b11 * f,
			(m.c2.z * m.c0.x - m.c0.z * m.c2.x) * f,
			(-m.c1.z * m.c0.x + m.c0.z * m.c1.x) * f,
			b21 * f,
			(-m.c2.y * m.c0.x + m.c0.y * m.c2.x) * f,
			(m.c1.y * m.c0.x - m.c0.y * m.c1.x) * f
		);
	}

	public inline function adjoint(): Mat3 {
		var m = this;
		return new Mat3(
			m.c1.y * m.c2.z - m.c1.z * m.c2.y,
			m.c0.z * m.c2.y - m.c0.y * m.c2.z,
			m.c0.y * m.c1.z - m.c0.z * m.c1.y,
			m.c1.z * m.c2.x - m.c1.x * m.c2.z,
			m.c0.x * m.c2.z - m.c0.z * m.c2.x,
			m.c0.z * m.c1.x - m.c0.x * m.c1.z,
			m.c1.x * m.c2.y - m.c1.y * m.c2.x,
			m.c0.y * m.c2.x - m.c0.x * m.c2.y,
			m.c0.x * m.c1.y - m.c0.y * m.c1.x
		);
	}
 
	public inline function toString() {
		return 'mat3(' +
			'${this.c0.x}, ${this.c0.y}, ${this.c0.z}, ' +
			'${this.c1.x}, ${this.c1.y}, ${this.c1.z}, ' +
			'${this.c2.x}, ${this.c2.y}, ${this.c2.z}' +
		')';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: this.c0.clone();
			case 1: this.c1.clone();
			case 2: this.c2.clone();
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Vec3)
		return switch i {
			case 0: this.c0.copyFrom(v);
			case 1: this.c1.copyFrom(v);
			case 2: this.c2.copyFrom(v);
			default: null;
		}

	@:op(-a)
	static inline function neg(m: Mat3) {
		var m: Mat3Data = m;
		return new Mat3(
			-m.c0.x, -m.c0.y, -m.c0.z,
			-m.c1.x, -m.c1.y, -m.c1.z,
			-m.c2.x, -m.c2.y, -m.c2.z
		);
	}

	@:op(++a)
	static inline function prefixIncrement(m: Mat3) {
		var _m: Mat3Data = m;
		++_m.c0; ++_m.c1; ++_m.c2; 
		return m.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(m: Mat3) {
		var _m: Mat3Data = m;
		--_m.c0; --_m.c1; --_m.c2; 
		return m.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(m: Mat3) {
		var ret = m.clone();
		var m: Mat3Data = m;
		++m.c0; ++m.c1; ++m.c2; 
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(m: Mat3) {
		var ret = m.clone();
		var m: Mat3Data = m;
		--m.c0; --m.c1; --m.c2; 
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Mat3, b: Mat3): Mat3
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Mat3, f: Float): Mat3
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Mat3, b: Mat3): Mat3
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Mat3, f: Float): Mat3
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Mat3, b: Mat3): Mat3
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Mat3, f: Float): Mat3
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Mat3, b: Mat3): Mat3
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Mat3, f: Float): Mat3
		return a.copyFrom(a - f);

	@:op(a + b)
	static inline function add(m: Mat3, n: Mat3): Mat3 {
		var m: Mat3Data = m;
		var n: Mat3Data = n;
		return new Mat3(
			m.c0.x + n.c0.x, m.c0.y + n.c0.y, m.c0.z + n.c0.z,
			m.c1.x + n.c1.x, m.c1.y + n.c1.y, m.c1.z + n.c1.z,
			m.c2.x + n.c2.x, m.c2.y + n.c2.y, m.c2.z + n.c2.z
		);
	}

	@:op(a + b) @:commutative
	static inline function addScalar(m: Mat3, f: Float): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			m.c0.x + f, m.c0.y + f, m.c0.z + f,
			m.c1.x + f, m.c1.y + f, m.c1.z + f,
			m.c2.x + f, m.c2.y + f, m.c2.z + f
		);
	}

	@:op(a - b)
	static inline function sub(m: Mat3, n: Mat3): Mat3 {
		var m: Mat3Data = m;
		var n: Mat3Data = n;
		return new Mat3(
			m.c0.x - n.c0.x, m.c0.y - n.c0.y, m.c0.z - n.c0.z,
			m.c1.x - n.c1.x, m.c1.y - n.c1.y, m.c1.z - n.c1.z,
			m.c2.x - n.c2.x, m.c2.y - n.c2.y, m.c2.z - n.c2.z
		);
	}

	@:op(a - b)
	static inline function subScalar(m: Mat3, f: Float): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			m.c0.x - f, m.c0.y - f, m.c0.z - f,
			m.c1.x - f, m.c1.y - f, m.c1.z - f,
			m.c2.x - f, m.c2.y - f, m.c2.z - f
		);
	}

	@:op(a - b)
	static inline function subScalarInv(f: Float, m: Mat3): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			f - m.c0.x, f - m.c0.y, f - m.c0.z,
			f - m.c1.x, f - m.c1.y, f - m.c1.z,
			f - m.c2.x, f - m.c2.y, f - m.c2.z
		);
	}

	@:op(a * b)
	static inline function mul(m: Mat3, n: Mat3): Mat3 {
		var m: Mat3Data = m;
		var n: Mat3Data = n;
		return new Mat3(
			m.c0.x * n.c0.x + m.c1.x * n.c0.y + m.c2.x * n.c0.z,
			m.c0.y * n.c0.x + m.c1.y * n.c0.y + m.c2.y * n.c0.z,
			m.c0.z * n.c0.x + m.c1.z * n.c0.y + m.c2.z * n.c0.z,
			m.c0.x * n.c1.x + m.c1.x * n.c1.y + m.c2.x * n.c1.z,
			m.c0.y * n.c1.x + m.c1.y * n.c1.y + m.c2.y * n.c1.z,
			m.c0.z * n.c1.x + m.c1.z * n.c1.y + m.c2.z * n.c1.z,
			m.c0.x * n.c2.x + m.c1.x * n.c2.y + m.c2.x * n.c2.z,
			m.c0.y * n.c2.x + m.c1.y * n.c2.y + m.c2.y * n.c2.z,
			m.c0.z * n.c2.x + m.c1.z * n.c2.y + m.c2.z * n.c2.z
		);
	}

	@:op(a * b)
	static inline function postMulVec3(m: Mat3, v: Vec3): Vec3 {
		var m: Mat3Data = m;
		return new Vec3(
			m.c0.x * v.x + m.c1.x * v.y + m.c2.x * v.z,
			m.c0.y * v.x + m.c1.y * v.y + m.c2.y * v.z,
			m.c0.z * v.x + m.c1.z * v.y + m.c2.z * v.z
		);
	}

	@:op(a * b)
	static inline function preMulVec3(v: Vec3, m: Mat3): Vec3 {
		var m: Mat3Data = m;
		return new Vec3(
			v.dot(m.c0),
			v.dot(m.c1),
			v.dot(m.c2)
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(m: Mat3, f: Float): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			m.c0.x * f, m.c0.y * f, m.c0.z * f,
			m.c1.x * f, m.c1.y * f, m.c1.z * f,
			m.c2.x * f, m.c2.y * f, m.c2.z * f
		);
	}

	@:op(a / b)
	static inline function div(m: Mat3, n: Mat3): Mat3
		return m.matrixCompMult(1.0 / n);

	@:op(a / b)
	static inline function divScalar(m: Mat3, f: Float): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			m.c0.x / f, m.c0.y / f, m.c0.z / f,
			m.c1.x / f, m.c1.y / f, m.c1.z / f,
			m.c2.x / f, m.c2.y / f, m.c2.z / f
		);
	}

	@:op(a / b)
	static inline function divScalarInv(f: Float, m: Mat3): Mat3 {
		var m: Mat3Data = m;
		return new Mat3(
			f / m.c0.x, f/ m.c0.y, f / m.c0.z,
			f / m.c1.x, f/ m.c1.y, f / m.c1.z,
			f / m.c2.x, f/ m.c2.y, f / m.c2.z
		);
	}

	@:op(a == b)
	static inline function equal(m: Mat3, n: Mat3): Bool {
		var m: Mat3Data = m;
		var n: Mat3Data = n;
		return
			m.c0 == n.c0 &&
			m.c1 == n.c1 &&
			m.c2 == n.c2;
	}

	@:op(a != b)
	static inline function notEqual(m: Mat3, n: Mat3): Bool
		return !equal(m, n);

	#end // !macro

	/**
		Copies matrix elements in column-major order into a type that supports array-write access
	**/
	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: haxe.macro.Expr.ExprOf<Mat3>, array: haxe.macro.Expr.ExprOf<ArrayAccess<Float>>, index: haxe.macro.Expr.ExprOf<Int>) {
		return macro  {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			self[0].copyIntoArray(array, i);
			self[1].copyIntoArray(array, i + 3);
			self[2].copyIntoArray(array, i + 6);
			array;
		}
	}

}

@:noCompletion
class Mat3Data {
	#if !macro
	public var c0: Vec3;
	public var c1: Vec3;
	public var c2: Vec3;

	public inline function new(
		a00: Float, a01: Float, a02: Float,
		a10: Float, a11: Float, a12: Float,
		a20: Float, a21: Float, a22: Float
	) {
		c0 = new Vec3(a00, a01, a02);
		c1 = new Vec3(a10, a11, a12);
		c2 = new Vec3(a20, a21, a22);
	}
	#end
}