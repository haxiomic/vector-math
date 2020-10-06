/**
	# Vector Mathematics Library

	Enables GLSL vector and matrix operations to compile in haxe

	Reference Spec GLSL ES 1.0: https://www.khronos.org/files/opengles_shading_language.pdf

	@license MIT
	@author haxiomic (George Corney)
	@version 1.1.0
**/

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

// # Built-in Functions

// trigonometric

@:overload(function(degrees: Float): Float {})
@:overload(function(degrees: Vec2): Vec2 {})
@:overload(function(degrees: Vec3): Vec3 {})
@:overload(function(degrees: Vec4): Vec4 {})
macro function radians(degrees) return useCurrentPos(
	switch mapVecType(degrees) {
		case 1: macro ($degrees * Math.PI / 180);
		default: macro $degrees.radians();
	}
);

@:overload(function(radians: Float): Float {})
@:overload(function(radians: Vec2): Vec2 {})
@:overload(function(radians: Vec3): Vec3 {})
@:overload(function(radians: Vec4): Vec4 {})
macro function degrees(radians) return useCurrentPos(
	switch mapVecType(radians) {
		case 1: macro ($radians * 180 / Math.PI);
		default: macro $radians.degrees();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function sin(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.sin($v);
		default: macro $v.sin();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function cos(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.cos($v);
		default: macro $v.cos();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function tan(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.tan($v);
		default: macro $v.tan();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function asin(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.asin($v);
		default: macro $v.asin();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function acos(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.acos($v);
		default: macro $v.acos();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function atan(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.atan($v);
		default: macro $v.atan();
	}
);

@:overload(function(v: Float, b: Float): Float {})
@:overload(function(v: Vec2, b: Vec2): Vec2 {})
@:overload(function(v: Vec3, b: Vec3): Vec3 {})
@:overload(function(v: Vec4, b: Vec4): Vec4 {})
macro function atan2(v, b) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.atan2($v, $b);
		default: macro $v.atan2($b);
	}
);

// exponential

@:overload(function(v: Float, e: Float): Float {})
@:overload(function(v: Vec2, e: Vec2): Vec2 {})
@:overload(function(v: Vec3, e: Vec3): Vec3 {})
@:overload(function(v: Vec4, e: Vec4): Vec4 {})
macro function pow(v, e) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.pow($v, $e);
		default: macro $v.pow($e);
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function exp(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.exp($v);
		default: macro $v.exp();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function log(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.log($v);
		default: macro $v.log();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function exp2(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.pow(2, $v);
		default: macro $v.exp2();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function log2(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.log($v) * 1.4426950408889634;
		default: macro $v.log2();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function sqrt(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.sqrt($v);
		default: macro $v.sqrt();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function inverseSqrt(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro (1.0 / Math.sqrt($v));
		default: macro $v.inverseSqrt();
	}
);

// common

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function abs(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.abs($v);
		default: macro $v.abs();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function sign(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			v > 0. ? 1. : (v < 0. ? -1. : 0.);
		}
		default: macro $v.sign();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function floor(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.floor($v);
		default: macro $v.floor();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function ceil(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.ceil($v);
		default: macro $v.ceil();
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function fract(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			v - Math.floor(v);
		};
		default: macro $v.fract();
	}
);

@:overload(function(v: Float, d: Float): Float {})
@:overload(function(v: Vec2, d: Vec2): Vec2 {})
@:overload(function(v: Vec2, d: Float): Vec2 {})
@:overload(function(v: Vec3, d: Vec3): Vec3 {})
@:overload(function(v: Vec3, d: Float): Vec3 {})
@:overload(function(v: Vec4, d: Vec4): Vec4 {})
@:overload(function(v: Vec4, d: Float): Vec4 {})
macro function mod(v, d) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			var d: Float = $d;
			(v - d * Math.floor(v / d));
		}
		default: switch mapVecType(d) {
			case 1: macro $v.modf($d);
			default: macro $v.mod($d);
		}
	}
);

@:overload(function(v: Float, b: Float): Float {})
@:overload(function(v: Vec2, b: Vec2): Vec2 {})
@:overload(function(v: Vec2, b: Float): Vec2 {})
@:overload(function(v: Vec3, b: Vec3): Vec3 {})
@:overload(function(v: Vec3, b: Float): Vec3 {})
@:overload(function(v: Vec4, b: Vec4): Vec4 {})
@:overload(function(v: Vec4, b: Float): Vec4 {})
macro function min(v, b) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.min($v, $b);
		default: switch mapVecType(b) {
			case 1: macro $v.minf($b);
			default: macro $v.min($b);
		}
	}
);

@:overload(function(v: Float, b: Float): Float {})
@:overload(function(v: Vec2, b: Vec2): Vec2 {})
@:overload(function(v: Vec2, b: Float): Vec2 {})
@:overload(function(v: Vec3, b: Vec3): Vec3 {})
@:overload(function(v: Vec3, b: Float): Vec3 {})
@:overload(function(v: Vec4, b: Vec4): Vec4 {})
@:overload(function(v: Vec4, b: Float): Vec4 {})
macro function max(v, b) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.max($v, $b);
		default: switch mapVecType(b) {
			case 1: macro $v.maxf($b);
			default: macro $v.max($b);
		}
	}
);

@:overload(function(v: Float, min: Float, max: Float): Float {})
@:overload(function(v: Vec2, min: Vec2, max: Vec2): Vec2 {})
@:overload(function(v: Vec2, min: Float, max: Float): Vec2 {})
@:overload(function(v: Vec3, min: Vec3, max: Vec3): Vec3 {})
@:overload(function(v: Vec3, min: Float, max: Float): Vec3 {})
@:overload(function(v: Vec4, min: Vec4, max: Vec4): Vec4 {})
@:overload(function(v: Vec4, min: Float, max: Float): Vec4 {})
macro function clamp(v, min, max) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			var min: Float = $min;
			var max: Float = $max;
			v < min ? min : (v > max ? max : v);
		}
		default: switch [mapVecType(min), mapVecType(max)] {
			case [1, 1]: macro $v.clampf($min, $max);
			default: macro $v.clamp($min, $max);
		} 
	}
);

