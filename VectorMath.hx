/**
	# Vector Mathematics Library

	Enables GLSL vector and matrix operations to compile in haxe

	Reference Spec GLSL ES 1.0: https://www.khronos.org/files/opengles_shading_language.pdf

	**Usage**:
	Add `import VectorMath;` to be able to use GLSL functions and constructors

	Pass `-D vector_math_f32` to use 32-bit floats on platforms that support it (by default haxe's Float type corresponds to a 64-bit float)

	@license MIT
	@author haxiomic (George Corney)
	@version 1.5.0
**/

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

// # Built-in Functions

// trigonometric

overload extern inline function radians(degrees: Vec4) degrees.radians();
overload extern inline function radians(degrees: Vec3) degrees.radians();
overload extern inline function radians(degrees: Vec2) degrees.radians();
overload extern inline function radians(degrees: Float) return degrees * Math.PI / 180;

overload extern inline function degrees(radians: Vec4): Vec4 return radians.degrees();
overload extern inline function degrees(radians: Vec3): Vec3 return radians.degrees();
overload extern inline function degrees(radians: Vec2): Vec2 return radians.degrees();
overload extern inline function degrees(radians: Float) return radians * 180 / Math.PI;

overload extern inline function sin(v: Vec4): Vec4 return v.sin();
overload extern inline function sin(v: Vec3): Vec3 return v.sin();
overload extern inline function sin(v: Vec2): Vec2 return v.sin();
overload extern inline function sin(v: Float) return Math.sin(v);

overload extern inline function cos(v: Vec4): Vec4 return v.cos();
overload extern inline function cos(v: Vec3): Vec3 return v.cos();
overload extern inline function cos(v: Vec2): Vec2 return v.cos();
overload extern inline function cos(v: Float) return Math.cos(v);

overload extern inline function tan(v: Vec4): Vec4 return v.tan();
overload extern inline function tan(v: Vec3): Vec3 return v.tan();
overload extern inline function tan(v: Vec2): Vec2 return v.tan();
overload extern inline function tan(v: Float) return Math.tan(v);

overload extern inline function asin(v: Vec4): Vec4 return v.asin();
overload extern inline function asin(v: Vec3): Vec3 return v.asin();
overload extern inline function asin(v: Vec2): Vec2 return v.asin();
overload extern inline function asin(v: Float) return Math.asin(v);

overload extern inline function acos(v: Vec4): Vec4 return v.acos();
overload extern inline function acos(v: Vec3): Vec3 return v.acos();
overload extern inline function acos(v: Vec2): Vec2 return v.acos();
overload extern inline function acos(v: Float) return Math.acos(v);

overload extern inline function atan(v: Vec4): Vec4 return v.atan();
overload extern inline function atan(v: Vec3): Vec3 return v.atan();
overload extern inline function atan(v: Vec2): Vec2 return v.atan();
overload extern inline function atan(v: Float) return Math.atan(v);

overload extern inline function atan2(v: Vec4, b: Vec4): Vec4 return v.atan2(b);
overload extern inline function atan2(v: Vec3, b: Vec3): Vec3 return v.atan2(b);
overload extern inline function atan2(v: Vec2, b: Vec2): Vec2 return v.atan2(b);
overload extern inline function atan2(v: Float, b: Float) return Math.atan2(v, b);

// exponential

overload extern inline function pow(v: Vec4, e: Vec4): Vec4 return v.pow(e);
overload extern inline function pow(v: Vec3, e: Vec3): Vec3 return v.pow(e);
overload extern inline function pow(v: Vec2, e: Vec2): Vec2 return v.pow(e);
overload extern inline function pow(v: Float, e: Float) return Math.pow(v, e);

overload extern inline function exp(v: Vec4): Vec4 return v.exp();
overload extern inline function exp(v: Vec3): Vec3 return v.exp();
overload extern inline function exp(v: Vec2): Vec2 return v.exp();
overload extern inline function exp(v: Float) return Math.exp(v);

overload extern inline function log(v: Vec4): Vec4 return v.log();
overload extern inline function log(v: Vec3): Vec3 return v.log();
overload extern inline function log(v: Vec2): Vec2 return v.log();
overload extern inline function log(v: Float) return Math.log(v);

