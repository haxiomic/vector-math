package pga;

import VectorMath;

/**
 * A point in 3D projective space.
 *
 * Finite points have homogeneous coordinate w=1.
 * Ideal points (directions/points at infinity) have w=0.
 */
@:nullSafety
abstract Point(Blade4) from Blade4 to Blade4 {
	/** Create a finite point at (x, y, z) */
	public inline function new(x:Float, y:Float, z:Float) {
		this = Blade4.point(x, y, z);
	}

	/** Origin point (0, 0, 0) */
	public static inline function origin():Point {
		return new Point(0, 0, 0);
	}

	/** Create point from Vec3 */
	@:from
	public static inline function fromVec3(v:Vec3):Point {
		return new Point(v.x, v.y, v.z);
	}

	/** Create an ideal point (direction/point at infinity) */
	public static inline function direction(x:Float, y:Float, z:Float):Point {
		return cast Blade4.direction(x, y, z);
	}

	/** Create an ideal point from Vec3 direction */
	public static inline function directionFromVec3(v:Vec3):Point {
		return direction(v.x, v.y, v.z);
	}

	/** Extract as Vec3 (normalizes by homogeneous coordinate) */
	@:to
	public inline function toVec3():Vec3 {
		return this.toPoint();
	}

	/** X coordinate */
	public var x(get, never):Float;

	inline function get_x():Float {
		var w = this.e123;
		return if (Math.abs(w) < Blade4.EPSILON) this.e032 else this.e032 / w;
	}

	/** Y coordinate */
	public var y(get, never):Float;

	inline function get_y():Float {
		var w = this.e123;
		return if (Math.abs(w) < Blade4.EPSILON) this.e013 else this.e013 / w;
	}

	/** Z coordinate */
	public var z(get, never):Float;

	inline function get_z():Float {
		var w = this.e123;
		return if (Math.abs(w) < Blade4.EPSILON) this.e021 else this.e021 / w;
	}

	/** Homogeneous coordinate (1 for finite points, 0 for ideal) */
	public var w(get, never):Float;

	inline function get_w():Float
		return this.e123;

	/** Is this a finite point (not at infinity)? */
	public inline function isFinite():Bool {
		return Math.abs(this.e123) > Blade4.EPSILON;
	}

	/** Is this an ideal point (at infinity)? */
	public inline function isIdeal():Bool {
		return Math.abs(this.e123) < Blade4.EPSILON;
	}

	/** Join two points to form a line */
	public inline function join(other:Point):Line {
		return cast(this & (cast other : Blade4));
	}

	/** Join with a line to form a plane */
	public inline function joinLine(line:Line):Plane {
		return cast(this & (cast line : Blade4));
	}

	/** Distance to another point */
	public inline function distanceTo(other:Point):Float {
		return (toVec3() - other.toVec3()).length();
	}

	/** Squared distance to another point */
	public inline function distanceSquaredTo(other:Point):Float {
		var d = toVec3() - other.toVec3();
		return dot(d, d);
	}

	@:op(a == b)
	public static inline function eq(a:Point, b:Point):Bool {
		return Math.abs(a.x - b.x) < Blade4.EPSILON && Math.abs(a.y - b.y) < Blade4.EPSILON && Math.abs(a.z - b.z) < Blade4.EPSILON;
	}

	@:op(a != b)
	public static inline function neq(a:Point, b:Point):Bool {
		return !(a == b);
	}
}

/** Shorthand constructor for Point */
inline function point(x:Float, y:Float, z:Float):Point {
	return new Point(x, y, z);
}
