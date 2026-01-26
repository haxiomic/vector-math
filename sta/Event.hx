package sta;

import VectorMath;

/**
 * A point in spacetime (event).
 *
 * Coordinates: (t, x, y, z) where t is time, (x,y,z) is position.
 * In natural units where c=1.
 */
@:nullSafety
abstract Event(Blade4) from Blade4 to Blade4 {
	/** Create an event at spacetime coordinates (t, x, y, z) */
	public inline function new(t:Float, x:Float, y:Float, z:Float) {
		this = Blade4.event(t, x, y, z);
	}

	/** Origin of spacetime (0, 0, 0, 0) */
	public static inline function origin():Event {
		return new Event(0, 0, 0, 0);
	}

	/** Create from time and spatial Vec3 */
	public static inline function fromTimeSpace(t:Float, pos:Vec3):Event {
		return new Event(t, pos.x, pos.y, pos.z);
	}

	/** Time coordinate */
	public var t(get, never):Float;

	inline function get_t():Float
		return this.e0;

	/** X coordinate */
	public var x(get, never):Float;

	inline function get_x():Float
		return this.e1;

	/** Y coordinate */
	public var y(get, never):Float;

	inline function get_y():Float
		return this.e2;

	/** Z coordinate */
	public var z(get, never):Float;

	inline function get_z():Float
		return this.e3;

	/** Get spatial position as Vec3 (creates new Vec3) */
	public inline function getPosition():Vec3 {
		return vec3((cast this : Blade4).e1, (cast this : Blade4).e2, (cast this : Blade4).e3);
	}

	/** As Vec4 (t, x, y, z) */
	public inline function toVec4():Vec4 {
		return vec4(this.e0, this.e1, this.e2, this.e3);
	}

	/** Spacetime interval squared: Δs² = Δt² - Δx² - Δy² - Δz² */
	public inline function intervalSquaredTo(other:Event):Float {
		var o:Blade4 = cast other;
		var dt = this.e0 - o.e0;
		var dx = this.e1 - o.e1;
		var dy = this.e2 - o.e2;
		var dz = this.e3 - o.e3;
		return dt * dt - dx * dx - dy * dy - dz * dz;
	}

	/** Is the interval to another event timelike? (causally connected) */
	public inline function isTimelikeSeparatedFrom(other:Event):Bool {
		return intervalSquaredTo(other) > Blade4.EPSILON;
	}

	/** Is the interval to another event spacelike? (causally disconnected) */
	public inline function isSpacelikeSeparatedFrom(other:Event):Bool {
		return intervalSquaredTo(other) < -Blade4.EPSILON;
	}

	/** Is the interval to another event lightlike? (on light cone) */
	public inline function isLightlikeSeparatedFrom(other:Event):Bool {
		return Math.abs(intervalSquaredTo(other)) < Blade4.EPSILON;
	}

	/** Proper time between two timelike-separated events */
	public inline function properTimeTo(other:Event):Float {
		var s2 = intervalSquaredTo(other);
		return if (s2 > 0) Math.sqrt(s2) else 0;
	}

	/** Proper distance between two spacelike-separated events */
	public inline function properDistanceTo(other:Event):Float {
		var s2 = intervalSquaredTo(other);
		return if (s2 < 0) Math.sqrt(-s2) else 0;
	}

	@:op(a + b)
	public static inline function add(a:Event, b:Event):Event {
		return cast((cast a : Blade4) + (cast b : Blade4));
	}

	@:op(a - b)
	public static inline function sub(a:Event, b:Event):Event {
		return cast((cast a : Blade4) - (cast b : Blade4));
	}

	@:op(a * b)
	@:commutative
	public static inline function scale(a:Event, s:Float):Event {
		return cast((cast a : Blade4) * s);
	}

	@:op(-a)
	public static inline function neg(a:Event):Event {
		return cast(-(cast a : Blade4));
	}
}

/** Shorthand constructor for Event */
inline function event(t:Float, x:Float, y:Float, z:Float):Event {
	return new Event(t, x, y, z);
}