overload extern inline function exp2(v: Vec4): Vec4 return v.exp2();
overload extern inline function exp2(v: Vec3): Vec3 return v.exp2();
overload extern inline function exp2(v: Vec2): Vec2 return v.exp2();
overload extern inline function exp2(v: Float) return Math.pow(2, v);

overload extern inline function log2(v: Vec4): Vec4 return v.log2();
overload extern inline function log2(v: Vec3): Vec3 return v.log2();
overload extern inline function log2(v: Vec2): Vec2 return v.log2();
overload extern inline function log2(v: Float) return Math.log(v) * 1.4426950408889634;

overload extern inline function sqrt(v: Vec4): Vec4 return v.sqrt();
overload extern inline function sqrt(v: Vec3): Vec3 return v.sqrt();
overload extern inline function sqrt(v: Vec2): Vec2 return v.sqrt();
overload extern inline function sqrt(v: Float) return Math.sqrt(v);

overload extern inline function inverseSqrt(v: Vec4): Vec4 return v.inverseSqrt();
overload extern inline function inverseSqrt(v: Vec3): Vec3 return v.inverseSqrt();
overload extern inline function inverseSqrt(v: Vec2): Vec2 return v.inverseSqrt();
overload extern inline function inverseSqrt(v: Float) return 1.0 / Math.sqrt(v);

// common

overload extern inline function abs(v: Vec4): Vec4 return v.abs();
overload extern inline function abs(v: Vec3): Vec3 return v.abs();
overload extern inline function abs(v: Vec2): Vec2 return v.abs();
overload extern inline function abs(v: Float) return Math.abs(v);

overload extern inline function sign(v: Vec4): Vec4 return v.sign();
overload extern inline function sign(v: Vec3): Vec3 return v.sign();
overload extern inline function sign(v: Vec2): Vec2 return v.sign();
overload extern inline function sign(v: Float): Float return v > 0. ? 1. : (v < 0. ? -1. : 0.);

overload extern inline function floor(v: Vec4): Vec4 return v.floor();
overload extern inline function floor(v: Vec3): Vec3 return v.floor();
overload extern inline function floor(v: Vec2): Vec2 return v.floor();
overload extern inline function floor(v: Float): Int return Math.floor(v);

overload extern inline function ceil(v: Vec4): Vec4 return v.ceil();
overload extern inline function ceil(v: Vec3): Vec3 return v.ceil();
overload extern inline function ceil(v: Vec2): Vec2 return v.ceil();
overload extern inline function ceil(v: Float): Int return Math.ceil(v);

overload extern inline function fract(v: Vec4): Vec4 return v.fract();
overload extern inline function fract(v: Vec3): Vec3 return v.fract();
overload extern inline function fract(v: Vec2): Vec2 return v.fract();
overload extern inline function fract(v: Float): Float return v - Math.floor(v);

overload extern inline function mod(v: Vec4, d: Float): Vec4 return v.mod(d);
overload extern inline function mod(v: Vec4, d: Vec4): Vec4 return v.mod(d);
overload extern inline function mod(v: Vec3, d: Float): Vec3 return v.mod(d);
overload extern inline function mod(v: Vec3, d: Vec3): Vec3 return v.mod(d);
overload extern inline function mod(v: Vec2, d: Float): Vec2 return v.mod(d);
overload extern inline function mod(v: Vec2, d: Vec2): Vec2 return v.mod(d);
overload extern inline function mod(v: Float, d: Float): Float return v - d * Math.floor(v / d);

overload extern inline function min(v: Vec4, b: Float): Vec4 return v.min(b);
overload extern inline function min(v: Vec4, b: Vec4): Vec4 return v.min(b);
overload extern inline function min(v: Vec3, b: Float): Vec3 return v.min(b);
overload extern inline function min(v: Vec3, b: Vec3): Vec3 return v.min(b);
overload extern inline function min(v: Vec2, b: Float): Vec2 return v.min(b);
overload extern inline function min(v: Vec2, b: Vec2): Vec2 return v.min(b);
overload extern inline function min(v: Float, b: Float): Float return Math.min(v, b);

