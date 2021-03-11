/**
	Macros required by VectorMath
	we use exceptions rather than Context.error for compile-time performance; it saves parsing and typing all the types included when using Context
**/

function swizzleReadExpr(self: haxe.macro.Expr, name: String) {
	return switch name.length {
		case 2:
			var f0 = name.charAt(0); var f1 = name.charAt(1);
			macro {
				var self = $self;
				new Vec2(self.$f0, self.$f1);
			}
		case 3:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2);
			macro {
				var self = $self;
				new Vec3(self.$f0, self.$f1, self.$f2);
			}
		case 4:
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2); var f3 = name.charAt(3);
			macro {
				var self = $self;
				new Vec4(self.$f0, self.$f1, self.$f2, self.$f3);
			}
		default:
			throw 'Unsupported swizzle read ".$name"';
	}
}

function swizzleWriteExpr(self, name: String, value) {
	return switch name.length {
		case 2:
			var f0 = name.charAt(0); var f1 = name.charAt(1);
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
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2);
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
			var f0 = name.charAt(0); var f1 = name.charAt(1); var f2 = name.charAt(2); var f3 = name.charAt(3);
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