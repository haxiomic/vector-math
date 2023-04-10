/**
	Macros required by VectorMath

	xyzw
	rgba
	stpq
**/

import haxe.macro.Expr;
import haxe.macro.Context;

class Swizzle {

	static public function generateFields(vectorLength: Int) {
		var fields = Context.getBuildFields();
		// for vector length N, we generate all possible combinations of 4 (or less)
		// for swizzles that do not repeat, we also add a setter

		generateSwizzles(fields, vectorLength, xyzw, true);

		// add .rgba and .stpq swizzles
		generateSwizzles(fields, vectorLength, ['r','g','b','a'], false);
		generateSwizzles(fields, vectorLength, ['s','t','p','q'], false);

		return fields;
	}

	static function generateSwizzles(fields: Array<Field>, vectorLength: Int, keys: Array<String>, skipLength1: Bool) {
		// length 1 fields
		if (!skipLength1) for (i in 0...vectorLength) {
			generateProperty(fields, [i], keys);
		}
		// length 2 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				generateProperty(fields, [i,j], keys);
			}
		}
		// length 3 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				for (k in 0...vectorLength) {
					generateProperty(fields, [i,j,k], keys);
				}
			}
		}
		// length 4 fields
		for (i in 0...vectorLength) {
			for (j in 0...vectorLength) {
				for (k in 0...vectorLength) {
					for (l in 0...vectorLength) {
						generateProperty(fields, [i,j,k,l], keys);
					}
				}
			}
		}
	}

	static final xyzw = ['x', 'y', 'z', 'w'];
	// build some useful lookups
	static final thisReadExpr = xyzw.map(c -> macro this.$c);
	static final vReadExpr = xyzw.map(c -> macro v.$c);
	static final vectorTypeMap: Array<TypePath> = [
		{ pack: [], name: 'Float' },
		{ pack: [], name: 'Vec2' },
		{ pack: [], name: 'Vec3' },
		{ pack: [], name: 'Vec4' }
	];

	static function generateProperty(fields: Array<Field>, swizzle: Array<Int>, keys: Array<String>) {
		var ident = swizzle.map(i -> keys[i]).join('');
		var readonly = hasDuplicate(swizzle);
		
		var typePath = vectorTypeMap[swizzle.length - 1];

		var type: ComplexType = TPath(typePath);

		var declaration = if (readonly) {
			(macro class { public var $ident(get, never): $type; }).fields[0]; 
		} else {
			(macro class { public var $ident(get, set): $type; }).fields[0]; 
		}

		// add @:noCompletion if swizzle is not a single component
		if (swizzle.length > 1) {
			declaration.meta = [{
				name: ':noCompletion',
				pos: Context.currentPos(),
			}];
		}

		var getterName = 'get_$ident';
		var getter = (macro class {
			inline function $getterName(): $type
				return ${
					if (swizzle.length > 1) {
						macro new $typePath( $a{swizzle.map(i -> thisReadExpr[i])} );
					} else {
						thisReadExpr[swizzle[0]];
					}
				}
		}).fields[0];

		fields.push(declaration);
		fields.push(getter);

		if (!readonly) {
			var setterName = 'set_$ident';
			var setter = (macro class {
				inline function $setterName(v: $type): $type {
					$b{[for (i in 0...swizzle.length) 
						macro ${thisReadExpr[swizzle[i]]} = ${swizzle.length > 1 ? vReadExpr[i] : macro v}
					]}
					return ${swizzle.length > 1 ? macro v.clone() : macro v};
				}
			}).fields[0];
			fields.push(setter);
		}
	}

	static function hasDuplicate(array: Array<Int>) {
		for (i in 0...array.length) {
			for (j in (i + 1)...array.length) {
				if (array[i] == array[j]) return true;
			}
		}
		return false;
	}

}