overload extern inline function max(v: Vec4, b: Float): Vec4 return v.max(b);
overload extern inline function max(v: Vec4, b: Vec4): Vec4 return v.max(b);
overload extern inline function max(v: Vec3, b: Float): Vec3 return v.max(b);
overload extern inline function max(v: Vec3, b: Vec3): Vec3 return v.max(b);
overload extern inline function max(v: Vec2, b: Float): Vec2 return v.max(b);
overload extern inline function max(v: Vec2, b: Vec2): Vec2 return v.max(b);
overload extern inline function max(v: Float, b: Float): Float return Math.max(v, b);

overload extern inline function clamp(v: Vec4, min: Float, max: Float): Vec4 return v.clamp(min, max);
overload extern inline function clamp(v: Vec4, min: Vec4, max: Vec4): Vec4 return v.clamp(min, max);
overload extern inline function clamp(v: Vec3, min: Float, max: Float): Vec3 return v.clamp(min, max);
overload extern inline function clamp(v: Vec3, min: Vec3, max: Vec3): Vec3 return v.clamp(min, max);
overload extern inline function clamp(v: Vec2, min: Float, max: Float): Vec2 return v.clamp(min, max);
overload extern inline function clamp(v: Vec2, min: Vec2, max: Vec2): Vec2 return v.clamp(min, max);
overload extern inline function clamp(v: Float, min: Float, max: Float): Float return v < min ? min : (v > max ? max : v);

overload extern inline function mix(a: Vec4, b: Vec4, t: Float): Vec4 return a.mix(b, t);
overload extern inline function mix(a: Vec4, b: Vec4, t: Vec4): Vec4 return a.mix(b, t);
overload extern inline function mix(a: Vec3, b: Vec3, t: Float): Vec3 return a.mix(b, t);
overload extern inline function mix(a: Vec3, b: Vec3, t: Vec3): Vec3 return a.mix(b, t);
overload extern inline function mix(a: Vec2, b: Vec2, t: Float): Vec2 return a.mix(b, t);
overload extern inline function mix(a: Vec2, b: Vec2, t: Vec2): Vec2 return a.mix(b, t);
overload extern inline function mix(a: Float, b: Float, t: Float): Float return a * (1.0 - t) + b * t;

overload extern inline function step(edge: Float, v: Vec4): Vec4 return v.step(edge);
overload extern inline function step(edge: Vec4, v: Vec4): Vec4 return v.step(edge);
overload extern inline function step(edge: Float, v: Vec3): Vec3 return v.step(edge);
overload extern inline function step(edge: Vec3, v: Vec3): Vec3 return v.step(edge);
overload extern inline function step(edge: Float, v: Vec2): Vec2 return v.step(edge);
overload extern inline function step(edge: Vec2, v: Vec2): Vec2 return v.step(edge);
overload extern inline function step(edge: Float, v: Float): Float return v < edge ? 0.0 : 1.0;

overload extern inline function smoothstep(edge0: Float, edge1: Float, v: Vec4): Vec4 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Vec4, edge1: Vec4, v: Vec4): Vec4 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Float, edge1: Float, v: Vec3): Vec3 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Vec3, edge1: Vec3, v: Vec3): Vec3 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Float, edge1: Float, v: Vec2): Vec2 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Vec2, edge1: Vec2, v: Vec2): Vec2 return v.smoothstep(edge0, edge1);
overload extern inline function smoothstep(edge0: Float, edge1: Float, v: Float): Float {
	var t = (v - edge0) / (edge1 - edge0);
	t = t < 0. ? 0. : (t > 1. ? 1. : t); // clamp to 0, 1
	return t * t * (3.0 - 2.0 * t);
}

// geometric

overload extern inline function length(v: Vec4): Float return v.length();
overload extern inline function length(v: Vec3): Float return v.length();
overload extern inline function length(v: Vec2): Float return v.length();
overload extern inline function length(v: Float): Float return Math.abs(v);

overload extern inline function distance(v: Vec4, b: Vec4): Float return v.distance(b);
overload extern inline function distance(v: Vec3, b: Vec3): Float return v.distance(b);
overload extern inline function distance(v: Vec2, b: Vec2): Float return v.distance(b);
overload extern inline function distance(v: Float, b: Float): Float return Math.abs(v - b);

overload extern inline function dot(v: Vec4, b: Vec4): Float return v.dot(b);
overload extern inline function dot(v: Vec3, b: Vec3): Float return v.dot(b);
overload extern inline function dot(v: Vec2, b: Vec2): Float return v.dot(b);
overload extern inline function dot(v: Float, b: Float): Float return (v * b);

