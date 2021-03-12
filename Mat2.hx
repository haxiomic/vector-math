#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

abstract Mat2(Mat2Data) from Mat2Data to Mat2Data {

	#if !macro

	public inline function new(
		a00: Float, a01: Float,
		a10: Float, a11: Float
	) {
		this = new Mat2Data(
			a00, a01,
			a10, a11
		);
	}

	public inline function copyFrom(v: Mat2) {
		var v: Mat2Data = v;
		this.c0.copyFrom(v.c0);
		this.c1.copyFrom(v.c1);
		return this;
	}

	public inline function clone(): Mat2 {
		return new Mat2(
			this.c0.x, this.c0.y,
			this.c1.x, this.c1.y
		);
	}

	public inline function matrixCompMult(n: Mat2): Mat2 {
		var n: Mat2Data = n;
		return new Mat2(
			this.c0.x * n.c0.x, this.c0.y * n.c0.y,
			this.c1.x * n.c1.x, this.c1.y * n.c1.y
		);
	}

	// extended methods

	public inline function transpose(): Mat2 {
		return new Mat2(
			this.c0.x, this.c1.x,
			this.c0.y, this.c1.y
		);
	}

	public inline function determinant(): Float {
		var m = this;
		return m.c0.x * m.c1.y - m.c1.x * m.c0.y;
	}

	public inline function inverse(): Mat2 {
		var m = this;
		var f = 1.0 / determinant();
		return new Mat2(
			m.c1.y * f, -m.c0.y * f,
			-m.c1.x * f, m.c0.x * f
		);
	}

	public inline function adjoint(): Mat2 {
		var m = this;
		return new Mat2(
			m.c1.y, -m.c0.y,
			-m.c1.x, m.c0.x
		);
	}

	public inline function toString() {
		return 'mat2(' +
			'${this.c0.x}, ${this.c0.y}, ' +
			'${this.c1.x}, ${this.c1.y}' +
		')';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: this.c0.clone();
			case 1: this.c1.clone();
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Vec2)
		return switch i {
			case 0: this.c0.copyFrom(v);
			case 1: this.c1.copyFrom(v);
			default: null;
		}

	@:op(-a)
	static inline function neg(m: Mat2) {
		var m: Mat2Data = m;
		return new Mat2(
			-m.c0.x, -m.c0.y,
			-m.c1.x, -m.c1.y
		);
	}

	@:op(++a)
	static inline function prefixIncrement(m: Mat2) {
		var _m: Mat2Data = m;
		++_m.c0.x; ++_m.c0.y;
		++_m.c1.x; ++_m.c1.y;
		return m.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(m: Mat2) {
		var _m: Mat2Data = m;
		--_m.c0.x; --_m.c0.y;
		--_m.c1.x; --_m.c1.y;
		return m.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(m: Mat2) {
		var ret = m.clone();
		var m: Mat2Data = m;
		++m.c0.x; ++m.c0.y;
		++m.c1.x; ++m.c1.y;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(m: Mat2) {
		var ret = m.clone();
		var m: Mat2Data = m;
		--m.c0.x; --m.c0.y;
		--m.c1.x; --m.c1.y;
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Mat2, b: Mat2): Mat2
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Mat2, f: Float): Mat2
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Mat2, b: Mat2): Mat2
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Mat2, f: Float): Mat2
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Mat2, b: Mat2): Mat2
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Mat2, f: Float): Mat2
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Mat2, b: Mat2): Mat2
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Mat2, f: Float): Mat2
		return a.copyFrom(a - f);

	@:op(a + b)
	static inline function add(m: Mat2, n: Mat2): Mat2 {
		var m: Mat2Data = m;
		var n: Mat2Data = n;
		return new Mat2(
			m.c0.x + n.c0.x, m.c0.y + n.c0.y,
			m.c1.x + n.c1.x, m.c1.y + n.c1.y
		);
	}

	@:op(a + b) @:commutative
	static inline function addScalar(m: Mat2, f: Float): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			m.c0.x + f, m.c0.y + f,
			m.c1.x + f, m.c1.y + f
		);
	}

	@:op(a - b)
	static inline function sub(m: Mat2, n: Mat2): Mat2 {
		var m: Mat2Data = m;
		var n: Mat2Data = n;
		return new Mat2(
			m.c0.x - n.c0.x, m.c0.y - n.c0.y,
			m.c1.x - n.c1.x, m.c1.y - n.c1.y
		);
	}

	@:op(a - b)
	static inline function subScalar(m: Mat2, f: Float): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			m.c0.x - f, m.c0.y - f,
			m.c1.x - f, m.c1.y - f
		);
	}

	@:op(a - b)
	static inline function subScalarInv(f: Float, m: Mat2): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			f - m.c0.x, f - m.c0.y,
			f - m.c1.x, f - m.c1.y
		);
	}

	@:op(a * b)
	static inline function mul(m: Mat2, n: Mat2): Mat2 {
		var m: Mat2Data = m;
		var n: Mat2Data = n;
		return new Mat2(
			m.c0.x * n.c0.x + m.c1.x * n.c0.y,
			m.c0.y * n.c0.x + m.c1.y * n.c0.y,
			m.c0.x * n.c1.x + m.c1.x * n.c1.y,
			m.c0.y * n.c1.x + m.c1.y * n.c1.y
		);
	}

	@:op(a * b)
	static inline function postMulVec2(m: Mat2, v: Vec2): Vec2 {
		var m: Mat2Data = m;
		return new Vec2(
			m.c0.x * v.x + m.c1.x * v.y,
			m.c0.y * v.x + m.c1.y * v.y
		);
	}

	@:op(a * b)
	static inline function preMulVec2(v: Vec2, m: Mat2): Vec2 {
		var m: Mat2Data = m;
		return new Vec2(
			v.dot(m.c0),
			v.dot(m.c1)
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(m: Mat2, f: Float): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			m.c0.x * f, m.c0.y * f, 
			m.c1.x * f, m.c1.y * f
		);
	}

	@:op(a / b)
	static inline function div(m: Mat2, n: Mat2): Mat2 {
		return m.matrixCompMult(1.0 / n);
	}

	@:op(a / b)
	static inline function divScalar(m: Mat2, f: Float): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			m.c0.x / f, m.c0.y / f,
			m.c1.x / f, m.c1.y / f
		);
	}

	@:op(a / b)
	static inline function divScalarInv(f: Float, m: Mat2): Mat2 {
		var m: Mat2Data = m;
		return new Mat2(
			f / m.c0.x, f / m.c0.y,
			f / m.c1.x, f / m.c1.y
		);
	}

	@:op(a == b)
	static inline function equal(m: Mat2, n: Mat2): Bool {
		var m: Mat2Data = m;
		var n: Mat2Data = n;
		return
			m.c0 == n.c0 &&
			m.c1 == n.c1;
	}

	@:op(a != b)
	static inline function notEqual(m: Mat2, n: Mat2): Bool
		return !equal(m, n);

	#end // !macro

	/**
		Copies matrix elements in column-major order into a type that supports array-write access
	**/
	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: haxe.macro.Expr.ExprOf<Mat2>, array: haxe.macro.Expr.ExprOf<ArrayAccess<Float>>, index: haxe.macro.Expr.ExprOf<Int>) {
		return macro  {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			self[0].copyIntoArray(array, i);
			self[1].copyIntoArray(array, i + 2);
			array;
		}
	}

}

@:noCompletion
class Mat2Data {
	#if !macro
	public var c0: Vec2;
	public var c1: Vec2;

	public inline function new(
		a00: Float, a01: Float,
		a10: Float, a11: Float
	) {
		c0 = new Vec2(a00, a01);
		c1 = new Vec2(a10, a11);
	}
	#end
}