#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

@:nullSafety
abstract Vec2(Vec2Data) to Vec2Data from Vec2Data {

	#if !macro

	public var x (get, set): Float;
	inline function get_x() return this.x;
	inline function set_x(v: Float) return this.x = v;
	public var y (get, set): Float;
	inline function get_y() return this.y;
	inline function set_y(v: Float) return this.y = v;

	public inline function new(x: Float, y: Float) {
		this = new Vec2Data(x, y);
	}

	public inline function copyFrom(v: Vec2) {
		x = v.x;
		y = v.y;
		return this;
	}

	public inline function clone() {
		return new Vec2(x, y);
	}

	// Trigonometric
	public inline function radians(): Vec2 {
		return (this: Vec2) * Math.PI / 180;
	}
	public inline function degrees(): Vec2 {
		return (this: Vec2) * 180 / Math.PI;
	}
	public inline function sin(): Vec2 {
		return new Vec2(
			Math.sin(x),
			Math.sin(y)
		);
	}
	public inline function cos(): Vec2 {
		return new Vec2(
			Math.cos(x),
			Math.cos(y)
		);
	}
	public inline function tan(): Vec2 {
		return new Vec2(
			Math.tan(x),
			Math.tan(y)
		);
	}
	public inline function asin(): Vec2 {
		return new Vec2(
			Math.asin(x),
			Math.asin(y)
		);
	}
	public inline function acos(): Vec2 {
		return new Vec2(
			Math.acos(x),
			Math.acos(y)
		);
	}
	public inline function atan(): Vec2 {
		return new Vec2(
			Math.atan(x),
			Math.atan(y)
		);
	}
	public inline function atan2(b: Vec2): Vec2 {
		return new Vec2(
			Math.atan2(x, b.x),
			Math.atan2(y, b.y)
		);
	}

	// Exponential
	public inline function pow(e: Vec2): Vec2 {
		return new Vec2(
			Math.pow(x, e.x),
			Math.pow(y, e.y)
		);
	}
	public inline function exp(): Vec2 {
		return new Vec2(
			Math.exp(x),
			Math.exp(y)
		);
	}
	public inline function log(): Vec2 {
		return new Vec2(
			Math.log(x),
			Math.log(y)
		);
	}
	public inline function exp2(): Vec2 {
		return new Vec2(
			Math.pow(2, x),
			Math.pow(2, y)
		);
	}
	public inline function log2(): Vec2 @:privateAccess {
		return new Vec2(
			VectorMath.log2f(x),
			VectorMath.log2f(y)
		);
	}
	public inline function sqrt(): Vec2 {
		return new Vec2(
			Math.sqrt(x),
			Math.sqrt(y)
		);
	}
	public inline function inverseSqrt(): Vec2 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs(): Vec2 {
		return new Vec2(
			Math.abs(x),
			Math.abs(y)
		);
	}
	public inline function sign(): Vec2 {
		return new Vec2(
			x > 0. ? 1. : (x < 0. ? -1. : 0.),
			y > 0. ? 1. : (y < 0. ? -1. : 0.)
		);
	}
	public inline function floor(): Vec2 {
		return new Vec2(
			Math.floor(x),
			Math.floor(y)
		);
	}
	public inline function ceil(): Vec2 {
		return new Vec2(
			Math.ceil(x),
			Math.ceil(y)
		);
	}
	public inline function fract(): Vec2 {
		return (this: Vec2) - floor();
	}
	public extern overload inline function mod(d: Vec2): Vec2 {
		return (this: Vec2) - d * ((this: Vec2) / d).floor();
	}
	public extern overload inline function mod(d: Float): Vec2 {
		return (this: Vec2) - d * ((this: Vec2) / d).floor();
	}
	public extern overload inline function min(b: Vec2): Vec2 {
		return new Vec2(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y
		);
	}
	public extern overload inline function min(b: Float): Vec2 {
		return new Vec2(
			b < x ? b : x,
			b < y ? b : y
		);
	}
	public extern overload inline function max(b: Vec2): Vec2 {
		return new Vec2(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y
		);
	}
	public extern overload inline function max(b: Float): Vec2 {
		return new Vec2(
			x < b ? b : x,
			y < b ? b : y
		);
	}
	public extern overload inline function clamp(minLimit: Vec2, maxLimit: Vec2) {
		return max(minLimit).min(maxLimit);
	}
	public extern overload inline function clamp(minLimit: Float, maxLimit: Float) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b: Vec2, t: Vec2): Vec2 {
		return (this: Vec2) * (1.0 - t) + b * t;
	}
	public extern overload inline function mix(b: Vec2, t: Float): Vec2 {
		return (this: Vec2) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge: Vec2): Vec2 {
		return new Vec2(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0
		);
	}
	public extern overload inline function step(edge: Float): Vec2 {
		return new Vec2(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0
		);
	}

	public extern overload inline function smoothstep(edge0: Vec2, edge1: Vec2): Vec2 {
		var t = (((this: Vec2) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public extern overload inline function smoothstep(edge0: Float, edge1: Float): Vec2 {
		var t = (((this: Vec2) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length(): Float {
		return Math.sqrt(x*x + y*y);
	}	
	public inline function distance(b: Vec2): Float {
		return (b - this).length();
	}
	public inline function dot(b: Vec2): Float {
		return x * b.x + y * b.y;
	}
	public inline function normalize(): Vec2 {
		var v: Vec2 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I: Vec2, Nref: Vec2): Vec2 {
		return new Vec2(x, y) * (Nref.dot(I) < 0 ? 1 : -1);
	}
	public inline function reflect(N: Vec2): Vec2 {
		var I = (this: Vec2);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec2, eta: Float): Vec2 {
		var I = (this: Vec2);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return
			(eta * I - (eta * nDotI + Math.sqrt(k)) * N)
			* (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec2(${x}, ${y})';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: x;
			case 1: y;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Float)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a: Vec2)
		return new Vec2(-a.x, -a.y);

	@:op(++a)
	static inline function prefixIncrement(a: Vec2) {
		++a.x; ++a.y;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a: Vec2) {
		--a.x; --a.y;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a: Vec2) {
		var ret = a.clone();
		++a.x; ++a.y;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a: Vec2) {
		var ret = a.clone();
		--a.x; --a.y;
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Vec2, b: Vec2): Vec2
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqMat(a: Vec2, b: Mat2): Vec2
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Vec2, f: Float): Vec2
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Vec2, b: Vec2): Vec2
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Vec2, f: Float): Vec2
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Vec2, b: Vec2): Vec2
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Vec2, f: Float): Vec2
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Vec2, b: Vec2): Vec2
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Vec2, f: Float): Vec2
		return a.copyFrom(a - f);

	@:op(a * b)
	static inline function mul(a: Vec2, b: Vec2): Vec2
		return new Vec2(a.x * b.x, a.y * b.y);

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Vec2, b: Float): Vec2
		return new Vec2(a.x * b, a.y * b);

	@:op(a / b)
	static inline function div(a: Vec2, b: Vec2): Vec2
		return new Vec2(a.x / b.x, a.y / b.y);

	@:op(a / b)
	static inline function divScalar(a: Vec2, b: Float): Vec2
		return new Vec2(a.x / b, a.y / b);
	
	@:op(a / b)
	static inline function divScalarInv(a: Float, b: Vec2): Vec2
		return new Vec2(a / b.x, a / b.y);

	@:op(a + b)
	static inline function add(a: Vec2, b: Vec2): Vec2
		return new Vec2(a.x + b.x, a.y + b.y);

	@:op(a + b) @:commutative
	static inline function addScalar(a: Vec2, b: Float): Vec2
		return new Vec2(a.x + b, a.y + b);

	@:op(a - b)
	static inline function sub(a: Vec2, b: Vec2): Vec2
		return new Vec2(a.x - b.x, a.y - b.y);

	@:op(a - b)
	static inline function subScalar(a: Vec2, b: Float): Vec2
		return new Vec2(a.x - b, a.y - b);

	@:op(b - a)
	static inline function subScalarInv(a: Float, b: Vec2): Vec2
		return new Vec2(a - b.x, a - b.y);

	@:op(a == b)
	static inline function equal(a: Vec2, b: Vec2): Bool
		return a.x == b.x && a.y == b.y;

	@:op(a != b)
	static inline function notEqual(a: Vec2, b: Vec2): Bool
		return !equal(a, b);

	#end // !macro

	// macros
	@:op(a.b) macro function swizzleRead(self, name: String) {
		return VectorMath.swizzleReadExpr(self, name);
	}

	@:op(a.b) macro function swizzleWrite(self, name: String, value) {
		return VectorMath.swizzleWriteExpr(self, name, value);
	}

	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: haxe.macro.Expr.ExprOf<Vec2>, array: haxe.macro.Expr.ExprOf<ArrayAccess<Float>>, index: haxe.macro.Expr.ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array;
		}
	}
	
}

@:noCompletion
class Vec2Data {
	#if !macro
	public var x: Float;
	public var y: Float;

	public inline function new(x: Float, y: Float) {
		// the + 0.0 helps the optimizer realize it can collapse const float operations
		this.x = x + 0.0;
		this.y = y + 0.0;
	}
	#end
}