overload extern inline function normalize(v: Vec4): Vec4 return v.normalize();
overload extern inline function normalize(v: Vec3): Vec3 return v.normalize();
overload extern inline function normalize(v: Vec2): Vec2 return v.normalize();
overload extern inline function normalize(v: Float) return v <= 0.0 ? 0.0 : 1.0;

overload extern inline function faceforward(v: Vec4, I: Vec4, Nref: Vec4): Vec4 return v.faceforward(I, Nref);
overload extern inline function faceforward(v: Vec3, I: Vec3, Nref: Vec3): Vec3 return v.faceforward(I, Nref);
overload extern inline function faceforward(v: Vec2, I: Vec2, Nref: Vec2): Vec2 return v.faceforward(I, Nref);
overload extern inline function faceforward(v: Float, I: Float, Nref: Float): Float return (I * Nref < 0 ? v : -v);

overload extern inline function reflect(I: Vec4, N: Vec4): Vec4 return I.reflect(N);
overload extern inline function reflect(I: Vec3, N: Vec3): Vec3 return I.reflect(N);
overload extern inline function reflect(I: Vec2, N: Vec2): Vec2 return I.reflect(N);
overload extern inline function reflect(I: Float, N: Float): Float return I - 2 * (N * I) * N;

overload extern inline function refract(I: Vec4, N: Vec4, eta: Float): Vec4 return I.refract(N, eta);
overload extern inline function refract(I: Vec3, N: Vec3, eta: Float): Vec3 return I.refract(N, eta);
overload extern inline function refract(I: Vec2, N: Vec2, eta: Float): Vec2 return I.refract(N, eta);
overload extern inline function refract(I: Float, N: Float, eta: Float): Float {
	var nDotI = I * N;
	var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
	return if (k < 0.0) {
		0.0;
	} else {
		eta * I - (eta * nDotI + Math.sqrt(k)) * N;
	}
}

overload extern inline function matrixCompMult(m: Mat4, n: Mat4): Mat4 return m.matrixCompMult(n);
overload extern inline function matrixCompMult(m: Mat3, n: Mat3): Mat3 return m.matrixCompMult(n);
overload extern inline function matrixCompMult(m: Mat2, n: Mat2): Mat2 return m.matrixCompMult(n);

// extended methods beyond GLSL ES 100
overload extern inline function transpose(m: Mat4): Mat4 return m.transpose();
overload extern inline function transpose(m: Mat3): Mat3 return m.transpose();
overload extern inline function transpose(m: Mat2): Mat2 return m.transpose();

overload extern inline function determinant(m: Mat4): Float return m.determinant();
overload extern inline function determinant(m: Mat3): Float return m.determinant();
overload extern inline function determinant(m: Mat2): Float return m.determinant();

overload extern inline function inverse(m: Mat4): Mat4 return m.inverse();
overload extern inline function inverse(m: Mat3): Mat3 return m.inverse();
overload extern inline function inverse(m: Mat2): Mat2 return m.inverse();

overload extern inline function adjoint(m: Mat4): Mat4 return m.adjoint();
overload extern inline function adjoint(m: Mat3): Mat3 return m.adjoint();
overload extern inline function adjoint(m: Mat2): Mat2 return m.adjoint();

// special-case functions
inline function cross(a: Vec3, b: Vec3): Vec3 {
	return a.cross(b);
}

// # Vector Initializers
// macros are used to enable function overloads which makes vector composition possible, for example: `vec4(vec2(1,2), vec2(3,4))`

overload extern inline function vec2(m: Mat4): Vec2 return new Vec2(m[0][0], m[0][1]);
overload extern inline function vec2(m: Mat3): Vec2 return new Vec2(m[0][0], m[0][1]);
overload extern inline function vec2(m: Mat2): Vec2 return new Vec2(m[0][0], m[0][1]);
overload extern inline function vec2(xy: Vec2): Vec2 return new Vec2(xy.x, xy.y);
overload extern inline function vec2(x: Float): Vec2 return new Vec2(x, x);
overload extern inline function vec2(x: Float, y: Float): Vec2 return new Vec2(x, y);

