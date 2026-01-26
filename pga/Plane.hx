package pga;

import VectorMath;

/**
 * A plane in 3D projective space.
 *
 * Represented as ax + by + cz + d = 0, stored as (d, a, b, c) in PGA.
 */
@:nullSafety
abstract Plane(Blade4) from Blade4 to Blade4 {
	/** Create a plane from equation ax + by + cz + d = 0 */
	public inline function new(a:Float, b:Float, c:Float, d:Float) {
		this = Blade4.plane(a, b, c, d);
	}

	/** Create a plane from normal vector and distance from origin */
	public static inline function fromNormalDist(normal:Vec3, dist:Float):Plane {
		return cast Blade4.planeFromNormalDist(normal, dist);
	}

	/** Create a plane through a point with given normal */
	public static inline function fromPointNormal(point:Vec3, normal:Vec3):Plane {
		return cast Blade4.planeFromPointNormal(point, normal);
	}

	/** Create a plane from three points */
	public static inline function fromPoints(p1:Point, p2:Point, p3:Point):Plane {
		return p1.join(p2).join(p3);
	}

	/** XY plane (z = 0) */
	public static inline function xy():Plane {
		return new Plane(0, 0, 1, 0);
	}

	/** XZ plane (y = 0) */
	public static inline function xz():Plane {
		return new Plane(0, 1, 0, 0);
	}

	/** YZ plane (x = 0) */
	public static inline function yz():Plane {
		return new Plane(1, 0, 0, 0);
	}

	/** Get normal vector of the plane (creates new Vec3) */
	public inline function getNormal():Vec3 {
		return vec3(this.e1, this.e2, this.e3).normalize();
	}

	/** Get distance from origin (signed) */
	public inline function getDistance():Float {
		var n = vec3(this.e1, this.e2, this.e3).length();
		return if (n < Blade4.EPSILON) 0 else this.e0 / n;
	}

	/** Get plane equation coefficients (a, b, c, d) */
	public inline function toEquation():Vec4 {
		return this.toPlane();
	}

	/** Meet with another plane to get line of intersection */
	public inline function meet(other:Plane):Line {
		return cast((cast this : Blade4) ^ (cast other : Blade4));
	}

	/** Meet with a line to get intersection point */
	public inline function meetLine(line:Line):Point {
		return cast((cast this : Blade4) ^ (cast line : Blade4));
	}

	/** Join with a point to get... a plane through that point parallel to this?
	 *  Actually in PGA, plane & point gives a line (the perpendicular from point to plane)
	 */
	public inline function join(point:Point):Line {
		return cast((cast this : Blade4) & (cast point : Blade4));
	}

	/** Signed distance from a point to this plane */
	public inline function signedDistanceTo(p:Point):Float {
		var n = getNormal();
		var pv = p.toVec3();
		return VectorMath.dot(n, pv) + getDistance();
	}
}

/** Shorthand constructor for Plane */
inline function plane(a:Float, b:Float, c:Float, d:Float):Plane {
	return new Plane(a, b, c, d);
}
