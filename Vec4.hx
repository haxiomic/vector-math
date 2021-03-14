#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

@:nullSafety
abstract Vec4(Vec4Data) to Vec4Data from Vec4Data {

	#if !macro

	public var x (get, set): Float;
	inline function get_x() return this.x;
	inline function set_x(v: Float) return this.x = v;
	public var y (get, set): Float;
	inline function get_y() return this.y;
	inline function set_y(v: Float) return this.y = v;
	public var z (get, set): Float;
	inline function get_z() return this.z;
	inline function set_z(v: Float) return this.z = v;
	public var w (get, set): Float;
	inline function get_w() return this.w;
	inline function set_w(v: Float) return this.w = v;

	public inline function new(x: Float, y: Float, z: Float, w: Float) {
		this = new Vec4Data(x, y, z, w);
	}

	public inline function copyFrom(v: Vec4) {
		x = v.x;
		y = v.y;
		z = v.z;
		w = v.w;
		return this;
	}

	public inline function clone() {
		return new Vec4(x, y, z, w);
	}

	// Trigonometric
	public inline function radians(): Vec4 {
		return (this: Vec4) * Math.PI / 180;
	}
	public inline function degrees(): Vec4 {
		return (this: Vec4) * 180 / Math.PI;
	}
	public inline function sin(): Vec4 {
		return new Vec4(
			Math.sin(x),
			Math.sin(y),
			Math.sin(z),
			Math.sin(w)
		);
	}
	public inline function cos(): Vec4 {
		return new Vec4(
			Math.cos(x),
			Math.cos(y),
			Math.cos(z),
			Math.cos(w)
		);
	}
	public inline function tan(): Vec4 {
		return new Vec4(
			Math.tan(x),
			Math.tan(y),
			Math.tan(z),
			Math.tan(w)
		);
	}
	public inline function asin(): Vec4 {
		return new Vec4(
			Math.asin(x),
			Math.asin(y),
			Math.asin(z),
			Math.asin(w)
		);
	}
	public inline function acos(): Vec4 {
		return new Vec4(
			Math.acos(x),
			Math.acos(y),
			Math.acos(z),
			Math.acos(w)
		);
	}
	public inline function atan(): Vec4 {
		return new Vec4(
			Math.atan(x),
			Math.atan(y),
			Math.atan(z),
			Math.atan(w)
		);
	}
	public inline function atan2(b: Vec4): Vec4 {
		return new Vec4(
			Math.atan2(x, b.x),
			Math.atan2(y, b.y),
			Math.atan2(z, b.z),
			Math.atan2(w, b.w)
		);
	}

	// Exponential
	public inline function pow(e: Vec4): Vec4 {
		return new Vec4(
			Math.pow(x, e.x),
			Math.pow(y, e.y),
			Math.pow(z, e.z),
			Math.pow(w, e.w)
		);
	}
	public inline function exp(): Vec4 {
		return new Vec4(
			Math.exp(x),
			Math.exp(y),
			Math.exp(z),
			Math.exp(w)
		);
	}
	public inline function log(): Vec4 {
		return new Vec4(
			Math.log(x),
			Math.log(y),
			Math.log(z),
			Math.log(w)
		);
	}
	public inline function exp2(): Vec4 {
		return new Vec4(
			Math.pow(2, x),
			Math.pow(2, y),
			Math.pow(2, z),
			Math.pow(2, w)
		);
	}
	public inline function log2(): Vec4 @:privateAccess {
		return new Vec4(
			VectorMath.log2f(x),
			VectorMath.log2f(y),
			VectorMath.log2f(z),
			VectorMath.log2f(w)
		);
	}
	public inline function sqrt(): Vec4 {
		return new Vec4(
			Math.sqrt(x),
			Math.sqrt(y),
			Math.sqrt(z),
			Math.sqrt(w)
		);
	}
	public inline function inverseSqrt(): Vec4 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs(): Vec4 {
		return new Vec4(
			Math.abs(x),
			Math.abs(y),
			Math.abs(z),
			Math.abs(w)
		);
	}
	public inline function sign(): Vec4 {
		return new Vec4(
			x > 0. ? 1. : (x < 0. ? -1. : 0.),
			y > 0. ? 1. : (y < 0. ? -1. : 0.),
			z > 0. ? 1. : (z < 0. ? -1. : 0.),
			w > 0. ? 1. : (w < 0. ? -1. : 0.)
		);
	}
	public inline function floor(): Vec4 {
		return new Vec4(
			Math.floor(x),
			Math.floor(y),
			Math.floor(z),
			Math.floor(w)
		);
	}
	public inline function ceil(): Vec4 {
		return new Vec4(
			Math.ceil(x),
			Math.ceil(y),
			Math.ceil(z),
			Math.ceil(w)
		);
	}
	public inline function fract(): Vec4 {
		return (this: Vec4) - floor();
	}
	public extern overload inline function mod(d: Float): Vec4 {
		return (this: Vec4) - d * ((this: Vec4) / d).floor();
	}
	public extern overload inline function mod(d: Vec4): Vec4 {
		return (this: Vec4) - d * ((this: Vec4) / d).floor();
	}
	public extern overload inline function min(b: Vec4): Vec4 {
		return new Vec4(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y,
			b.z < z ? b.z : z,
			b.w < w ? b.w : w
		);
	}
	public extern overload inline function min(b: Float): Vec4 {
		return new Vec4(
			b < x ? b : x,
			b < y ? b : y,
			b < z ? b : z,
			b < w ? b : w
		);
	}
	public extern overload inline function max(b: Vec4): Vec4 {
		return new Vec4(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y,
			z < b.z ? b.z : z,
			w < b.w ? b.w : w
		);
	}
	public extern overload inline function max(b: Float): Vec4 {
		return new Vec4(
			x < b ? b : x,
			y < b ? b : y,
			z < b ? b : z,
			w < b ? b : w
		);
	}
	public extern overload inline function clamp(minLimit: Vec4, maxLimit: Vec4) {
		return max(minLimit).min(maxLimit);
	}
	public extern overload inline function clamp(minLimit: Float, maxLimit: Float) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b: Vec4, t: Vec4): Vec4 {
		return (this: Vec4) * (1.0 - t) + b * t;
	}
	public extern overload inline function mix(b: Vec4, t: Float): Vec4 {
		return (this: Vec4) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge: Vec4): Vec4 {
		return new Vec4(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0,
			z < edge.z ? 0.0 : 1.0,
			w < edge.w ? 0.0 : 1.0
		);
	}
	public extern overload inline function step(edge: Float): Vec4 {
		return new Vec4(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0,
			z < edge ? 0.0 : 1.0,
			w < edge ? 0.0 : 1.0
		);
	}

	public extern overload inline function smoothstep(edge0: Vec4, edge1: Vec4): Vec4 {
		var t = (((this: Vec4) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public extern overload inline function smoothstep(edge0: Float, edge1: Float): Vec4 {
		var t = (((this: Vec4) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length(): Float {
		return Math.sqrt(x*x + y*y + z*z + w*w);
	}	
	public inline function distance(b: Vec4): Float {
		return (b - this).length();
	}
	public inline function dot(b: Vec4): Float {
		return x * b.x + y * b.y + z * b.z + w * b.w;
	}
	public inline function normalize(): Vec4 {
		var v: Vec4 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I: Vec4, Nref: Vec4): Vec4 {
		return new Vec4(x, y, z, w) * (Nref.dot(I) < 0 ? 1 : -1);
	}
	public inline function reflect(N: Vec4): Vec4 {
		var I = (this: Vec4);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec4, eta: Float): Vec4 {
		var I = (this: Vec4);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return
			(eta * I - (eta * nDotI + Math.sqrt(k)) * N)
			* (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec4(${x}, ${y}, ${z}, ${w})';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: x;
			case 1: y;
			case 2: z;
			case 3: w;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Float)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			case 2: z = v;
			case 3: w = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a: Vec4)
		return new Vec4(-a.x, -a.y, -a.z, -a.w);

	@:op(++a)
	static inline function prefixIncrement(a: Vec4) {
		++a.x; ++a.y; ++a.z; ++a.w;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a: Vec4) {
		--a.x; --a.y; --a.z; --a.w;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a: Vec4) {
		var ret = a.clone();
		++a.x; ++a.y; ++a.z; ++a.w;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a: Vec4) {
		var ret = a.clone();
		--a.x; --a.y; --a.z; --a.w;
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Vec4, b: Vec4): Vec4
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqMat(a: Vec4, b: Mat4): Vec4
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Vec4, f: Float): Vec4
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Vec4, b: Vec4): Vec4
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Vec4, f: Float): Vec4
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Vec4, b: Vec4): Vec4
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Vec4, f: Float): Vec4
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Vec4, b: Vec4): Vec4
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Vec4, f: Float): Vec4
		return a.copyFrom(a - f);

	@:op(a * b)
	static inline function mul(a: Vec4, b: Vec4): Vec4
		return new Vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Vec4, b: Float): Vec4
		return new Vec4(a.x * b, a.y * b, a.z * b, a.w * b);

	@:op(a / b)
	static inline function div(a: Vec4, b: Vec4): Vec4
		return new Vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w);

	@:op(a / b)
	static inline function divScalar(a: Vec4, b: Float): Vec4
		return new Vec4(a.x / b, a.y / b, a.z / b, a.w / b);
	
	@:op(a / b)
	static inline function divScalarInv(a: Float, b: Vec4): Vec4
		return new Vec4(a / b.x, a / b.y, a / b.z, a / b.w);

	@:op(a + b)
	static inline function add(a: Vec4, b: Vec4): Vec4
		return new Vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);

	@:op(a + b) @:commutative
	static inline function addScalar(a: Vec4, b: Float): Vec4
		return new Vec4(a.x + b, a.y + b, a.z + b, a.w + b);

	@:op(a - b)
	static inline function sub(a: Vec4, b: Vec4): Vec4
		return new Vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);

	@:op(a - b)
	static inline function subScalar(a: Vec4, b: Float): Vec4
		return new Vec4(a.x - b, a.y - b, a.z - b, a.w - b);

	@:op(b - a)
	static inline function subScalarInv(a: Float, b: Vec4): Vec4
		return new Vec4(a - b.x, a - b.y, a - b.z, a - b.w);

	@:op(a == b)
	static inline function equal(a: Vec4, b: Vec4): Bool
		return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;

	@:op(a != b)
	static inline function notEqual(a: Vec4, b: Vec4): Bool
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
	public macro function copyIntoArray(self: haxe.macro.Expr.ExprOf<Vec4>, array: haxe.macro.Expr.ExprOf<ArrayAccess<Float>>, index: haxe.macro.Expr.ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array[2 + i] = self.z;
			array[3 + i] = self.w;
			array;
		}
	}
	
}

@:noCompletion
class Vec4Data {
	#if !macro
	public var x: Float;
	public var y: Float;
	public var z: Float;
	public var w: Float;

	public inline function new(x: Float, y: Float, z: Float, w: Float) {
		// the + 0.0 helps the optimizer realize it can collapse const float operations
		this.x = x + 0.0;
		this.y = y + 0.0;
		this.z = z + 0.0;
		this.w = w + 0.0;
	}
	#end
}