overload extern inline function vec3(m: Mat4): Vec3 return new Vec3(m[0][0], m[0][1], m[0][2]);
overload extern inline function vec3(m: Mat3): Vec3 return new Vec3(m[0][0], m[0][1], m[0][2]);
overload extern inline function vec3(m: Mat2): Vec3 return new Vec3(m[0][0], m[0][1], m[1][0]);
overload extern inline function vec3(xyz: Vec3): Vec3 return new Vec3(xyz.x, xyz.y, xyz.z);
overload extern inline function vec3(x: Float, yz: Vec2): Vec3 return new Vec3(x, yz.x, yz.y);
overload extern inline function vec3(xy: Vec2, z: Float): Vec3 return new Vec3(xy.x, xy.y, z);
overload extern inline function vec3(x: Float): Vec3 return new Vec3(x, x, x);
overload extern inline function vec3(x: Float, y: Float, z: Float): Vec3 return new Vec3(x, y, z);

overload extern inline function vec4(m: Mat4): Vec4 return new Vec4(m[0][0], m[0][1], m[0][2], m[0][3]);
overload extern inline function vec4(m: Mat3): Vec4 return new Vec4(m[0][0], m[0][1], m[0][2], m[1][0]);
overload extern inline function vec4(m: Mat2): Vec4 return new Vec4(m[0][0], m[0][1], m[1][0], m[1][1]);
overload extern inline function vec4(xyzw: Vec4): Vec4 return new Vec4(xyzw.x, xyzw.y, xyzw.z, xyzw.w);
overload extern inline function vec4(x: Float, yzw: Vec3): Vec4 return new Vec4(x, yzw.x, yzw.y, yzw.z);
overload extern inline function vec4(xyz: Vec3, w: Float): Vec4 return new Vec4(xyz.x, xyz.y, xyz.z, w);
overload extern inline function vec4(xy: Vec2, zw: Vec2): Vec4 return new Vec4(xy.x, xy.y, zw.x, zw.y);
overload extern inline function vec4(x: Float, y: Float, zw: Vec2): Vec4 return new Vec4(x, y, zw.x, zw.y);
overload extern inline function vec4(x: Float, yz: Vec2, w: Float): Vec4 return new Vec4(x, yz.x, yz.y, w);
overload extern inline function vec4(xy: Vec2, z: Float, w: Float): Vec4 return new Vec4(xy.x, xy.y, z, w);
overload extern inline function vec4(x: Float): Vec4 return new Vec4(x, x, x, x);
overload extern inline function vec4(x: Float, y: Float, z: Float, w: Float): Vec4 return new Vec4(x, y, z, w);

@:overload(function(a00: Float, a01: Float, a10: Float, a11: Float): Mat2 {})
@:overload(function(column0: Vec2, column1: Vec2): Mat2 {})
@:overload(function(xyzw: Vec4): Mat2 {})
macro function mat2(a, ?b, ?c, ?d): ExprOf<Mat2> {
	return useCurrentPos(matrixConstructor(2, 2, [a, b, c, d]));
}

@:overload(function(
	a00: Float, a01: Float, a02: Float,
	a10: Float, a11: Float, a12: Float,
	a20: Float, a21: Float, a22: Float
): Mat3 {})
@:overload(function(column0: Vec3, column1: Vec3, column2: Vec3): Mat3 {})
macro function mat3(a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i): ExprOf<Mat3> {
	return useCurrentPos(matrixConstructor(3, 3, [a, b, c, d, e, f, g, h, i]));
}

@:overload(function(
	a00: Float, a01: Float, a02: Float, a03: Float,
	a10: Float, a11: Float, a12: Float, a13: Float,
	a20: Float, a21: Float, a22: Float, a23: Float,
	a30: Float, a31: Float, a32: Float, a33: Float
): Mat4 {})
@:overload(function(column0: Vec4, column1: Vec4, column2: Vec4, column3: Vec4): Mat4 {})
macro function mat4(a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i, ?j, ?k, ?l, ?m, ?n, ?o, ?p): ExprOf<Mat4> {
	return useCurrentPos(matrixConstructor(4, 4, [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p]));
}

// # Types