@:overload(function(a: Float, b: Float, t: Float): Float {})
@:overload(function(a: Vec2, b: Vec2, t: Vec2): Vec2 {})
@:overload(function(a: Vec2, b: Vec2, t: Float): Vec2 {})
@:overload(function(a: Vec3, b: Vec3, t: Vec3): Vec3 {})
@:overload(function(a: Vec3, b: Vec3, t: Float): Vec3 {})
@:overload(function(a: Vec4, b: Vec4, t: Vec4): Vec4 {})
@:overload(function(a: Vec4, b: Vec4, t: Float): Vec4 {})
macro function mix(a, b, t) return useCurrentPos(
	switch mapVecType(a) {
		case 1: macro {
			var a: Float = $a;
			var b: Float = $b;
			var t: Float = $t;
			a * (1.0 - t) + b * t;
		}
		default: switch mapVecType(t) {
			case 1: macro $a.mixf($b, $t);
			default: macro $a.mix($b, $t);
		}
	}
);

@:overload(function(edge: Float, v: Float): Float {})
@:overload(function(edge: Vec2, v: Vec2): Vec2 {})
@:overload(function(edge: Float, v: Vec2): Vec2 {})
@:overload(function(edge: Vec3, v: Vec3): Vec3 {})
@:overload(function(edge: Float, v: Vec3): Vec3 {})
@:overload(function(edge: Vec4, v: Vec4): Vec4 {})
@:overload(function(edge: Float, v: Vec4): Vec4 {})
macro function step(edge, v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			var edge: Float = $edge;
			v < edge ? 0.0 : 1.0;
		}
		default: switch mapVecType(edge) {
			case 1: macro $v.stepf($edge);
			default: macro $v.step($edge);
		}
	}
);

@:overload(function(edge0: Float, edge1: Float, v: Float): Float {})
@:overload(function(edge0: Vec2, edge1: Vec2, v: Vec2): Vec2 {})
@:overload(function(edge0: Float, edge1: Float, v: Vec2): Vec2 {})
@:overload(function(edge0: Vec3, edge1: Vec3, v: Vec3): Vec3 {})
@:overload(function(edge0: Float, edge1: Float, v: Vec3): Vec3 {})
@:overload(function(edge0: Vec4, edge1: Vec4, v: Vec4): Vec4 {})
@:overload(function(edge0: Float, edge1: Float, v: Vec4): Vec4 {})
macro function smoothstep(edge0, edge1, v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			var edge0: Float = $edge0;
			var edge1: Float = $edge1;
			var t = (v - edge0) / (edge1 - edge0);
			t = t < 0. ? 0. : (t > 1. ? 1. : t); // clamp to 0, 1
			t * t * (3.0 - 2.0 * t);
		}
		default: switch [mapVecType(edge0), mapVecType(edge1)] {
			case [1, 1]: macro $v.smoothstepf($edge0, $edge1);
			default: macro $v.smoothstep($edge0, $edge1);
		}
	}
);

// geometric

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Float {})
@:overload(function(v: Vec3): Float {})
@:overload(function(v: Vec4): Float {})
macro function length(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.abs($v);
		default: macro $v.length();
	}
);

@:overload(function(v: Float, b: Float): Float {})
@:overload(function(v: Vec2, b: Vec2): Float {})
@:overload(function(v: Vec3, b: Vec3): Float {})
@:overload(function(v: Vec4, b: Vec4): Float {})
macro function distance(v, b) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro Math.abs(($v) - ($b));
		default: macro $v.distance($b);
	}
);

@:overload(function(v: Float, b: Float): Float {})
@:overload(function(v: Vec2, b: Vec2): Float {})
@:overload(function(v: Vec3, b: Vec3): Float {})
@:overload(function(v: Vec4, b: Vec4): Float {})
macro function dot(v, b) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro (($v) * ($b));
		default: macro $v.dot($b);
	}
);

@:overload(function(v: Float): Float {})
@:overload(function(v: Vec2): Vec2 {})
@:overload(function(v: Vec3): Vec3 {})
@:overload(function(v: Vec4): Vec4 {})
macro function normalize(v) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro 1.0;
		default: macro $v.normalize();
	}
);

@:overload(function(v: Float, I: Float, Nref: Float): Float {})
@:overload(function(v: Vec2, I: Vec2, Nref: Vec2): Vec2 {})
@:overload(function(v: Vec3, I: Vec3, Nref: Vec3): Vec3 {})
@:overload(function(v: Vec4, I: Vec4, Nref: Vec4): Vec4 {})
macro function faceforward(v, I, Nref) return useCurrentPos(
	switch mapVecType(v) {
		case 1: macro {
			var v: Float = $v;
			var I: Float = $I;
			var Nref: Float = $Nref;
			(I * Nref < 0 ? v : -v);
		}
		default: macro $v.faceforward($I, $Nref);
	}
);

@:overload(function(I: Float, N: Float): Float {})
@:overload(function(I: Vec2, N: Vec2): Vec2 {})
@:overload(function(I: Vec3, N: Vec3): Vec3 {})
@:overload(function(I: Vec4, N: Vec4): Vec4 {})
macro function reflect(I, N) return useCurrentPos(
	switch mapVecType(I) {
		case 1: macro {
			var I: Float = $I;
			var N: Float = $N;
			I - 2 * (N * I) * N;
		};
		default: macro $I.reflect($N);
	}
);

@:overload(function(I: Float, N: Float, eta: Float): Float {})
@:overload(function(I: Vec2, N: Vec2, eta: Float): Vec2 {})
@:overload(function(I: Vec3, N: Vec3, eta: Float): Vec3 {})
@:overload(function(I: Vec4, N: Vec4, eta: Float): Vec4 {})
macro function refract(I, N, eta: ExprOf<Float>) return useCurrentPos(
	switch mapVecType(I) {
		case 1: macro {
			var I: Float = $I;
			var N: Float = $N;
			var eta: Float = $eta;
			var nDotI = I * N;
			var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
			if (k < 0.0) {
				0.0;
			} else {
				eta * I - (eta * nDotI + Math.sqrt(k)) * N;
			}
		};
		default: macro $I.refract($N, $eta);
	}
);

// special-case functions
@:overload(function(m: Mat2, n: Mat2): Mat2 {})
macro function matrixCompMult(a, b) {
	return macro $a.matrixCompMult($b);
}

inline function cross(a: Vec3, b: Vec3) {
	return a.cross(b);
}

// # Vector Initializers
// macros are used to enable function overloads which makes vector composition possible, for example: `vec4(vec2(1,2), vec2(3,4))`

