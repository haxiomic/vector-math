/**
	Macros required by VectorMath
	we use exceptions rather than Context.error for compile-time performance; it saves parsing and typing all the types included when using Context

	xyzw
	rgba
	stpq
**/

function swizzleReadExpr(self: haxe.macro.Expr, name: String) {
	var f = fields(name);
	var f0 = f[0];
	var f1 = f[1];
	var f2 = f[2];
	var f3 = f[3];
	return switch name.length {
		case 1:
			macro {
				var self = $self;
				self.$f0;
			}
		case 2:
			macro {
				var self = $self;
				new Vec2(self.$f0, self.$f1);
			}
		case 3:
			macro {
				var self = $self;
				new Vec3(self.$f0, self.$f1, self.$f2);
			}
		case 4:
			macro {
				var self = $self;
				new Vec4(self.$f0, self.$f1, self.$f2, self.$f3);
			}
		default:
			throw 'Unsupported swizzle read ".$name"';
	}
}

function swizzleWriteExpr(self, name: String, value) {
	var f = fields(name);
	var f0 = f[0];
	var f1 = f[1];
	var f2 = f[2];
	var f3 = f[3];
	return switch name.length {
		case 1:
			macro {
				var self = $self;
				self.$f0 = $value;
			}
		case 2:
			if (f0 == f1) {
				throw 'Swizzle ".$name" disallowed because of duplicate field write';
			}
			macro {
				var self = $self;
				var value: Vec2 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
				value;
			}
		case 3:
			if (
				f0 == f1 || f0 == f2 ||
				f1 == f2
			) {
				throw 'Swizzle ".$name" disallowed because of duplicate field write';
			}
			macro {
				var self = $self;
				var value: Vec3 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
				self.$f2 = value.z;
				value;
			}
		case 4:
			if (
				f0 == f1 || f0 == f2 || f0 == f3 ||
				f1 == f2 || f1 == f3 || 
				f2 == f3
			) {
				throw 'Swizzle ".$name" disallowed because of duplicate field write';
			}
			macro {
				var self = $self;
				var value: Vec4 = $value;
				self.$f0 = value.x;
				self.$f1 = value.y;
				self.$f2 = value.z;
				self.$f3 = value.w;
				value;
			}
		default:
			throw 'Unsupported swizzle write ".$name"';
	}
}

private function fields(swizzle: String): Array<String> {
	var c0 = swizzle.charAt(0);
	return if (c0 >= 'w') { // xyzw
		[for (i in 0...swizzle.length) swizzle.charAt(i)];
	} else if (c0 == 'r' || c0 < 'p') { // rgba
		[for (i in 0...swizzle.length) {
			switch swizzle.charAt(i) {
				case 'r': 'x';
				case 'g': 'y';
				case 'b': 'z';
				case 'a': 'w';
				case c: throw 'Vector component "$c" not in set rgba';
			}
		}];
	} else { // stpq
		[for (i in 0...swizzle.length) {
			switch swizzle.charAt(i) {
				case 's': 'x';
				case 't': 'y';
				case 'p': 'z';
				case 'q': 'w';
				case c: throw 'Vector component "$c" not in set stpq';
			}
		}];
	}
}
