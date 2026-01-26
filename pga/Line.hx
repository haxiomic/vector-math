package pga;

import VectorMath;

/**
 * A line in 3D projective space.
 *
 * Internally represented using Plücker coordinates:
 *   - Direction: (e23, e31, e12) - the line's direction vector
 *   - Moment: (e01, e02, e03) - encodes position relative to origin
 */
@:nullSafety
abstract Line(Blade4) from Blade4 to Blade4 {
	/** Create a line through a point in a given direction */
	public inline function new(px:Float, py:Float, pz:Float, dx:Float, dy:Float, dz:Float) {
		this = Blade4.line(px, py, pz, dx, dy, dz);
	}

	/** Create a line through origin along direction */
	public static inline function throughOrigin(dx:Float, dy:Float, dz:Float):Line {
		return cast Blade4.lineThruOrigin(dx, dy, dz);
	}

	/** Create a line through origin from Vec3 direction */
	public static inline function throughOriginDir(dir:Vec3):Line {
		return throughOrigin(dir.x, dir.y, dir.z);
	}

	/** Create a line from two points */
	public static inline function fromPoints(p1:Point, p2:Point):Line {
		return p1.join(p2);
	}

	/** Create a line through a point in a direction */
	public static inline function fromPointDir(point:Vec3, dir:Vec3):Line {
		return new Line(point.x, point.y, point.z, dir.x, dir.y, dir.z);
	}

	/** X-axis line (through origin along +X) */
	public static inline function xAxis():Line {
		return throughOrigin(1, 0, 0);
	}

	/** Y-axis line (through origin along +Y) */
	public static inline function yAxis():Line {
		return throughOrigin(0, 1, 0);
	}

	/** Z-axis line (through origin along +Z) */
	public static inline function zAxis():Line {
		return throughOrigin(0, 0, 1);
	}

	/** Get direction vector of the line (creates new Vec3) */
	public inline function getDirection():Vec3 {
		return vec3(this.e23, this.e31, this.e12).normalize();
	}

	/** Meet with a plane to get intersection point */
	public inline function meet(plane:Plane):Point {
		return cast((cast this : Blade4) ^ (cast plane : Blade4));
	}

	/** Meet with another line (returns point, may be ideal if parallel) */
	public inline function meetLine(other:Line):Point {
		return cast((cast this : Blade4) ^ (cast other : Blade4));
	}

	/** Join with a point to form a plane */
	public inline function join(point:Point):Plane {
		return cast((cast this : Blade4) & (cast point : Blade4));
	}
}

/** Shorthand constructor for Line through point in direction */
inline function line(px:Float, py:Float, pz:Float, dx:Float, dy:Float, dz:Float):Line {
	return new Line(px, py, pz, dx, dy, dz);
}
