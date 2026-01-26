#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

@:nullSafety
abstract Complex(ComplexData) to ComplexData from ComplexData {

	#if !macro

	public var re(get, set): Float;
	inline function get_re() return this.re;
	inline function set_re(v: Float) return this.re = v;

	public var im(get, set): Float;
	inline function get_im() return this.im;
	inline function set_im(v: Float) return this.im = v;

	public inline function new(re: Float, im: Float) {
		this = new ComplexData(re, im);
	}

	public inline function set(re: Float, im: Float) {
		this.re = re;
		this.im = im;
	}

	public inline function clone() {
		return new Complex(re, im);
	}

	public inline function copyFrom(c: Complex) {
		re = c.re;
		im = c.im;
		return this;
	}

	// Core operations

	public inline function conjugate(): Complex {
		return new Complex(re, -im);
	}

	public inline function modulus(): Float {
		return Math.sqrt(re * re + im * im);
	}

	public inline function modulusSquared(): Float {
		return re * re + im * im;
	}

	public inline function argument(): Float {
		return Math.atan2(im, re);
	}

	public inline function normalize(): Complex {
		var m = modulus();
		var denom = m == 0.0 ? 1.0 : m;
		return new Complex(re / denom, im / denom);
	}

	public inline function inverse(): Complex {
		var m2 = modulusSquared();
		return new Complex(re / m2, -im / m2);
	}

	// Polar/Exponential

	public inline function toPolar(): Vec2 {
		return new Vec2(modulus(), argument());
	}

	public static inline function fromPolar(r: Float, theta: Float): Complex {
		return new Complex(r * Math.cos(theta), r * Math.sin(theta));
	}

	public inline function exp(): Complex {
		// e^(re + im*i) = e^re * (cos(im) + i*sin(im))
		var e = Math.exp(re);
		return new Complex(e * Math.cos(im), e * Math.sin(im));
	}

	public inline function log(): Complex {
		// log(z) = log|z| + i*arg(z)
		return new Complex(Math.log(modulus()), argument());
	}

	public inline function sqrt(): Complex {
		// Principal square root
		var m = modulus();
		var t = argument() / 2.0;
		var sqrtM = Math.sqrt(m);
		return new Complex(sqrtM * Math.cos(t), sqrtM * Math.sin(t));
	}

	public extern overload inline function pow(n: Float): Complex {
		// z^n = |z|^n * e^(i*n*arg(z))
		var m = modulus();
		var t = argument();
		var powM = Math.pow(m, n);
		return new Complex(powM * Math.cos(n * t), powM * Math.sin(n * t));
	}

	public extern overload inline function pow(c: Complex): Complex {
		// z^c = e^(c * log(z))
		return (c * log()).exp();
	}

	// Trigonometric (complex-valued)

	public inline function sin(): Complex {
		// sin(z) = (e^(iz) - e^(-iz)) / 2i
		// sin(re + im*i) = sin(re)*cosh(im) + i*cos(re)*sinh(im)
		return new Complex(
			Math.sin(re) * cosh(im),
			Math.cos(re) * sinh(im)
		);
	}

	public inline function cos(): Complex {
		// cos(z) = (e^(iz) + e^(-iz)) / 2
		// cos(re + im*i) = cos(re)*cosh(im) - i*sin(re)*sinh(im)
		return new Complex(
			Math.cos(re) * cosh(im),
			-Math.sin(re) * sinh(im)
		);
	}

	public inline function tan(): Complex {
		// tan(z) = sin(z) / cos(z)
		var s = sin();
		var c = cos();
		return s / c;
	}

	// Helpers
	private static inline function sinh(x: Float): Float {
		return (Math.exp(x) - Math.exp(-x)) / 2.0;
	}

	private static inline function cosh(x: Float): Float {
		return (Math.exp(x) + Math.exp(-x)) / 2.0;
	}

	public inline function toString() {
		return 'complex(${re}, ${im})';
	}

	// Operators

	@:op(-a)
	static inline function neg(a: Complex): Complex
		return new Complex(-a.re, -a.im);

	@:op(a + b)
	static inline function add(a: Complex, b: Complex): Complex
		return new Complex(a.re + b.re, a.im + b.im);

	@:op(a + b) @:commutative
	static inline function addScalar(a: Complex, b: Float): Complex
		return new Complex(a.re + b, a.im);

	@:op(a - b)
	static inline function sub(a: Complex, b: Complex): Complex
		return new Complex(a.re - b.re, a.im - b.im);

	@:op(a - b)
	static inline function subScalar(a: Complex, b: Float): Complex
		return new Complex(a.re - b, a.im);

	@:op(a - b)
	static inline function subScalarInv(a: Float, b: Complex): Complex
		return new Complex(a - b.re, -b.im);

	@:op(a * b)
	static inline function mul(a: Complex, b: Complex): Complex {
		// (a.re + a.im*i) * (b.re + b.im*i) = (a.re*b.re - a.im*b.im) + (a.re*b.im + a.im*b.re)*i
		return new Complex(
			a.re * b.re - a.im * b.im,
			a.re * b.im + a.im * b.re
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Complex, b: Float): Complex
		return new Complex(a.re * b, a.im * b);

	@:op(a / b)
	static inline function div(a: Complex, b: Complex): Complex {
		// (a + bi) / (c + di) = ((a + bi)(c - di)) / (c^2 + d^2)
		// = (ac + bd) / (c^2 + d^2) + ((bc - ad) / (c^2 + d^2))i
		var denom = b.re * b.re + b.im * b.im;
		return new Complex(
			(a.re * b.re + a.im * b.im) / denom,
			(a.im * b.re - a.re * b.im) / denom
		);
	}

	@:op(a / b)
	static inline function divScalar(a: Complex, b: Float): Complex
		return new Complex(a.re / b, a.im / b);

	@:op(a / b)
	static inline function divScalarInv(a: Float, b: Complex): Complex {
		// a / (b.re + b.im*i) = a * conj(b) / |b|^2
		var denom = b.re * b.re + b.im * b.im;
		return new Complex(a * b.re / denom, -a * b.im / denom);
	}

	@:op(a == b)
	static inline function equal(a: Complex, b: Complex): Bool
		return a.re == b.re && a.im == b.im;

	@:op(a != b)
	static inline function notEqual(a: Complex, b: Complex): Bool
		return !equal(a, b);

	#end // !macro
}

@:noCompletion
class ComplexData {
	#if !macro
	public var re: Float;
	public var im: Float;

	public inline function new(re: Float, im: Float) {
		this.re = re;
		this.im = im;
	}
	#end
}
