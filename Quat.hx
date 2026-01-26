#if (vector_math_f32 && (cpp || hl || cs || java))
// override Float (usually f64) type with f32
@:eager private typedef Float = Single;
#end

// Threshold for numerical stability checks.
// Chosen to work with both f32 (~7 significant digits) and f64.
private inline var EPSILON = 1e-6;

@:nullSafety
abstract Quat(QuatData) to QuatData from QuatData {

	#if !macro

	public var x(get, set): Float;
	inline function get_x() return this.x;
	inline function set_x(v: Float) return this.x = v;

	public var y(get, set): Float;
	inline function get_y() return this.y;
	inline function set_y(v: Float) return this.y = v;

	public var z(get, set): Float;
	inline function get_z() return this.z;
	inline function set_z(v: Float) return this.z = v;

	public var w(get, set): Float;
	inline function get_w() return this.w;
	inline function set_w(v: Float) return this.w = v;

	public inline function new(x: Float, y: Float, z: Float, w: Float) {
		this = new QuatData(x, y, z, w);
	}

	public inline function set(x: Float, y: Float, z: Float, w: Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function clone() {
		return new Quat(x, y, z, w);
	}

	public inline function copyFrom(q: Quat) {
		x = q.x;
		y = q.y;
		z = q.z;
		w = q.w;
		return this;
	}

	// Construction

	public static inline function identity(): Quat {
		return new Quat(0, 0, 0, 1);
	}

	public static inline function fromAxisAngle(axis: Vec3, angle: Float): Quat {
		var halfAngle = angle / 2.0;
		var s = Math.sin(halfAngle);
		var normalizedAxis = axis.normalize();
		return new Quat(
			normalizedAxis.x * s,
			normalizedAxis.y * s,
			normalizedAxis.z * s,
			Math.cos(halfAngle)
		);
	}

	public static inline function fromEuler(pitch: Float, yaw: Float, roll: Float): Quat {
		// XYZ order (pitch = X, yaw = Y, roll = Z)
		var cy = Math.cos(yaw * 0.5);
		var sy = Math.sin(yaw * 0.5);
		var cp = Math.cos(pitch * 0.5);
		var sp = Math.sin(pitch * 0.5);
		var cr = Math.cos(roll * 0.5);
		var sr = Math.sin(roll * 0.5);

		return new Quat(
			sr * cp * cy - cr * sp * sy,
			cr * sp * cy + sr * cp * sy,
			cr * cp * sy - sr * sp * cy,
			cr * cp * cy + sr * sp * sy
		);
	}

	public static inline function fromRotationX(angle: Float): Quat {
		var halfAngle = angle / 2.0;
		return new Quat(Math.sin(halfAngle), 0, 0, Math.cos(halfAngle));
	}

	public static inline function fromRotationY(angle: Float): Quat {
		var halfAngle = angle / 2.0;
		return new Quat(0, Math.sin(halfAngle), 0, Math.cos(halfAngle));
	}

	public static inline function fromRotationZ(angle: Float): Quat {
		var halfAngle = angle / 2.0;
		return new Quat(0, 0, Math.sin(halfAngle), Math.cos(halfAngle));
	}

	@:nullSafety(Off)
	public static function fromMat3(m: Mat3): Quat {
		// Mat3 indices 0,1,2 are always valid - disable null safety for array access
		var c0: Vec3 = m[0];
		var c1: Vec3 = m[1];
		var c2: Vec3 = m[2];
		return fromRotationMatrix(
			c0.x, c0.y, c0.z,
			c1.x, c1.y, c1.z,
			c2.x, c2.y, c2.z
		);
	}

	@:nullSafety(Off)
	public static function fromMat4(m: Mat4): Quat {
		// Extract 3x3 rotation part
		// Mat4 indices 0,1,2 are always valid - disable null safety for array access
		var c0: Vec4 = m[0];
		var c1: Vec4 = m[1];
		var c2: Vec4 = m[2];
		return fromRotationMatrix(
			c0.x, c0.y, c0.z,
			c1.x, c1.y, c1.z,
			c2.x, c2.y, c2.z
		);
	}

	// Shared implementation for fromMat3/fromMat4 - Shepperd's method for numerical stability
	private static function fromRotationMatrix(
		m00: Float, m01: Float, m02: Float,
		m10: Float, m11: Float, m12: Float,
		m20: Float, m21: Float, m22: Float
	): Quat {
		var trace = m00 + m11 + m22;

		if (trace > 0) {
			var s = 0.5 / Math.sqrt(trace + 1.0);
			return new Quat(
				(m12 - m21) * s,
				(m20 - m02) * s,
				(m01 - m10) * s,
				0.25 / s
			);
		} else if (m00 > m11 && m00 > m22) {
			var s = 2.0 * Math.sqrt(1.0 + m00 - m11 - m22);
			return new Quat(
				0.25 * s,
				(m10 + m01) / s,
				(m20 + m02) / s,
				(m12 - m21) / s
			);
		} else if (m11 > m22) {
			var s = 2.0 * Math.sqrt(1.0 + m11 - m00 - m22);
			return new Quat(
				(m10 + m01) / s,
				0.25 * s,
				(m21 + m12) / s,
				(m20 - m02) / s
			);
		} else {
			var s = 2.0 * Math.sqrt(1.0 + m22 - m00 - m11);
			return new Quat(
				(m20 + m02) / s,
				(m21 + m12) / s,
				0.25 * s,
				(m01 - m10) / s
			);
		}
	}

	public static function fromRotationArc(from: Vec3, to: Vec3): Quat {
		var fromNorm = from.normalize();
		var toNorm = to.normalize();
		var d = fromNorm.dot(toNorm);

		if (d >= 1.0) {
			// Vectors are the same
			return identity();
		} else if (d <= -1.0) {
			// Vectors are opposite - find perpendicular axis
			var axis = new Vec3(1, 0, 0).cross(fromNorm);
			if (axis.length() < EPSILON) {
				axis = new Vec3(0, 1, 0).cross(fromNorm);
			}
			axis = axis.normalize();
			return new Quat(axis.x, axis.y, axis.z, 0);
		}

		var c = fromNorm.cross(toNorm);
		var s = Math.sqrt((1.0 + d) * 2.0);
		var invS = 1.0 / s;

		return new Quat(
			c.x * invS,
			c.y * invS,
			c.z * invS,
			s * 0.5
		);
	}

	// Core Functions

	public inline function conjugate(): Quat {
		return new Quat(-x, -y, -z, w);
	}

	public inline function length(): Float {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}

	public inline function lengthSquared(): Float {
		return x * x + y * y + z * z + w * w;
	}

	public inline function normalize(): Quat {
		var len = length();
		var denom = len == 0.0 ? 1.0 : len;
		return new Quat(x / denom, y / denom, z / denom, w / denom);
	}

	public inline function inverse(): Quat {
		var lenSq = lengthSquared();
		return new Quat(-x / lenSq, -y / lenSq, -z / lenSq, w / lenSq);
	}

	public inline function dot(b: Quat): Float {
		return x * b.x + y * b.y + z * b.z + w * b.w;
	}

	// Rotation Operations

	public inline function rotateVec3(v: Vec3): Vec3 {
		// Optimized rotation: v' = v + 2*w*(xyz cross v) + 2*(xyz cross (xyz cross v))
		var qv = new Vec3(x, y, z);
		var uv = qv.cross(v);
		var uuv = qv.cross(uv);
		return v + (uv * w + uuv) * 2.0;
	}

	public inline function angleBetween(b: Quat): Float {
		var d = dot(b);
		// Clamp to avoid acos domain errors
		d = d < -1.0 ? -1.0 : (d > 1.0 ? 1.0 : d);
		return 2.0 * Math.acos(Math.abs(d));
	}

	// Interpolation

	public inline function lerp(b: Quat, t: Float): Quat {
		return new Quat(
			x + (b.x - x) * t,
			y + (b.y - y) * t,
			z + (b.z - z) * t,
			w + (b.w - w) * t
		);
	}

	public inline function nlerp(b: Quat, t: Float): Quat {
		return lerp(b, t).normalize();
	}

	public function slerp(b: Quat, t: Float): Quat {
		var d = dot(b);

		// If dot < 0, negate one quaternion to take shorter path
		var bx = b.x, by = b.y, bz = b.z, bw = b.w;
		if (d < 0) {
			d = -d;
			bx = -bx;
			by = -by;
			bz = -bz;
			bw = -bw;
		}

		// If quaternions are very close, use linear interpolation
		if (d > 0.9995) {
			var result = new Quat(
				x + (bx - x) * t,
				y + (by - y) * t,
				z + (bz - z) * t,
				w + (bw - w) * t
			);
			return result.normalize();
		}

		var theta = Math.acos(d);
		var sinTheta = Math.sin(theta);
		var w1 = Math.sin((1.0 - t) * theta) / sinTheta;
		var w2 = Math.sin(t * theta) / sinTheta;

		return new Quat(
			x * w1 + bx * w2,
			y * w1 + by * w2,
			z * w1 + bz * w2,
			w * w1 + bw * w2
		);
	}

	// Conversion

	public inline function toAxisAngle(): Vec4 {
		var q = normalize();
		var angle = 2.0 * Math.acos(q.w);
		var s = Math.sqrt(1.0 - q.w * q.w);
		if (s < EPSILON) {
			// Near-identity quaternion, axis is arbitrary
			return new Vec4(1, 0, 0, angle);
		}
		return new Vec4(q.x / s, q.y / s, q.z / s, angle);
	}

	public inline function toEuler(): Vec3 {
		// Returns (pitch, yaw, roll) in radians
		var sinrCosp = 2.0 * (w * x + y * z);
		var cosrCosp = 1.0 - 2.0 * (x * x + y * y);
		var roll = Math.atan2(sinrCosp, cosrCosp);

		var sinp = 2.0 * (w * y - z * x);
		var pitch: Float;
		if (Math.abs(sinp) >= 1) {
			pitch = sinp >= 0 ? Math.PI / 2 : -Math.PI / 2;
		} else {
			pitch = Math.asin(sinp);
		}

		var sinyCosp = 2.0 * (w * z + x * y);
		var cosyCosp = 1.0 - 2.0 * (y * y + z * z);
		var yaw = Math.atan2(sinyCosp, cosyCosp);

		return new Vec3(pitch, yaw, roll);
	}

	public inline function toMat3(): Mat3 {
		var x2 = x + x, y2 = y + y, z2 = z + z;
		var xx = x * x2, xy = x * y2, xz = x * z2;
		var yy = y * y2, yz = y * z2, zz = z * z2;
		var wx = w * x2, wy = w * y2, wz = w * z2;

		return new Mat3(
			1 - (yy + zz), xy + wz, xz - wy,
			xy - wz, 1 - (xx + zz), yz + wx,
			xz + wy, yz - wx, 1 - (xx + yy)
		);
	}

	public inline function toMat4(): Mat4 {
		var x2 = x + x, y2 = y + y, z2 = z + z;
		var xx = x * x2, xy = x * y2, xz = x * z2;
		var yy = y * y2, yz = y * z2, zz = z * z2;
		var wx = w * x2, wy = w * y2, wz = w * z2;

		return new Mat4(
			1 - (yy + zz), xy + wz, xz - wy, 0,
			xy - wz, 1 - (xx + zz), yz + wx, 0,
			xz + wy, yz - wx, 1 - (xx + yy), 0,
			0, 0, 0, 1
		);
	}

	public inline function toString() {
		return 'quat(${x}, ${y}, ${z}, ${w})';
	}

	// Operators

	@:op(-a)
	static inline function neg(a: Quat): Quat
		return new Quat(-a.x, -a.y, -a.z, -a.w);

	@:op(a + b)
	static inline function add(a: Quat, b: Quat): Quat
		return new Quat(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);

	@:op(a - b)
	static inline function sub(a: Quat, b: Quat): Quat
		return new Quat(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);

	@:op(a * b)
	static inline function mul(a: Quat, b: Quat): Quat {
		// Hamilton product
		return new Quat(
			a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
			a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
			a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
			a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
		);
	}

	@:op(a * b) @:commutative
	static inline function mulScalar(a: Quat, b: Float): Quat
		return new Quat(a.x * b, a.y * b, a.z * b, a.w * b);

	@:op(a / b)
	static inline function divScalar(a: Quat, b: Float): Quat
		return new Quat(a.x / b, a.y / b, a.z / b, a.w / b);

	@:op(a == b)
	static inline function equal(a: Quat, b: Quat): Bool
		return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;

	@:op(a != b)
	static inline function notEqual(a: Quat, b: Quat): Bool
		return !equal(a, b);

	#end // !macro
}

@:noCompletion
class QuatData {
	#if !macro
	public var x: Float;
	public var y: Float;
	public var z: Float;
	public var w: Float;

	public inline function new(x: Float, y: Float, z: Float, w: Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	#end
}
