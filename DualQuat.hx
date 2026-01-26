#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

// Threshold for numerical stability checks.
// Chosen to work with both f32 (~7 significant digits) and f64.
// Reference: Magnum uses machine epsilon, pytransform3d uses 1e-6.
private inline var EPSILON = 1e-6;

@:nullSafety
abstract DualQuat(DualQuatData) to DualQuatData from DualQuatData {

	#if !macro

	public var real(get, set): Quat;
	inline function get_real() return this.real;
	inline function set_real(v: Quat) return this.real = v;

	public var dual(get, set): Quat;
	inline function get_dual() return this.dual;
	inline function set_dual(v: Quat) return this.dual = v;

	public inline function new(real: Quat, dual: Quat) {
		this = new DualQuatData(real, dual);
	}

	public inline function set(real: Quat, dual: Quat) {
		this.real = real;
		this.dual = dual;
	}

	public inline function clone() {
		return new DualQuat(real.clone(), dual.clone());
	}

	public inline function copyFrom(dq: DualQuat) {
		real.copyFrom(dq.real);
		dual.copyFrom(dq.dual);
		return this;
	}

	// Construction

	public static inline function identity(): DualQuat {
		return new DualQuat(Quat.identity(), new Quat(0, 0, 0, 0));
	}

	public static inline function fromRotationTranslation(rotation: Quat, translation: Vec3): DualQuat {
		// dual = 0.5 * translation_quat * rotation
		// where translation_quat = (tx, ty, tz, 0)
		var r = rotation.normalize();
		var t = new Quat(translation.x, translation.y, translation.z, 0);
		var d = t * r * 0.5;
		return new DualQuat(r, d);
	}

	@:nullSafety(Off)
	public static function fromMat4(m: Mat4): DualQuat {
		// Extract rotation
		var rotation = Quat.fromMat4(m);

		// Extract translation - Mat4 index 3 is always valid
		var c3: Vec4 = m[3];
		var translation = new Vec3(c3.x, c3.y, c3.z);

		return fromRotationTranslation(rotation, translation);
	}

	public static function fromScrewAxis(axis: Vec3, point: Vec3, angle: Float, pitch: Float): DualQuat {
		// Screw motion: rotation around axis + translation along axis
		var halfAngle = angle * 0.5;
		var sinHalf = Math.sin(halfAngle);
		var cosHalf = Math.cos(halfAngle);

		var axisNorm = axis.normalize();

		// Real part (rotation)
		var realPart = new Quat(
			axisNorm.x * sinHalf,
			axisNorm.y * sinHalf,
			axisNorm.z * sinHalf,
			cosHalf
		);

		// Dual part
		var d = pitch * 0.5;
		var moment = point.cross(axisNorm);

		var dualPart = new Quat(
			sinHalf * moment.x + d * cosHalf * axisNorm.x,
			sinHalf * moment.y + d * cosHalf * axisNorm.y,
			sinHalf * moment.z + d * cosHalf * axisNorm.z,
			-d * sinHalf
		);

		return new DualQuat(realPart, dualPart);
	}

	// Core Functions

	public inline function conjugate(): DualQuat {
		// Conjugate both parts
		return new DualQuat(real.conjugate(), dual.conjugate());
	}

	public inline function dualConjugate(): DualQuat {
		// Negate dual part only
		return new DualQuat(real, -dual);
	}

	public inline function fullConjugate(): DualQuat {
		// Both conjugates
		return new DualQuat(real.conjugate(), -dual.conjugate());
	}

	public inline function normalize(): DualQuat {
		// Normalize to unit dual quaternion by dividing both parts by real part's magnitude.
		// If magnitude is near zero, the dual quaternion is degenerate - we still normalize
		// to avoid division by zero, but the result may not be meaningful.
		var mag = real.length();
		var invMag = mag < EPSILON ? 1.0 : 1.0 / mag;
		return new DualQuat(real * invMag, dual * invMag);
	}

	public inline function length(): Float {
		return real.length();
	}

	// Transform Operations

	public inline function transformPoint(p: Vec3): Vec3 {
		// Apply full rigid transform to point: p' = rotate(p) + translate
		return real.rotateVec3(p) + getTranslation();
	}

	public inline function transformVector(v: Vec3): Vec3 {
		// Apply rotation only (for normals/directions)
		return real.rotateVec3(v);
	}

	public inline function getRotation(): Quat {
		return real.clone();
	}

	public inline function getTranslation(): Vec3 {
		// translation = 2 * dual * conjugate(real)
		var t = dual * real.conjugate() * 2.0;
		return new Vec3(t.x, t.y, t.z);
	}

	// Interpolation

	public inline function lerp(b: DualQuat, t: Float): DualQuat {
		return new DualQuat(
			real.lerp(b.real, t),
			dual.lerp(b.dual, t)
		);
	}

	public inline function nlerp(b: DualQuat, t: Float): DualQuat {
		return lerp(b, t).normalize();
	}

	public function sclerp(b: DualQuat, t: Float): DualQuat {
		// Screw Linear Interpolation
		// Provides constant velocity rigid motion

		// Ensure shortest path
		var bReal = b.real;
		var bDual = b.dual;
		if (real.dot(b.real) < 0) {
			bReal = -bReal;
			bDual = -bDual;
		}

		// Get relative transformation: diff = b * conjugate(this)
		var diffReal = bReal * real.conjugate();
		var diffDual = bDual * real.conjugate() + bReal * (-dual.conjugate());

		// Extract screw parameters
		var invRealLen = 1.0 / diffReal.length();
		var realNorm = diffReal * invRealLen;
		var dualNorm = diffDual * invRealLen;

		// Get angle and pitch
		var angle = 2.0 * Math.acos(realNorm.w < -1.0 ? -1.0 : (realNorm.w > 1.0 ? 1.0 : realNorm.w));
		var pitch = -2.0 * dualNorm.w;

		// Handle near-zero angle case (quaternions nearly identical)
		if (Math.abs(angle) < EPSILON) {
			return nlerp(b, t);
		}

		var sinHalfAngle = Math.sin(angle * 0.5);
		var axis = new Vec3(realNorm.x / sinHalfAngle, realNorm.y / sinHalfAngle, realNorm.z / sinHalfAngle);

		// Scale the transformation by t
		var scaledAngle = angle * t;
		var scaledPitch = pitch * t;

		// Reconstruct scaled dual quaternion
		var halfScaledAngle = scaledAngle * 0.5;
		var sinHalf = Math.sin(halfScaledAngle);
		var cosHalf = Math.cos(halfScaledAngle);

		var scaledReal = new Quat(
			axis.x * sinHalf,
			axis.y * sinHalf,
			axis.z * sinHalf,
			cosHalf
		);

		var d = scaledPitch * 0.5;
		var scaledDual = new Quat(
			d * cosHalf * axis.x,
			d * cosHalf * axis.y,
			d * cosHalf * axis.z,
			-d * sinHalf
		);

		// Combine with original: result = scaled * this
		var resultReal = scaledReal * real;
		var resultDual = scaledReal * dual + scaledDual * real;

		return new DualQuat(resultReal, resultDual);
	}

	// Conversion

	public inline function toMat4(): Mat4 {
		var r = real.normalize();
		var t = getTranslation();

		var x2 = r.x + r.x, y2 = r.y + r.y, z2 = r.z + r.z;
		var xx = r.x * x2, xy = r.x * y2, xz = r.x * z2;
		var yy = r.y * y2, yz = r.y * z2, zz = r.z * z2;
		var wx = r.w * x2, wy = r.w * y2, wz = r.w * z2;

		return new Mat4(
			1 - (yy + zz), xy + wz, xz - wy, 0,
			xy - wz, 1 - (xx + zz), yz + wx, 0,
			xz + wy, yz - wx, 1 - (xx + yy), 0,
			t.x, t.y, t.z, 1
		);
	}

	public inline function toRotationTranslation(): {rotation: Quat, translation: Vec3} {
		return {
			rotation: getRotation(),
			translation: getTranslation()
		};
	}

	public inline function toString() {
		return 'dualquat(${real}, ${dual})';
	}

	// Operators

	@:op(-a)
	static inline function neg(a: DualQuat): DualQuat
		return new DualQuat(-a.real, -a.dual);

	@:op(a + b)
	static inline function add(a: DualQuat, b: DualQuat): DualQuat
		return new DualQuat(a.real + b.real, a.dual + b.dual);

	@:op(a - b)
	static inline function sub(a: DualQuat, b: DualQuat): DualQuat
		return new DualQuat(a.real - b.real, a.dual - b.dual);

	@:op(a * b)
	static inline function mul(a: DualQuat, b: DualQuat): DualQuat {
		// (r1 + εd1) * (r2 + εd2) = r1*r2 + ε(r1*d2 + d1*r2)
		return new DualQuat(
			a.real * b.real,
			a.real * b.dual + a.dual * b.real
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a: DualQuat, b: Float): DualQuat
		return new DualQuat(a.real * b, a.dual * b);

	@:op(a == b)
	static inline function equal(a: DualQuat, b: DualQuat): Bool
		return a.real == b.real && a.dual == b.dual;

	@:op(a != b)
	static inline function notEqual(a: DualQuat, b: DualQuat): Bool
		return !equal(a, b);

	#end // !macro
}

@:noCompletion
class DualQuatData {
	#if !macro
	public var real: Quat;
	public var dual: Quat;

	public inline function new(real: Quat, dual: Quat) {
		this.real = real;
		this.dual = dual;
	}
	#end
}
