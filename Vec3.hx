#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

@:nullSafety
abstract Vec3(Vec3Data) to Vec3Data from Vec3Data {

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

	public inline function new(x: Float, y: Float, z: Float) {
		this = new Vec3Data(x, y, z);
	}

	public inline function copyFrom(v: Vec3) {
		x = v.x;
		y = v.y;
		z = v.z;
		return this;
	}

	public inline function clone() {
		return new Vec3(x, y, z);
	}

	// special case for vec3
	public inline function cross(b: Vec3)
		return new Vec3(
			y * b.z - z * b.y,
			z * b.x - x * b.z,
			x * b.y - y * b.x
		);

	// Trigonometric
	public inline function radians(): Vec3 {
		return (this: Vec3) * Math.PI / 180;
	}
	public inline function degrees(): Vec3 {
		return (this: Vec3) * 180 / Math.PI;
	}
	public inline function sin(): Vec3 {
		return new Vec3(
			Math.sin(x),
			Math.sin(y),
			Math.sin(z)
		);
	}
	public inline function cos(): Vec3 {
		return new Vec3(
			Math.cos(x),
			Math.cos(y),
			Math.cos(z)
		);
	}
	public inline function tan(): Vec3 {
		return new Vec3(
			Math.tan(x),
			Math.tan(y),
			Math.tan(z)
		);
	}
	public inline function asin(): Vec3 {
		return new Vec3(
			Math.asin(x),
			Math.asin(y),
			Math.asin(z)
		);
	}
	public inline function acos(): Vec3 {
		return new Vec3(
			Math.acos(x),
			Math.acos(y),
			Math.acos(z)
		);
	}
	public inline function atan(): Vec3 {
		return new Vec3(
			Math.atan(x),
			Math.atan(y),
			Math.atan(z)
		);
	}
	public inline function atan2(b: Vec3): Vec3 {
		return new Vec3(
			Math.atan2(x, b.x),
			Math.atan2(y, b.y),
			Math.atan2(z, b.z)
		);
	}

	// Exponential
	public inline function pow(e: Vec3): Vec3 {
		return new Vec3(
			Math.pow(x, e.x),
			Math.pow(y, e.y),
			Math.pow(z, e.z)
		);
	}
	public inline function exp(): Vec3 {
		return new Vec3(
			Math.exp(x),
			Math.exp(y),
			Math.exp(z)
		);
	}
	public inline function log(): Vec3 {
		return new Vec3(
			Math.log(x),
			Math.log(y),
			Math.log(z)
		);
	}
	public inline function exp2(): Vec3 {
		return new Vec3(
			Math.pow(2, x),
			Math.pow(2, y),
			Math.pow(2, z)
		);
	}
	public inline function log2(): Vec3 @:privateAccess {
		return new Vec3(
			VectorMath.log2f(x),
			VectorMath.log2f(y),
			VectorMath.log2f(z)
		);
	}
	public inline function sqrt(): Vec3 {
		return new Vec3(
			Math.sqrt(x),
			Math.sqrt(y),
			Math.sqrt(z)
		);
	}
	public inline function inverseSqrt(): Vec3 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs(): Vec3 {
		return new Vec3(
			Math.abs(x),
			Math.abs(y),
			Math.abs(z)
		);
	}
	public inline function sign(): Vec3 {
		return new Vec3(
			x > 0. ? 1. : (x < 0. ? -1. : 0.),
			y > 0. ? 1. : (y < 0. ? -1. : 0.),
			z > 0. ? 1. : (z < 0. ? -1. : 0.)
		);
	}
	public inline function floor(): Vec3 {
		return new Vec3(
			Math.floor(x),
			Math.floor(y),
			Math.floor(z)
		);
	}
	public inline function ceil(): Vec3 {
		return new Vec3(
			Math.ceil(x),
			Math.ceil(y),
			Math.ceil(z)
		);
	}
	public inline function fract(): Vec3 {
		return (this: Vec3) - floor();
	}
	public extern overload inline function mod(d: Vec3): Vec3 {
		return (this: Vec3) - d * ((this: Vec3) / d).floor();
	}
	public extern overload inline function mod(d: Float): Vec3 {
		return (this: Vec3) - d * ((this: Vec3) / d).floor();
	}
	public extern overload inline function min(b: Vec3): Vec3 {
		return new Vec3(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y,
			b.z < z ? b.z : z
		);
	}
	public extern overload inline function min(b: Float): Vec3 {
		return new Vec3(
			b < x ? b : x,
			b < y ? b : y,
			b < z ? b : z
		);
	}
	public extern overload inline function max(b: Vec3): Vec3 {
		return new Vec3(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y,
			z < b.z ? b.z : z
		);
	}
	public extern overload inline function max(b: Float): Vec3 {
		return new Vec3(
			x < b ? b : x,
			y < b ? b : y,
			z < b ? b : z
		);
	}
	public extern overload inline function clamp(minLimit: Vec3, maxLimit: Vec3) {
		return max(minLimit).min(maxLimit);
	}
	public extern overload inline function clamp(minLimit: Float, maxLimit: Float) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b: Vec3, t: Vec3): Vec3 {
		return (this: Vec3) * (1.0 - t) + b * t;
	}
	public extern overload inline function mix(b: Vec3, t: Float): Vec3 {
		return (this: Vec3) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge: Vec3): Vec3 {
		return new Vec3(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0,
			z < edge.z ? 0.0 : 1.0
		);
	}
	public extern overload inline function step(edge: Float): Vec3 {
		return new Vec3(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0,
			z < edge ? 0.0 : 1.0
		);
	}

	public extern overload inline function smoothstep(edge0: Vec3, edge1: Vec3): Vec3 {
		var t = (((this: Vec3) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public extern overload inline function smoothstep(edge0: Float, edge1: Float): Vec3 {
		var t = (((this: Vec3) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length(): Float {
		return Math.sqrt(x*x + y*y + z*z);
	}	
	public inline function distance(b: Vec3): Float {
		return (b - this).length();
	}
	public inline function dot(b: Vec3): Float {
		return x * b.x + y * b.y + z * b.z;
	}
	public inline function normalize(): Vec3 {
		var v: Vec3 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I: Vec3, Nref: Vec3): Vec3 {
		return new Vec3(x, y, z) * (Nref.dot(I) < 0 ? 1 : -1);
	}
	public inline function reflect(N: Vec3): Vec3 {
		var I = (this: Vec3);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec3, eta: Float): Vec3 {
		var I = (this: Vec3);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return
			(eta * I - (eta * nDotI + Math.sqrt(k)) * N)
			* (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec3(${x}, ${y}, ${z})';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: x;
			case 1: y;
			case 2: z;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Float)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			case 2: z = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a: Vec3)
		return new Vec3(-a.x, -a.y, -a.z);

	@:op(++a)
	static inline function prefixIncrement(a: Vec3) {
		++a.x; ++a.y; ++a.z;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a: Vec3) {
		--a.x; --a.y; --a.z;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a: Vec3) {
		var ret = a.clone();
		++a.x; ++a.y; ++a.z;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a: Vec3) {
		var ret = a.clone();
		--a.x; --a.y; --a.z;
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Vec3, b: Vec3): Vec3
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqMat(a: Vec3, b: Mat3): Vec3
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Vec3, f: Float): Vec3
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Vec3, b: Vec3): Vec3
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Vec3, f: Float): Vec3
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Vec3, b: Vec3): Vec3
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Vec3, f: Float): Vec3
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Vec3, b: Vec3): Vec3
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Vec3, f: Float): Vec3
		return a.copyFrom(a - f);

	@:op(a * b)
	static inline function mul(a: Vec3, b: Vec3): Vec3
		return new Vec3(a.x * b.x, a.y * b.y, a.z * b.z);

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Vec3, b: Float): Vec3
		return new Vec3(a.x * b, a.y * b, a.z * b);

	@:op(a / b)
	static inline function div(a: Vec3, b: Vec3): Vec3
		return new Vec3(a.x / b.x, a.y / b.y, a.z / b.z);

	@:op(a / b)
	static inline function divScalar(a: Vec3, b: Float): Vec3
		return new Vec3(a.x / b, a.y / b, a.z / b);
	
	@:op(a / b)
	static inline function divScalarInv(a: Float, b: Vec3): Vec3
		return new Vec3(a / b.x, a / b.y, a / b.z);

	@:op(a + b)
	static inline function add(a: Vec3, b: Vec3): Vec3
		return new Vec3(a.x + b.x, a.y + b.y, a.z + b.z);

	@:op(a + b) @:commutative
	static inline function addScalar(a: Vec3, b: Float): Vec3
		return new Vec3(a.x + b, a.y + b, a.z + b);

	@:op(a - b)
	static inline function sub(a: Vec3, b: Vec3): Vec3
		return new Vec3(a.x - b.x, a.y - b.y, a.z - b.z);

	@:op(a - b)
	static inline function subScalar(a: Vec3, b: Float): Vec3
		return new Vec3(a.x - b, a.y - b, a.z - b);

	@:op(b - a)
	static inline function subScalarInv(a: Float, b: Vec3): Vec3
		return new Vec3(a - b.x, a - b.y, a - b.z);

	@:op(a == b)
	static inline function equal(a: Vec3, b: Vec3): Bool
		return a.x == b.x && a.y == b.y && a.z == b.z;

	@:op(a != b)
	static inline function notEqual(a: Vec3, b: Vec3): Bool
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
	public macro function copyIntoArray(self: haxe.macro.Expr.ExprOf<Vec3>, array: haxe.macro.Expr.ExprOf<ArrayAccess<Float>>, index: haxe.macro.Expr.ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array[2 + i] = self.z;
			array;
		}
	}
	
}

@:noCompletion
class Vec3Data {
	#if !macro
	public var x: Float;
	public var y: Float;
	public var z: Float;

	public inline function new(x: Float, y: Float, z: Float) {
		// the + 0.0 helps the optimizer realize it can collapse const float operations
		this.x = x + 0.0;
		this.y = y + 0.0;
		this.z = z + 0.0;
	}
	#end
}