@:overload(function(x: Float, y: Float): Vec2 {})
@:overload(function(x: Float): Vec2 {})
@:overload(function(xy: Vec2): Vec2 {})
macro function vec2(a, ?b): ExprOf<Vec2> {
	return useCurrentPos(vectorConstructor(2, [a, b]));
}

@:overload(function(x: Float, y: Float, z: Float): Vec3 {})
@:overload(function(x: Float): Vec3 {})
@:overload(function(x: Float, yz: Vec2): Vec3 {})
@:overload(function(xy: Vec2, z: Float): Vec3 {})
@:overload(function(xyz: Vec3): Vec3 {})
macro function vec3(a, ?b, ?c): ExprOf<Vec3> {
	return useCurrentPos(vectorConstructor(3, [a, b, c]));
}

@:overload(function(x: Float, y: Float, z: Float, w: Float): Vec4 {})
@:overload(function(x: Float): Vec4 {})
@:overload(function(xy: Vec2, z: Float, w: Float): Vec4 {})
@:overload(function(x: Float, yz: Vec2, w: Float): Vec4 {})
@:overload(function(x: Float, y: Float, zw: Vec2): Vec4 {})
@:overload(function(xy: Vec2, zw: Vec2): Vec4 {})
@:overload(function(xyz: Vec3, w: Float): Vec4 {})
@:overload(function(x: Float, yzw: Vec3): Vec4 {})
@:overload(function(xyzw: Vec4): Vec4 {})
macro function vec4(a, ?b, ?c, ?d): ExprOf<Vec4> {
	return useCurrentPos(vectorConstructor(4, [a, b, c, d]));
}

@:overload(function(a00: Float, a01: Float, a10: Float, a11: Float): Mat2 {})
@:overload(function(column0: Vec2, column1: Vec2): Mat2 {})
@:overload(function(xyzw: Vec4): Mat2 {})
macro function mat2(a, ?b, ?c, ?d): ExprOf<Mat2> {
	return useCurrentPos(matrixConstructor({name: 'Mat2',pack:[]}, 2, 2, [a, b, c, d]));
}

@:overload(function(
	a00: Float, a01: Float, a02: Float,
	a10: Float, a11: Float, a12: Float,
	a20: Float, a21: Float, a22: Float
): Mat3 {})
@:overload(function(column0: Vec3, column1: Vec3, column2: Vec3): Mat3 {})
macro function mat3(a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i): ExprOf<Mat3> {
	return useCurrentPos(matrixConstructor({name: 'Mat3',pack:[]}, 3, 3, [a, b, c, d, e, f, g, h, i]));
}

@:overload(function(
	a00: Float, a01: Float, a02: Float, a03: Float,
	a10: Float, a11: Float, a12: Float, a13: Float,
	a20: Float, a21: Float, a22: Float, a23: Float,
	a30: Float, a31: Float, a32: Float, a33: Float
): Mat4 {})
@:overload(function(column0: Vec4, column1: Vec4, column2: Vec4, column3: Vec4): Mat4 {})
macro function mat4(a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i, ?j, ?k, ?l, ?m, ?n, ?o, ?p): ExprOf<Mat4> {
	return useCurrentPos(matrixConstructor({name: 'Mat4',pack:[]}, 4, 4, [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p]));
}

// # Types

