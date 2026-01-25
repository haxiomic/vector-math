#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

@:nullSafety
abstract Dual(DualData) to DualData from DualData {

	#if !macro

	public var re(get, set): Float;
	inline function get_re() return this.re;
	inline function set_re(v: Float) return this.re = v;

	public var du(get, set): Float;
	inline function get_du() return this.du;
	inline function set_du(v: Float) return this.du = v;

	public inline function new(re: Float, du: Float) {
		this = new DualData(re, du);
	}

	public inline function set(re: Float, du: Float) {
		this.re = re;
		this.du = du;
	}

	public inline function clone() {
		return new Dual(re, du);
	}

	public inline function copyFrom(d: Dual) {
		re = d.re;
		du = d.du;
		return this;
	}

	// Utility

	public inline function conjugate(): Dual {
		return new Dual(re, -du);
	}

	public static inline function variable(x: Float): Dual {
		return new Dual(x, 1);
	}

	public static inline function constant(x: Float): Dual {
		return new Dual(x, 0);
	}

	// Derivative-preserving functions (automatic differentiation)

	public inline function sqrt(): Dual {
		// sqrt(re) + du / (2*sqrt(re))
		var sqrtRe = Math.sqrt(re);
		return new Dual(sqrtRe, du / (2.0 * sqrtRe));
	}

	public inline function sin(): Dual {
		// sin(re) + du*cos(re)
		return new Dual(Math.sin(re), du * Math.cos(re));
	}

	public inline function cos(): Dual {
		// cos(re) - du*sin(re)
		return new Dual(Math.cos(re), -du * Math.sin(re));
	}

	public inline function tan(): Dual {
		// tan(re) + du/cos^2(re)
		var c = Math.cos(re);
		return new Dual(Math.tan(re), du / (c * c));
	}

	public inline function exp(): Dual {
		// exp(re) + du*exp(re)
		var e = Math.exp(re);
		return new Dual(e, du * e);
	}

	public inline function log(): Dual {
		// log(re) + du/re
		return new Dual(Math.log(re), du / re);
	}

	public inline function pow(n: Float): Dual {
		// pow(re, n) + n*pow(re, n-1)*du
		var p = Math.pow(re, n);
		return new Dual(p, n * Math.pow(re, n - 1) * du);
	}

	public inline function asin(): Dual {
		// asin(re) + du/sqrt(1 - re^2)
		return new Dual(Math.asin(re), du / Math.sqrt(1.0 - re * re));
	}

	public inline function acos(): Dual {
		// acos(re) - du/sqrt(1 - re^2)
		return new Dual(Math.acos(re), -du / Math.sqrt(1.0 - re * re));
	}

	public inline function atan(): Dual {
		// atan(re) + du/(1 + re^2)
		return new Dual(Math.atan(re), du / (1.0 + re * re));
	}

	public inline function abs(): Dual {
		// |re| with derivative sign(re)
		return new Dual(Math.abs(re), du * (re >= 0 ? 1.0 : -1.0));
	}

	public inline function toString() {
		return 'dual(${re}, ${du})';
	}

	// Operators

	@:op(-a)
	static inline function neg(a: Dual): Dual
		return new Dual(-a.re, -a.du);

	@:op(a + b)
	static inline function add(a: Dual, b: Dual): Dual
		return new Dual(a.re + b.re, a.du + b.du);

	@:op(a + b) @:commutative
	static inline function addScalar(a: Dual, b: Float): Dual
		return new Dual(a.re + b, a.du);

	@:op(a - b)
	static inline function sub(a: Dual, b: Dual): Dual
		return new Dual(a.re - b.re, a.du - b.du);

	@:op(a - b)
	static inline function subScalar(a: Dual, b: Float): Dual
		return new Dual(a.re - b, a.du);

	@:op(a - b)
	static inline function subScalarInv(a: Float, b: Dual): Dual
		return new Dual(a - b.re, -b.du);

	@:op(a * b)
	static inline function mul(a: Dual, b: Dual): Dual {
		// (a + εb) * (c + εd) = ac + ε(ad + bc) since ε²=0
		return new Dual(a.re * b.re, a.re * b.du + a.du * b.re);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Dual, b: Float): Dual
		return new Dual(a.re * b, a.du * b);

	@:op(a / b)
	static inline function div(a: Dual, b: Dual): Dual {
		// (a + εb) / (c + εd) = a/c + ε(bc - ad)/c²
		var invC = 1.0 / b.re;
		return new Dual(a.re * invC, (a.du * b.re - a.re * b.du) * invC * invC);
	}

	@:op(a / b)
	static inline function divScalar(a: Dual, b: Float): Dual
		return new Dual(a.re / b, a.du / b);

	@:op(a / b)
	static inline function divScalarInv(a: Float, b: Dual): Dual {
		// a / (re + εdu) = a/re - ε(a*du)/re²
		var invRe = 1.0 / b.re;
		return new Dual(a * invRe, -a * b.du * invRe * invRe);
	}

	@:op(a == b)
	static inline function equal(a: Dual, b: Dual): Bool
		return a.re == b.re && a.du == b.du;

	@:op(a != b)
	static inline function notEqual(a: Dual, b: Dual): Bool
		return !equal(a, b);

	#end // !macro
}

@:noCompletion
class DualData {
	#if !macro
	public var re: Float;
	public var du: Float;

	public inline function new(re: Float, du: Float) {
		this.re = re;
		this.du = du;
	}
	#end
}