@:nullSafety
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

	@:op(a.b) macro function swizzleRead(self, name: String) {
		return swizzleReadExpr(self, name);
	}

	@:op(a.b) macro function swizzleWrite(self, name: String, value: Expr) {
		return swizzleWriteExpr(self, name, value);
	}

	public inline function copyFrom(v: Vec2) {
		x = v.x;
		y = v.y;
		return this;
	}

	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Vec2>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array;
		}
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
		var lenSq = (this: Vec2).dot(this);
		return lenSq == 0.0 ? new Vec2(0.0, 0.0) : (this: Vec2) / Math.sqrt(lenSq);
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

@:nullSafety
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

	@:op(a.b) macro function swizzleRead(self, name: String) {
		return swizzleReadExpr(self, name);
	}

	@:op(a.b) macro function swizzleWrite(self, name: String, value: Expr) {
		return swizzleWriteExpr(self, name, value);
	}

	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Vec3>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
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
		var lenSq = (this: Vec3).dot(this);
		return lenSq == 0.0 ? new Vec3(0.0, 0.0, 0.0) : (this: Vec3) / Math.sqrt(lenSq);
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

@:nullSafety
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
	
	@:op(a.b) macro function swizzleRead(self, name: String) {
		return swizzleReadExpr(self, name);
	}

	@:op(a.b) macro function swizzleWrite(self, name: String, value: Expr) {
		return swizzleWriteExpr(self, name, value);
	}

	public inline function copyFrom(v: Vec4) {
		x = v.x;
		y = v.y;
		z = v.z;
		w = v.w;
		return this;
	}

	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Vec4>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
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
		var lenSq = (this: Vec4).dot(this);
		return lenSq == 0.0 ? new Vec4(0.0, 0.0, 0.0, 0.0) : (this: Vec4) / Math.sqrt(lenSq);
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

	/**
		Copies matrix elements in column-major order into a type that supports array-write access
	**/
	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Mat2>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
		return macro  {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			self[0].copyIntoArray(array, i);
			self[1].copyIntoArray(array, i + 2);
			array;
		}
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

	/**
		Copies matrix elements in column-major order into a type that supports array-write access
	**/
	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Mat3>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
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

	/**
		Copies matrix elements in column-major order into a type that supports array-write access
	**/
	@:overload(function<T>(arrayLike: T, index: Int): T {})
	public macro function copyIntoArray(self: ExprOf<Mat4>, array: ExprOf<ArrayAccess<Float>>, index: ExprOf<Int>) {
		return macro  {
			var self = $self;
			var array = $array;
			var i: Int = $index;
			self[0].copyIntoArray(array, i);
			self[1].copyIntoArray(array, i + 4);
			self[2].copyIntoArray(array, i + 8);
			self[3].copyIntoArray(array, i + 12);
			array;
		}
	}

	public inline function clone(): Mat4 {
		return new Mat4(
			this.c0.x, this.c0.y, this.c0.z, this.c0.w,
			this.c1.x, this.c1.y, this.c1.z, this.c1.w,
			this.c2.x, this.c2.y, this.c2.z, this.c2.w,
			this.c3.x, this.c3.y, this.c3.z, this.c3.w
		);
	}
	
	public inline function matrixCompMult(n: Mat4): Mat4 {
		var m = this;
		var n: Mat4Data = n;
		return new Mat4(
			m.c0.x * n.c0.x, m.c0.y * n.c0.y, m.c0.z * n.c0.z, m.c0.w * n.c0.w,
			m.c1.x * n.c1.x, m.c1.y * n.c1.y, m.c1.z * n.c1.z, m.c1.w * n.c1.w,
			m.c2.x * n.c2.x, m.c2.y * n.c2.y, m.c2.z * n.c2.z, m.c2.w * n.c2.w,
			m.c3.x * n.c3.x, m.c3.y * n.c3.y, m.c3.z * n.c3.z, m.c3.w * n.c3.w
		);
	}

	// extended methods

	public inline function transpose(): Mat4 {
		var m = this;
		return new Mat4(
			m.c0.x, m.c1.x, m.c2.x, m.c3.x,
			m.c0.y, m.c1.y, m.c2.y, m.c3.y,
			m.c0.z, m.c1.z, m.c2.z, m.c3.z,
			m.c0.w, m.c1.w, m.c2.w, m.c3.w
		);
	}

	public inline function determinant(): Float {
		var m = this;
		var b0 = m.c0.x * m.c1.y - m.c0.y * m.c1.x;
		var b1 = m.c0.x * m.c1.z - m.c0.z * m.c1.x;
		var b2 = m.c0.y * m.c1.z - m.c0.z * m.c1.y;
		var b3 = m.c2.x * m.c3.y - m.c2.y * m.c3.x;
		var b4 = m.c2.x * m.c3.z - m.c2.z * m.c3.x;
		var b5 = m.c2.y * m.c3.z - m.c2.z * m.c3.y;
		var b6 = m.c0.x * b5 - m.c0.y * b4 + m.c0.z * b3;
		var b7 = m.c1.x * b5 - m.c1.y * b4 + m.c1.z * b3;
		var b8 = m.c2.x * b2 - m.c2.y * b1 + m.c2.z * b0;
		var b9 = m.c3.x * b2 - m.c3.y * b1 + m.c3.z * b0;
		return m.c1.w * b6 - m.c0.w * b7 + m.c3.w * b8 - m.c2.w * b9;
	}

	public inline function inverse(): Mat4 {
		var m = this;
		var b00 = m.c0.x * m.c1.y - m.c0.y * m.c1.x;
		var b01 = m.c0.x * m.c1.z - m.c0.z * m.c1.x;
		var b02 = m.c0.x * m.c1.w - m.c0.w * m.c1.x;
		var b03 = m.c0.y * m.c1.z - m.c0.z * m.c1.y;
		var b04 = m.c0.y * m.c1.w - m.c0.w * m.c1.y;
		var b05 = m.c0.z * m.c1.w - m.c0.w * m.c1.z;
		var b06 = m.c2.x * m.c3.y - m.c2.y * m.c3.x;
		var b07 = m.c2.x * m.c3.z - m.c2.z * m.c3.x;
		var b08 = m.c2.x * m.c3.w - m.c2.w * m.c3.x;
		var b09 = m.c2.y * m.c3.z - m.c2.z * m.c3.y;
		var b10 = m.c2.y * m.c3.w - m.c2.w * m.c3.y;
		var b11 = m.c2.z * m.c3.w - m.c2.w * m.c3.z;

		// determinant
		var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

		var f = 1.0 / det;

		return new Mat4(
			(m.c1.y * b11 - m.c1.z * b10 + m.c1.w * b09) * f,
			(m.c0.z * b10 - m.c0.y * b11 - m.c0.w * b09) * f,
			(m.c3.y * b05 - m.c3.z * b04 + m.c3.w * b03) * f,
			(m.c2.z * b04 - m.c2.y * b05 - m.c2.w * b03) * f,
			(m.c1.z * b08 - m.c1.x * b11 - m.c1.w * b07) * f,
			(m.c0.x * b11 - m.c0.z * b08 + m.c0.w * b07) * f,
			(m.c3.z * b02 - m.c3.x * b05 - m.c3.w * b01) * f,
			(m.c2.x * b05 - m.c2.z * b02 + m.c2.w * b01) * f,
			(m.c1.x * b10 - m.c1.y * b08 + m.c1.w * b06) * f,
			(m.c0.y * b08 - m.c0.x * b10 - m.c0.w * b06) * f,
			(m.c3.x * b04 - m.c3.y * b02 + m.c3.w * b00) * f,
			(m.c2.y * b02 - m.c2.x * b04 - m.c2.w * b00) * f,
			(m.c1.y * b07 - m.c1.x * b09 - m.c1.z * b06) * f,
			(m.c0.x * b09 - m.c0.y * b07 + m.c0.z * b06) * f,
			(m.c3.y * b01 - m.c3.x * b03 - m.c3.z * b00) * f,
			(m.c2.x * b03 - m.c2.y * b01 + m.c2.z * b00) * f
		);
	}

	public inline function adjoint(): Mat4 {
		var m = this;
		var b00 = m.c0.x * m.c1.y - m.c0.y * m.c1.x;
		var b01 = m.c0.x * m.c1.z - m.c0.z * m.c1.x;
		var b02 = m.c0.x * m.c1.w - m.c0.w * m.c1.x;
		var b03 = m.c0.y * m.c1.z - m.c0.z * m.c1.y;
		var b04 = m.c0.y * m.c1.w - m.c0.w * m.c1.y;
		var b05 = m.c0.z * m.c1.w - m.c0.w * m.c1.z;
		var b06 = m.c2.x * m.c3.y - m.c2.y * m.c3.x;
		var b07 = m.c2.x * m.c3.z - m.c2.z * m.c3.x;
		var b08 = m.c2.x * m.c3.w - m.c2.w * m.c3.x;
		var b09 = m.c2.y * m.c3.z - m.c2.z * m.c3.y;
		var b10 = m.c2.y * m.c3.w - m.c2.w * m.c3.y;
		var b11 = m.c2.z * m.c3.w - m.c2.w * m.c3.z;
		return new Mat4(
			m.c1.y * b11 - m.c1.z * b10 + m.c1.w * b09,
			m.c0.z * b10 - m.c0.y * b11 - m.c0.w * b09,
			m.c3.y * b05 - m.c3.z * b04 + m.c3.w * b03,
			m.c2.z * b04 - m.c2.y * b05 - m.c2.w * b03,
			m.c1.z * b08 - m.c1.x * b11 - m.c1.w * b07,
			m.c0.x * b11 - m.c0.z * b08 + m.c0.w * b07,
			m.c3.z * b02 - m.c3.x * b05 - m.c3.w * b01,
			m.c2.x * b05 - m.c2.z * b02 + m.c2.w * b01,
			m.c1.x * b10 - m.c1.y * b08 + m.c1.w * b06,
			m.c0.y * b08 - m.c0.x * b10 - m.c0.w * b06,
			m.c3.x * b04 - m.c3.y * b02 + m.c3.w * b00,
			m.c2.y * b02 - m.c2.x * b04 - m.c2.w * b00,
			m.c1.y * b07 - m.c1.x * b09 - m.c1.z * b06,
			m.c0.x * b09 - m.c0.y * b07 + m.c0.z * b06,
			m.c3.y * b01 - m.c3.x * b03 - m.c3.z * b00,
			m.c2.x * b03 - m.c2.y * b01 + m.c2.z * b00
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

function matrixConstructor(width: Int, height: Int, _argExprs: Array<Expr>): Expr {
	var typePath: TypePath = {
		name: 'VectorMath',
		sub: 'Mat${width == height ? '${width}' : '${width}x${height}'}',
		pack: [],
	}

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

function deepReplacePos(e: Expr, pos: Position) {
	haxe.macro.ExprTools.iter(e, e2 -> e2.pos = pos);
	return e;
}

function swizzleReadExpr(self, name: String) {
	return deepReplacePos(switch name.length {
		case 2:
			var f0 = name.charAt(0); var f1 = name.charAt(1);
			macro {
				var self = $self;
				vec2(self.$f0, self.$f1);
			}
		case 3:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2);
			macro {
				var self = $self;
				vec3(self.$f0, self.$f1, self.$f2);
			}
		case 4:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2); var f3 = name.charAt(3);
			macro {
				var self = $self;
				vec4(self.$f0, self.$f1, self.$f2, self.$f3);
			}
		default:
			Context.error('Unsupported swizzle read ".$name"', Context.currentPos());
	}, Context.currentPos());
}

function swizzleWriteExpr(self, name: String, value: Expr) {
	return deepReplacePos(switch name.length {
		case 2:
			var f0 = name.charAt(0); var f1 = name.charAt(1);
			if (f0 == f1) {
				Context.error('Swizzle ".$name" disallowed because of duplicate field write', self.pos);
			}
			macro {
				var self = $self;
				var value: Vec2 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
			}
		case 3:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2);
			if (
				f0 == f1 || f0 == f2 ||
				f1 == f2
			) {
				Context.error('Swizzle ".$name" disallowed because of duplicate field write', self.pos);
			}
			macro {
				var self = $self;
				var value: Vec3 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
				self.$f2 = value.z;
			}
		case 4:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2); var f3 = name.charAt(3);
			if (
				f0 == f1 || f0 == f2 || f0 == f3 ||
				f1 == f2 || f1 == f3 || 
				f2 == f3
			) {
				Context.error('Swizzle ".$name" disallowed because of duplicate field write', self.pos);
			}
			macro {
				var self = $self;
				var value: Vec4 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
				self.$f2 = value.z;
				self.$f3 = value.w;
			}
		default:
			Context.error('Unsupported swizzle write ".$name"', self.pos);
	}, value.pos);
}

#end