@:notNull
@:nullSafety
#if !macro @:build(VectorMath.Swizzle.generateFields(2)) #end
abstract Vec2(Vec2Data) to Vec2Data from Vec2Data {

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
	public inline function log2(): Vec2 {
		return log() * 1.4426950408889634;
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
	public inline function mod(d): Vec2 {
		return (this: Vec2) - ((this: Vec2) / d).floor();
	}
	public inline function modf(d: Float): Vec2 {
		return (this: Vec2) - ((this: Vec2) / d).floor();
	}
	public inline function min(b: Vec2): Vec2 {
		return new Vec2(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y
		);
	}
	public inline function minf(b: Float): Vec2 {
		return new Vec2(
			b < x ? b : x,
			b < y ? b : y
		);
	}
	public inline function max(b: Vec2): Vec2 {
		return new Vec2(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y
		);
	}
	public inline function maxf(b: Float): Vec2 {
		return new Vec2(
			x < b ? b : x,
			y < b ? b : y
		);
	}
	public inline function clamp(minLimit: Vec2, maxLimit: Vec2) {
		return max(minLimit).min(maxLimit);
	}
	public inline function clampf(minLimit: Float, maxLimit: Float) {
		return maxf(minLimit).minf(maxLimit);
	}

	public inline function mix(b: Vec2, t: Vec2): Vec2 {
		return (this: Vec2) * (1.0 - t) + b * t;
	}
	public inline function mixf(b: Vec2, t: Float): Vec2 {
		return (this: Vec2) * (1.0 - t) + b * t;
	}

	public inline function step(edge: Vec2): Vec2 {
		return new Vec2(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0
		);
	}
	public inline function stepf(edge: Float): Vec2 {
		return new Vec2(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0
		);
	}

	public inline function smoothstep(edge0: Vec2, edge1: Vec2): Vec2 {
		var t = (((this: Vec2) - edge0) / (edge1 - edge0)).clampf(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public inline function smoothstepf(edge0: Float, edge1: Float): Vec2 {
		var t = (((this: Vec2) - edge0) / (edge1 - edge0)).clampf(0, 1);
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
		return (this: Vec2) / length();
	}

	public inline function faceforward(I: Vec2, Nref: Vec2): Vec2 {
		return Nref.dot(I) < 0 ? new Vec2(x, y) : new Vec2(-x, -y);
	}
	public inline function reflect(N: Vec2): Vec2 {
		var I = (this: Vec2);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec2, eta: Float): Vec2 {
		var I = (this: Vec2);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return if (k < 0.0) {
			new Vec2(0., 0.);
		} else {
			eta * I - (eta * nDotI + Math.sqrt(k)) * N;
		}
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
	
}

private class Vec2Data {

	public var x: Float;
	public var y: Float;

	public inline function new(x: Float, y: Float) {
		// the + 0.0 helps the optimizer realize it can collapse const float operations
		this.x = x + 0.0;
		this.y = y + 0.0;
	}

}

@:notNull
@:nullSafety
#if !macro @:build(VectorMath.Swizzle.generateFields(3)) #end
abstract Vec3(Vec3Data) to Vec3Data from Vec3Data {

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
	public inline function log2(): Vec3 {
		return log() * 1.4426950408889634;
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
	public inline function mod(d): Vec3 {
		return (this: Vec3) - ((this: Vec3) / d).floor();
	}
	public inline function modf(d: Float): Vec3 {
		return (this: Vec3) - ((this: Vec3) / d).floor();
	}
	public inline function min(b: Vec3): Vec3 {
		return new Vec3(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y,
			b.z < z ? b.z : z
		);
	}
	public inline function minf(b: Float): Vec3 {
		return new Vec3(
			b < x ? b : x,
			b < y ? b : y,
			b < z ? b : z
		);
	}
	public inline function max(b: Vec3): Vec3 {
		return new Vec3(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y,
			z < b.z ? b.z : z
		);
	}
	public inline function maxf(b: Float): Vec3 {
		return new Vec3(
			x < b ? b : x,
			y < b ? b : y,
			z < b ? b : z
		);
	}
	public inline function clamp(minLimit: Vec3, maxLimit: Vec3) {
		return max(minLimit).min(maxLimit);
	}
	public inline function clampf(minLimit: Float, maxLimit: Float) {
		return maxf(minLimit).minf(maxLimit);
	}

	public inline function mix(b: Vec3, t: Vec3): Vec3 {
		return (this: Vec3) * (1.0 - t) + b * t;
	}
	public inline function mixf(b: Vec3, t: Float): Vec3 {
		return (this: Vec3) * (1.0 - t) + b * t;
	}

	public inline function step(edge: Vec3): Vec3 {
		return new Vec3(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0,
			z < edge.z ? 0.0 : 1.0
		);
	}
	public inline function stepf(edge: Float): Vec3 {
		return new Vec3(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0,
			z < edge ? 0.0 : 1.0
		);
	}

	public inline function smoothstep(edge0: Vec3, edge1: Vec3): Vec3 {
		var t = (((this: Vec3) - edge0) / (edge1 - edge0)).clampf(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public inline function smoothstepf(edge0: Float, edge1: Float): Vec3 {
		var t = (((this: Vec3) - edge0) / (edge1 - edge0)).clampf(0, 1);
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
		return (this: Vec3) / length();
	}

	public inline function faceforward(I: Vec3, Nref: Vec3): Vec3 {
		return Nref.dot(I) < 0 ? new Vec3(x, y, z) : new Vec3(-x, -y, -z);
	}
	public inline function reflect(N: Vec3): Vec3 {
		var I = (this: Vec3);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec3, eta: Float): Vec3 {
		var I = (this: Vec3);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return if (k < 0.0) {
			new Vec3(0., 0., 0.);
		} else {
			eta * I - (eta * nDotI + Math.sqrt(k)) * N;
		}
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
	
}

private class Vec3Data {

	public var x: Float;
	public var y: Float;
	public var z: Float;

	public inline function new(x: Float, y: Float, z: Float) {
		// the + 0.0 helps the optimizer realize it can collapse const float operations
		this.x = x + 0.0;
		this.y = y + 0.0;
		this.z = z + 0.0;
	}

}

@:notNull
@:nullSafety
#if !macro @:build(VectorMath.Swizzle.generateFields(4)) #end
abstract Vec4(Vec4Data) to Vec4Data from Vec4Data {

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
	public inline function log2(): Vec4 {
		return log() * 1.4426950408889634;
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
	public inline function mod(d): Vec4 {
		return (this: Vec4) - ((this: Vec4) / d).floor();
	}
	public inline function modf(d: Float): Vec4 {
		return (this: Vec4) - ((this: Vec4) / d).floor();
	}
	public inline function min(b: Vec4): Vec4 {
		return new Vec4(
			b.x < x ? b.x : x,
			b.y < y ? b.y : y,
			b.z < z ? b.z : z,
			b.w < w ? b.w : w
		);
	}
	public inline function minf(b: Float): Vec4 {
		return new Vec4(
			b < x ? b : x,
			b < y ? b : y,
			b < z ? b : z,
			b < w ? b : w
		);
	}
	public inline function max(b: Vec4): Vec4 {
		return new Vec4(
			x < b.x ? b.x : x,
			y < b.y ? b.y : y,
			z < b.z ? b.z : z,
			w < b.w ? b.w : w
		);
	}
	public inline function maxf(b: Float): Vec4 {
		return new Vec4(
			x < b ? b : x,
			y < b ? b : y,
			z < b ? b : z,
			w < b ? b : w
		);
	}
	public inline function clamp(minLimit: Vec4, maxLimit: Vec4) {
		return max(minLimit).min(maxLimit);
	}
	public inline function clampf(minLimit: Float, maxLimit: Float) {
		return maxf(minLimit).minf(maxLimit);
	}

	public inline function mix(b: Vec4, t: Vec4): Vec4 {
		return (this: Vec4) * (1.0 - t) + b * t;
	}
	public inline function mixf(b: Vec4, t: Float): Vec4 {
		return (this: Vec4) * (1.0 - t) + b * t;
	}

	public inline function step(edge: Vec4): Vec4 {
		return new Vec4(
			x < edge.x ? 0.0 : 1.0,
			y < edge.y ? 0.0 : 1.0,
			z < edge.z ? 0.0 : 1.0,
			w < edge.w ? 0.0 : 1.0
		);
	}
	public inline function stepf(edge: Float): Vec4 {
		return new Vec4(
			x < edge ? 0.0 : 1.0,
			y < edge ? 0.0 : 1.0,
			z < edge ? 0.0 : 1.0,
			w < edge ? 0.0 : 1.0
		);
	}

	public inline function smoothstep(edge0: Vec4, edge1: Vec4): Vec4 {
		var t = (((this: Vec4) - edge0) / (edge1 - edge0)).clampf(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}
	public inline function smoothstepf(edge0: Float, edge1: Float): Vec4 {
		var t = (((this: Vec4) - edge0) / (edge1 - edge0)).clampf(0, 1);
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
		return (this: Vec4) / length();
	}

	public inline function faceforward(I: Vec4, Nref: Vec4): Vec4 {
		return Nref.dot(I) < 0 ? new Vec4(x, y, z, w) : new Vec4(-x, -y, -z, -w);
	}
	public inline function reflect(N: Vec4): Vec4 {
		var I = (this: Vec4);
		return I - 2 * N.dot(I) * N;
	}
	public inline function refract(N: Vec4, eta: Float): Vec4 {
		var I = (this: Vec4);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return if (k < 0.0) {
			new Vec4(0., 0., 0., 0.0);
		} else {
			eta * I - (eta * nDotI + Math.sqrt(k)) * N;
		}
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
	
}

private class Vec4Data {

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

}

@:notNull
abstract Mat2(Mat2Data) from Mat2Data to Mat2Data {

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

	public inline function matrixCompMult(n: Mat2) {
		var n: Mat2Data = n;
		return new Mat2(
			this.c0.x * n.c0.x, this.c0.y * n.c0.y,
			this.c1.x * n.c1.x, this.c1.y * n.c1.y
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

}

private class Mat2Data {

	public var c0: Vec2;
	public var c1: Vec2;

	public inline function new(
		a00: Float, a01: Float,
		a10: Float, a11: Float
	) {
		c0 = new Vec2(a00, a01);
		c1 = new Vec2(a10, a11);
	}

}

@:notNull
abstract Mat3(Mat3Data) from Mat3Data to Mat3Data {

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

	public inline function matrixCompMult(n: Mat3) {
		var n: Mat3Data = n;
		return new Mat3(
			this.c0.x * n.c0.x, this.c0.y * n.c0.y, this.c0.z * n.c0.z,
			this.c1.x * n.c1.x, this.c1.y * n.c1.y, this.c1.z * n.c1.z,
			this.c2.x * n.c2.x, this.c2.y * n.c2.y, this.c2.z * n.c2.z
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

}

private class Mat3Data {

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

}

@:notNull
abstract Mat4(Mat4Data) from Mat4Data to Mat4Data {

	public inline function new(
		a00: Float, a01: Float, a02: Float, a03: Float,
		a10: Float, a11: Float, a12: Float, a13: Float,
		a20: Float, a21: Float, a22: Float, a23: Float,
		a30: Float, a31: Float, a32: Float, a33: Float
	) {
		this = new Mat4Data(
			a00, a01, a02, a03,
			a10, a11, a12, a13,
			a20, a21, a22, a23,
			a30, a31, a32, a33
		);
	}
	
	public inline function copyFrom(v: Mat4) {
		var v: Mat4Data = v;
		this.c0.copyFrom(v.c0);
		this.c1.copyFrom(v.c1);
		this.c2.copyFrom(v.c2);
		this.c3.copyFrom(v.c3);
		return this;
	}

	public inline function clone(): Mat4 {
		return new Mat4(
			this.c0.x, this.c0.y, this.c0.z, this.c0.w,
			this.c1.x, this.c1.y, this.c1.z, this.c1.w,
			this.c2.x, this.c2.y, this.c2.z, this.c2.w,
			this.c3.x, this.c3.y, this.c3.z, this.c3.w
		);
	}
	
	public inline function matrixCompMult(n: Mat4) {
		var n: Mat4Data = n;
		return new Mat4(
			this.c0.x * n.c0.x, this.c0.y * n.c0.y, this.c0.z * n.c0.z, this.c0.w * n.c0.w,
			this.c1.x * n.c1.x, this.c1.y * n.c1.y, this.c1.z * n.c1.z, this.c1.w * n.c1.w,
			this.c2.x * n.c2.x, this.c2.y * n.c2.y, this.c2.z * n.c2.z, this.c2.w * n.c2.w,
			this.c3.x * n.c3.x, this.c3.y * n.c3.y, this.c3.z * n.c3.z, this.c3.w * n.c3.w
		);
	}
	
	public inline function toString() {
		return 'mat4(' +
			'${this.c0.x}, ${this.c0.y}, ${this.c0.z}, ${this.c0.w}, ' +
			'${this.c1.x}, ${this.c1.y}, ${this.c1.z}, ${this.c1.w}, ' +
			'${this.c2.x}, ${this.c2.y}, ${this.c2.z}, ${this.c2.w}, ' +
			'${this.c3.x}, ${this.c3.y}, ${this.c3.z}, ${this.c3.w}' +
		')';
	}

	@:op([])
	inline function arrayRead(i: Int)
		return switch i {
			case 0: this.c0.clone();
			case 1: this.c1.clone();
			case 2: this.c2.clone();
			case 3: this.c3.clone();
			default: null;
		}

	@:op([])
	inline function arrayWrite(i: Int, v: Vec4)
		return switch i {
			case 0: this.c0.copyFrom(v);
			case 1: this.c1.copyFrom(v);
			case 2: this.c2.copyFrom(v);
			case 3: this.c3.copyFrom(v);
			default: null;
		}

	@:op(-a)
	static inline function neg(m: Mat4) {
		var m: Mat4Data = m;
		return new Mat4(
			-m.c0.x, -m.c0.y, -m.c0.z, -m.c0.w,
			-m.c1.x, -m.c1.y, -m.c1.z, -m.c1.w,
			-m.c2.x, -m.c2.y, -m.c2.z, -m.c2.w,
			-m.c3.x, -m.c3.y, -m.c3.z, -m.c3.w
		);
	}

	@:op(++a)
	static inline function prefixIncrement(m: Mat4) {
		var _m: Mat4Data = m;
		++_m.c0; ++_m.c1; ++_m.c2; ++_m.c3;
		return m.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(m: Mat4) {
		var _m: Mat4Data = m;
		--_m.c0; --_m.c1; --_m.c2; --_m.c3;
		return m.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(m: Mat4) {
		var ret = m.clone();
		var m: Mat4Data = m;
		++m.c0; ++m.c1; ++m.c2; ++m.c3;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(m: Mat4) {
		var ret = m.clone();
		var m: Mat4Data = m;
		--m.c0; --m.c1; --m.c2; --m.c3;
		return ret;
	}

	// assignment overload should come before other binary ops to ensure they have priority
	@:op(a *= b)
	static inline function mulEq(a: Mat4, b: Mat4): Mat4
		return a.copyFrom(a * b);

	@:op(a *= b)
	static inline function mulEqScalar(a: Mat4, f: Float): Mat4
		return a.copyFrom(a * f);

	@:op(a /= b)
	static inline function divEq(a: Mat4, b: Mat4): Mat4
		return a.copyFrom(a / b);

	@:op(a /= b)
	static inline function divEqScalar(a: Mat4, f: Float): Mat4
		return a.copyFrom(a / f);

	@:op(a += b)
	static inline function addEq(a: Mat4, b: Mat4): Mat4
		return a.copyFrom(a + b);

	@:op(a += b)
	static inline function addEqScalar(a: Mat4, f: Float): Mat4
		return a.copyFrom(a + f);

	@:op(a -= b)
	static inline function subEq(a: Mat4, b: Mat4): Mat4
		return a.copyFrom(a - b);

	@:op(a -= b)
	static inline function subEqScalar(a: Mat4, f: Float): Mat4
		return a.copyFrom(a - f);

	@:op(a + b)
	static inline function add(m: Mat4, n: Mat4): Mat4 {
		var m: Mat4Data = m;
		var n: Mat4Data = n;
		return new Mat4(
			m.c0.x + n.c0.x, m.c0.y + n.c0.y, m.c0.z + n.c0.z, m.c0.w + n.c0.w,
			m.c1.x + n.c1.x, m.c1.y + n.c1.y, m.c1.z + n.c1.z, m.c1.w + n.c1.w,
			m.c2.x + n.c2.x, m.c2.y + n.c2.y, m.c2.z + n.c2.z, m.c2.w + n.c2.w,
			m.c3.x + n.c3.x, m.c3.y + n.c3.y, m.c3.z + n.c3.z, m.c3.w + n.c3.w
		);
	}

	@:op(a + b) @:commutative
	static inline function addScalar(m: Mat4, f: Float): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			m.c0.x + f, m.c0.y + f, m.c0.z + f, m.c0.w + f,
			m.c1.x + f, m.c1.y + f, m.c1.z + f, m.c1.w + f,
			m.c2.x + f, m.c2.y + f, m.c2.z + f, m.c2.w + f,
			m.c3.x + f, m.c3.y + f, m.c3.z + f, m.c3.w + f
		);
	}

	@:op(a - b)
	static inline function sub(m: Mat4, n: Mat4): Mat4 {
		var m: Mat4Data = m;
		var n: Mat4Data = n;
		return new Mat4(
			m.c0.x - n.c0.x, m.c0.y - n.c0.y, m.c0.z - n.c0.z, m.c0.w - n.c0.w,
			m.c1.x - n.c1.x, m.c1.y - n.c1.y, m.c1.z - n.c1.z, m.c1.w - n.c1.w,
			m.c2.x - n.c2.x, m.c2.y - n.c2.y, m.c2.z - n.c2.z, m.c2.w - n.c2.w,
			m.c3.x - n.c3.x, m.c3.y - n.c3.y, m.c3.z - n.c3.z, m.c3.w - n.c3.w
		);
	}

	@:op(a - b)
	static inline function subScalar(m: Mat4, f: Float): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			m.c0.x - f, m.c0.y - f, m.c0.z - f, m.c0.w - f,
			m.c1.x - f, m.c1.y - f, m.c1.z - f, m.c1.w - f,
			m.c2.x - f, m.c2.y - f, m.c2.z - f, m.c2.w - f,
			m.c3.x - f, m.c3.y - f, m.c3.z - f, m.c3.w - f
		);
	}

	@:op(a - b)
	static inline function subScalarInv(f: Float, m: Mat4): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			f - m.c0.x, f - m.c0.y, f - m.c0.z, f - m.c0.w,
			f - m.c1.x, f - m.c1.y, f - m.c1.z, f - m.c1.w,
			f - m.c2.x, f - m.c2.y, f - m.c2.z, f - m.c2.w,
			f - m.c3.x, f - m.c3.y, f - m.c3.z, f - m.c3.w
		);
	}

	

	@:op(a * b)
	static inline function mul(m: Mat4, n: Mat4): Mat4 {
		var m: Mat4Data = m;
		var n: Mat4Data = n;
		return new Mat4(
			m.c0.x * n.c0.x + m.c1.x * n.c0.y + m.c2.x * n.c0.z + m.c3.x * n.c0.w,
			m.c0.y * n.c0.x + m.c1.y * n.c0.y + m.c2.y * n.c0.z + m.c3.y * n.c0.w,
			m.c0.z * n.c0.x + m.c1.z * n.c0.y + m.c2.z * n.c0.z + m.c3.z * n.c0.w,
			m.c0.w * n.c0.x + m.c1.w * n.c0.y + m.c2.w * n.c0.z + m.c3.w * n.c0.w,
			m.c0.x * n.c1.x + m.c1.x * n.c1.y + m.c2.x * n.c1.z + m.c3.x * n.c1.w,
			m.c0.y * n.c1.x + m.c1.y * n.c1.y + m.c2.y * n.c1.z + m.c3.y * n.c1.w,
			m.c0.z * n.c1.x + m.c1.z * n.c1.y + m.c2.z * n.c1.z + m.c3.z * n.c1.w,
			m.c0.w * n.c1.x + m.c1.w * n.c1.y + m.c2.w * n.c1.z + m.c3.w * n.c1.w,
			m.c0.x * n.c2.x + m.c1.x * n.c2.y + m.c2.x * n.c2.z + m.c3.x * n.c2.w,
			m.c0.y * n.c2.x + m.c1.y * n.c2.y + m.c2.y * n.c2.z + m.c3.y * n.c2.w,
			m.c0.z * n.c2.x + m.c1.z * n.c2.y + m.c2.z * n.c2.z + m.c3.z * n.c2.w,
			m.c0.w * n.c2.x + m.c1.w * n.c2.y + m.c2.w * n.c2.z + m.c3.w * n.c2.w,
			m.c0.x * n.c3.x + m.c1.x * n.c3.y + m.c2.x * n.c3.z + m.c3.x * n.c3.w,
			m.c0.y * n.c3.x + m.c1.y * n.c3.y + m.c2.y * n.c3.z + m.c3.y * n.c3.w,
			m.c0.z * n.c3.x + m.c1.z * n.c3.y + m.c2.z * n.c3.z + m.c3.z * n.c3.w,
			m.c0.w * n.c3.x + m.c1.w * n.c3.y + m.c2.w * n.c3.z + m.c3.w * n.c3.w
		);
	}
	
	@:op(a * b)
	static inline function postMulVec4(m: Mat4, v: Vec4): Vec4 {
		var m: Mat4Data = m;
		return new Vec4(
			m.c0.x * v.x + m.c1.x * v.y + m.c2.x * v.z + m.c3.x * v.w,
			m.c0.y * v.x + m.c1.y * v.y + m.c2.y * v.z + m.c3.y * v.w,
			m.c0.z * v.x + m.c1.z * v.y + m.c2.z * v.z + m.c3.z * v.w,
			m.c0.w * v.x + m.c1.w * v.y + m.c2.w * v.z + m.c3.w * v.w
		);
	}

	@:op(a * b)
	static inline function preMulVec4(v: Vec4, m: Mat4): Vec4 {
		var m: Mat4Data = m;
		return new Vec4(
			v.dot(m.c0),
			v.dot(m.c1),
			v.dot(m.c2),
			v.dot(m.c3)
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(m: Mat4, f: Float): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			m.c0.x * f, m.c0.y * f, m.c0.z * f, m.c0.w * f,
			m.c1.x * f, m.c1.y * f, m.c1.z * f, m.c1.w * f,
			m.c2.x * f, m.c2.y * f, m.c2.z * f, m.c2.w * f,
			m.c3.x * f, m.c3.y * f, m.c3.z * f, m.c3.w * f
		);
	}

	@:op(a / b)
	static inline function div(m: Mat4, n: Mat4): Mat4
		return m.matrixCompMult(1.0 / n);

	@:op(a / b)
	static inline function divScalar(m: Mat4, f: Float): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			m.c0.x / f, m.c0.y / f, m.c0.z / f, m.c0.w / f,
			m.c1.x / f, m.c1.y / f, m.c1.z / f, m.c1.w / f,
			m.c2.x / f, m.c2.y / f, m.c2.z / f, m.c2.w / f,
			m.c3.x / f, m.c3.y / f, m.c3.z / f, m.c3.w / f
		);
	}

	@:op(a / b)
	static inline function divScalarInv(f: Float, m: Mat4): Mat4 {
		var m: Mat4Data = m;
		return new Mat4(
			f / m.c0.x, f / m.c0.y, f / m.c0.z, f / m.c0.w,
			f / m.c1.x, f / m.c1.y, f / m.c1.z, f / m.c1.w,
			f / m.c2.x, f / m.c2.y, f / m.c2.z, f / m.c2.w,
			f / m.c3.x, f / m.c3.y, f / m.c3.z, f / m.c3.w
		);
	}

	@:op(a == b)
	static inline function equal(m: Mat4, n: Mat4): Bool {
		var m: Mat4Data = m;
		var n: Mat4Data = n;
		return
			m.c0 == n.c0 &&
			m.c1 == n.c1 &&
			m.c2 == n.c2 &&
			m.c3 == n.c3;
	}

	@:op(a != b)
	static inline function notEqual(m: Mat4, n: Mat4): Bool
		return !equal(m, n);


}

private class Mat4Data {

	public var c0: Vec4;
	public var c1: Vec4;
	public var c2: Vec4;
	public var c3: Vec4;

	public inline function new(
		a00: Float, a01: Float, a02: Float, a03: Float,
		a10: Float, a11: Float, a12: Float, a13: Float,
		a20: Float, a21: Float, a22: Float, a23: Float,
		a30: Float, a31: Float, a32: Float, a33: Float
	) {
		c0 = new Vec4(a00, a01, a02, a03);
		c1 = new Vec4(a10, a11, a12, a13);
		c2 = new Vec4(a20, a21, a22, a23);
		c3 = new Vec4(a30, a31, a32, a33);
	}

}

// # Macros

#if macro

final floatType = Context.getType('Float');
final vec2Type = Context.getType('VectorMath.Vec2');
final vec3Type = Context.getType('VectorMath.Vec3');
final vec4Type = Context.getType('VectorMath.Vec4');
final mat2Type = Context.getType('VectorMath.Mat2');
final mat3Type = Context.getType('VectorMath.Mat3');
final mat4Type = Context.getType('VectorMath.Mat4');

function mapVecType(e: Expr): Int {
	return switch Context.typeof(e) {
		// aka unknown type
		case TMono(_): switch e {
			case macro null: 0; // empty argument
			default: -1; // unknown argument
		}
		case t:
			if (Context.unify(t, floatType)) 1;
			else if (Context.unify(t, vec2Type)) 2;
			else if (Context.unify(t, vec3Type)) 3;
			else if (Context.unify(t, vec4Type)) 4;
			else -1; // non-vector type
	}
}

function vectorConstructor(length: Int, _argExprs: Array<Expr>): Expr {
	var typePath: TypePath = {
		name: 'Vec$length',
		pack: [],
	};

	var argsNotNull = new Array<Expr>();
	for(arg in _argExprs) {
		switch arg {
			case macro null: break;
			default: argsNotNull.push(arg);
		}
	}

	return if (argsNotNull.length == 1 && Context.unify(Context.typeof(argsNotNull[0]), floatType)) {
		// special case for vec(float)
		var constructorArgs = [for (i in 0...length) macro x];
		macro {
			var x = ${argsNotNull[0]};
			new $typePath($a{constructorArgs});
		}
	} else {
		var constructorArgs = constructorArguments(length, 1, argsNotNull, false);
		macro new $typePath($a{constructorArgs});
	}
}

function matrixConstructor(typePath: TypePath, width: Int, height: Int, _argExprs: Array<Expr>): Expr {
	var argsNotNull = new Array<Expr>();
	for(arg in _argExprs) {
		switch arg {
			case macro null: break;
			default: argsNotNull.push(arg);
		}
	}

	return if (argsNotNull.length == 1 && Context.unify(Context.typeof(argsNotNull[0]), floatType)) {
		// special case for mat(float)
		var constructorArgs = [
			for (i in 0...width)
				for (j in 0...height)
					i == j ? macro x : macro 0.0
		];
		macro {
			var x = ${argsNotNull[0]};
			new $typePath($a{constructorArgs});
		}
	} else {
		var constructorArgs = constructorArguments(width, height, argsNotNull, true);
		macro new $typePath($a{constructorArgs});
	}
}

function constructorArguments(width: Int, height: Int, args: Array<Expr>, matrixConstruction: Bool) {
	var length = width * height;
	// fill constructor float arguments
	var constructorArgs = new Array<Expr>();
	for (i in 0...args.length) {
		if (constructorArgs.length >= length) {
			tooManyArgumentsFatalError();
		}
		var t = Context.typeof(args[i]);
		if (Context.unify(t, floatType)) {
			constructorArgs.push(macro ${args[i]});
		} else if (Context.unify(t, vec2Type)) {
			constructorArgs.push(macro ${args[i]}.x);
			constructorArgs.push(macro ${args[i]}.y);
		} else if (Context.unify(t, vec3Type)) {
			constructorArgs.push(macro ${args[i]}.x);
			constructorArgs.push(macro ${args[i]}.y);
			constructorArgs.push(macro ${args[i]}.z);
		} else if (Context.unify(t, vec4Type)) {
			constructorArgs.push(macro ${args[i]}.x);
			constructorArgs.push(macro ${args[i]}.y);
			constructorArgs.push(macro ${args[i]}.z);
			constructorArgs.push(macro ${args[i]}.w);
		} else if (Context.unify(t, mat2Type)) {
			if (matrixConstruction) {
				constructorArgs = matrixFromMatrixConstructorArguments(width, height, args, 2, 2);
			} else {
				for (c in 0...2) for (r in 0...2)
					constructorArgs.push(macro ${args[i]}[$v{c}][$v{r}]);
			}
		} else if (Context.unify(t, mat3Type)) {
			if (matrixConstruction) {
				constructorArgs = matrixFromMatrixConstructorArguments(width, height, args, 3, 3);
			} else {
				for (c in 0...3) for (r in 0...3)
					constructorArgs.push(macro ${args[i]}[$v{c}][$v{r}]);
			}
		} else if (Context.unify(t, mat4Type)) {
			if (matrixConstruction) {
				constructorArgs = matrixFromMatrixConstructorArguments(width, height, args, 4, 4);
			} else {
				for (c in 0...4) for (r in 0...4)
					constructorArgs.push(macro ${args[i]}[$v{c}][$v{r}]);
			}
		} else {
			// unknown type
			Context.fatalError('Expected vector or matrix type (argument ${i + 1} was ${haxe.macro.TypeTools.toString(t)})', Context.currentPos());
		}
	}

	// truncate to fit constructed type
	if (constructorArgs.length > length) constructorArgs.resize(length);

	return constructorArgs;
}

function matrixFromMatrixConstructorArguments(targetWidth: Int, targetHeight: Int, sourceArgs: Array<Expr>, sourceWidth: Int, sourceHeight: Int) {
	var length = targetWidth * targetHeight;
	return if (sourceArgs.length > 1) {
		Context.fatalError('Constructing matrix from matrix can only take one argument', Context.currentPos());
	} else {
		[for (p in 0...length) {
			var row = p % targetWidth;
			var column = Math.floor(p / targetWidth);
			if (row < sourceHeight && column < sourceWidth) {
				macro ${sourceArgs[0]}[$v{column}][$v{row}];
			// out of bounds values are set to identity
			} else if (row == column) {
				macro 1.0;
			} else {
				macro 0.0;
			}
		}];
	}
}

function tooManyArgumentsFatalError() {
	return Context.fatalError('Too many arguments', Context.currentPos());
}

function notEnoughArgumentsFatalError() {
	return Context.fatalError('Not enough arguments', Context.currentPos());
}

function argumentExpectedVectorTypeFatalError() {
	return Context.fatalError('Argument should be one of Float, Vec2, Vec3 or Vec4', Context.currentPos());
}

/**
	Change the expression's position to Context.currentPos(). This ensures errors are reported in the user code and not the macro code
**/
function useCurrentPos(e: Expr) {
	e.pos = Context.currentPos();
	return e;
}

class Swizzle {

	static public function generateFields(vectorLength: Int) {
		var fields = Context.getBuildFields();
		// for vector length N, we generate all possible combinations of 4 (or less)
		// for swizzles that do not repeat, we also add a setter

		generateSwizzles(fields, vectorLength, xyzw, true);

		// uncomment to add .rgba and .stpq swizzles
		// generateSwizzles(fields, vectorLength, ['r','g','b','a'], false);
		// generateSwizzles(fields, vectorLength, ['s','t','p','q'], false);

		return fields;
	}

	static function generateSwizzles(fields: Array<Field>, vectorLength: Int, keys: Array<String>, skipLength1: Bool) {
		// length 1 fields
		if (!skipLength1) for (i in 0...vectorLength) {
			generateProperty(fields, [i], keys);
		}
		// length 2 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				generateProperty(fields, [i,j], keys);
			}
		}
		// length 3 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				for (k in 0...vectorLength) {
					generateProperty(fields, [i,j,k], keys);
				}
			}
		}
		// length 4 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				for (k in 0...vectorLength) {
					for (l in 0...vectorLength) {
						generateProperty(fields, [i,j,k,l], keys);
					}
				}
			}
		}
	}

	static final xyzw = ['x', 'y', 'z', 'w'];
	// build some useful lookups
	static final thisReadExpr = xyzw.map(c -> macro this.$c);
	static final vReadExpr = xyzw.map(c -> macro v.$c);
	static final vectorTypeMap: Array<TypePath> = [
		{ pack: [], name: 'Float' },
		{ pack: [], name: 'Vec2' },
		{ pack: [], name: 'Vec3' },
		{ pack: [], name: 'Vec4' }
	];

	static function generateProperty(fields: Array<Field>, swizzle: Array<Int>, keys: Array<String>) {
		var ident = swizzle.map(i -> keys[i]).join('');
		var readonly = hasDuplicate(swizzle);
		
		var typePath = vectorTypeMap[swizzle.length - 1];

		var type: ComplexType = TPath(typePath);

		var declaration = if (readonly) {
			(macro class { public var $ident(get, never): $type; }).fields[0]; 
		} else {
			(macro class { public var $ident(get, set): $type; }).fields[0]; 
		}

		// add @:noCompletion if swizzle is not a single component
		if (swizzle.length > 1) {
			declaration.meta = [{
				name: ':noCompletion',
				pos: Context.currentPos(),
			}];
		}

		var getterName = 'get_$ident';
		var getter = (macro class {
			inline function $getterName(): $type
				return ${
					if (swizzle.length > 1) {
						macro new $typePath( $a{swizzle.map(i -> thisReadExpr[i])} );
					} else {
						thisReadExpr[swizzle[0]];
					}
				}
		}).fields[0];

		fields.push(declaration);
		fields.push(getter);

		if (!readonly) {
			var setterName = 'set_$ident';
			var setter = (macro class {
				inline function $setterName(v: $type): $type {
					$b{[for (i in 0...swizzle.length) 
						macro ${thisReadExpr[swizzle[i]]} = ${swizzle.length > 1 ? vReadExpr[i] : macro v}
					]}
					return ${swizzle.length > 1 ? macro v.clone() : macro v};
				}
			}).fields[0];
			fields.push(setter);
		}
	}

	static function hasDuplicate(array: Array<Int>) {
		for (i in 0...array.length) {
			for (j in (i + 1)...array.length) {
				if (array[i] == array[j]) return true;
			}
		}
		return false;
	}

}

#end