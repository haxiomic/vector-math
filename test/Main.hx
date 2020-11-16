import VectorMath;

#if macro
import haxe.macro.Context;
import haxe.macro.PositionTools;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;
#end

function main() {
	testsStart();

	// ------------
	// -- Mat2
	// ------------
	test({
		var expected = [
			2, 3,
			11,13
		];
		var result = mat2(
			2, 3,
			11,13
		).copyIntoArray([], 0);
		var matching = true;
		for (i in 0...expected.length) {
			if (expected[i] != result[i]) {
				matching = false; break;
			}
		}
		matching;
	});

	// ------------
	// -- Mat3
	// ------------	

	// constructor
	test(mat3(2) == mat3(
		2,0,0,
		0,2,0,
		0,0,2
	));
	test(mat3(mat2(1,2,3,4)) == mat3(1,2,0,3,4,0,0,0,1)); // matrix from smaller matrix
	test(mat2(mat3(1,2,3,4,5,6,7,8,9)) == mat2(1,2,4,5)); // smaller matrix from bigger matrix
	test(vec4(mat2(1,2,3,4)) == vec4(1,2,3,4)); // vector from matrix
	test(vec4(mat3(1,2,3,4,5,6,7,8,9)) == vec4(1,2,3,4)); // vector from matrix

	// equality
	test(mat3(1,2,3,4,5,6,7,8,9) == mat3(1,2,3,4,5,6,7,8,9));
	test(mat3(1,2,3,4,5,6,7,8,-1) != mat3(1,2,3,4,5,6,7,8,9));
	// clone & copyFrom
	test({
		var o = mat3(1,2,3,4,5,6,7,8,9);
		o == o.clone();
	});
	test({
		var o = mat3(0,0,0,0,0,0,0,0,0);
		o.copyFrom(mat3(1,2,3,4,5,6,7,8,9));
		mat3(1,2,3,4,5,6,7,8,9) == o;
	});
	// matrixCompMult
	test(matrixCompMult(mat3(1,2,3,4,5,6,7,8,9), mat3(2,2,2,2,2,2,2,2,2)) == mat3(2,4,6,8,10,12,14,16,18));
	// array read
	test(mat3(1,2,3,4,5,6,7,8,9)[0] == vec3(1,2,3));
	test(mat3(1,2,3,4,5,6,7,8,9)[1] == vec3(4,5,6));
	test(mat3(1,2,3,4,5,6,7,8,9)[2] == vec3(7,8,9));
	// array write
	test({
		var m = mat3(1,2,3,4,5,6,7,8,9);
		m[0] = vec3(9,8,7);
		m[1] = vec3(6,5,4);
		m[2] = vec3(3,2,1);
		m == mat3(9,8,7,6,5,4,3,2,1);
	});
	// neg
	test(-(mat3(1,2,3,4,5,6,7,8,9)) == mat3(-1,-2,-3,-4,-5,-6,-7,-8,-9));
	// increment/decrement
	test({
		var m = mat3(1,2,3,4,5,6,7,8,9);
		var o = ++m;
		m == o && m == mat3(2,3,4,5,6,7,8,9,10);
	});
	test({
		var m = mat3(1,2,3,4,5,6,7,8,9);
		var o = m++;
		m != o && m == mat3(2,3,4,5,6,7,8,9,10);
	});
	// add
	test(mat3(1,2,3,4,5,6,7,8,9) + mat3(9,8,7,6,5,4,3,2,1) == mat3(10,10,10,10,10,10,10,10,10));
	test(mat3(1,2,3,4,5,6,7,8,9) + 1 == mat3(2,3,4,5,6,7,8,9,10));
	// sub
	test(mat3(1,2,3,4,5,6,7,8,9) - mat3(1,2,3,4,5,6,7,8,9) == mat3(0));
	test(mat3(1,2,3,4,5,6,7,8,9) - 1 == mat3(0,1,2,3,4,5,6,7,8));
	test(1 - mat3(1,2,3,4,5,6,7,8,9) == mat3(0,-1,-2,-3,-4,-5,-6,-7,-8));
	// multiply
	// tested using https://www.symbolab.com/solver/matrix-multiply-calculator
	test(mat3(2, 3, 5, 7,11,13,17,19,23) * mat3(29,31,37,41,43,47,53,59,61) == mat3(904, 1131, 1399, 1182, 1489, 1845, 1556, 1967, 2435));
	test(mat3(2, 3, 5, 7,11,13,17,19,23) * vec3(53,59,61) == vec3(1556, 1967, 2435));
	test(vec3(53,59,61) * mat3(2, 3, 5, 7,11,13,17,19,23) == vec3(588, 1813, 3425));
	test(2 * mat3(2, 3, 5, 7,11,13,17,19,23) == mat3(4, 6, 10, 14,22,26,34,38,46));
	// divide
	test(mat3(4, 6, 10, 14,22,26,34,38,46) / mat3(2, 2, 2, 2, 2, 2, 2, 2, 2) == mat3(2, 3, 5, 7,11,13,17,19,23));
	test(1 / mat3(2, 3, 5, 7,11,13,17,19,23) == mat3(1/2, 1/3, 1/5, 1/7,1/11,1/13,1/17,1/19,1/23));
	// assignment op
	test({
		var m = mat3(4, 6, 10, 14,22,26,34,38,46);
		m /= mat3(2, 2, 2, 2, 2, 2, 2, 2, 2);
		m == mat3(2, 3, 5, 7,11,13,17,19,23);
	});
	test({
		var m = mat3(4, 6, 10, 14,22,26,34,38,46);
		m /= 2;
		m == mat3(2, 3, 5, 7,11,13,17,19,23);
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = mat3(29,31,37,41,43,47,53,59,61);
		var _m = m.clone();
		m *= n;
		m == _m * n;
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = 2;
		var _m = m.clone();
		m *= n;
		m == _m * n;
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = mat3(29,31,37,41,43,47,53,59,61);
		var _m = m.clone();
		m += n;
		m == _m + n;
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = 2;
		var _m = m.clone();
		m += n;
		m == _m + n;
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = mat3(29,31,37,41,43,47,53,59,61);
		var _m = m.clone();
		m -= n;
		m == _m - n;
	});
	test({
		var m = mat3(2, 3, 5, 7,11,13,17,19,23);
		var n = 2;
		var _m = m.clone();
		m -= n;
		m == _m - n;
	});
	test({
		var expected = [
			2, 3, 5, 
			11,13,17,
			23,29,31
		];
		var result = mat3(
			2, 3, 5,
			11,13,17,
			23,29,31
		).copyIntoArray([], 0);
		var matching = true;
		for (i in 0...expected.length) {
			if (expected[i] != result[i]) {
				matching = false; break;
			}
		}
		matching;
	});

	// ------------
	// -- Mat4
	// ------------
	// constructor
	test(mat4(2) == mat4(
		2, 0, 0, 0,
		0, 2, 0, 0,
		0, 0, 2, 0,
		0, 0, 0, 2
	));
	test(
		// matrix from smaller matrix
		mat4(mat2(
			1, 2,
			3, 4
		))
			==
		mat4(
			1, 2, 0, 0,
			3, 4, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		)
	);
	test(
		// smaller matrix from bigger matrix
		mat2(
			mat4(
				 1,  2,  3,  4,
				 5,  6,  7,  8,
				 9, 10, 11, 12,
				13, 14, 15, 16
			)
		)
			==
		mat2(
			1, 2,
			5, 6
		)
	);
	test(
		// vector from matrix
		vec4(mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14, 15, 16
		))
			==
		vec4(1,2,3,4)
	);

	// equality
	test(
		mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14, 15, 16
		)
			==
		mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14, 15, 16
		)
	);
	test(
		mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14, 15, 16
		)
			!=
		mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14,-1, 16
		)
	);

	// clone & copyFrom
	test({
		var o = mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
		o == o.clone();
	});
	test({
		var o = mat4(0);
		o.copyFrom(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16));
		o == mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
	});

	// matrixCompMult
	test(matrixCompMult(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), mat4(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)) == mat4(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32));

	// array read
	test(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)[0] == vec4(1,2,3,4));
	test(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)[1] == vec4(5,6,7,8));
	test(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)[2] == vec4(9,10,11,12));
	test(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)[3] == vec4(13,14,15,16));

	// array write
	test({
		var m = mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
		m[0] = vec4(16,15,14,13);
		m[1] = vec4(12,11,10,9);
		m[2] = vec4(8,7,6,5);
		m[3] = vec4(4,3,2,1);
		m == mat4(16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1);
	});

	// neg
	test(-(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)) == mat4(-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16));

	// increment/decrement
	test({
		var m = mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
		var o = ++m;
		m == o && m == mat4(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17);
	});
	test({
		var m = mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
		var o = m++;
		m != o && m == mat4(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17);
	});

	// add
	test(
		mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) + mat4(16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
			== 
		mat4(17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17)
	);
	test(
		mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) + 1
			== 
		mat4(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
	);
	test(
		1 + mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
			== 
		mat4(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
	);

	// sub
	test(
		mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) - mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
			== 
		mat4(0)
	);
	test(
		mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16) - 1
			== 
		mat4(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
	);
	test(
		1 - mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
			== 
		mat4(0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15)
	);

	// multiply
	// test: https://www.symbolab.com/solver/matrix-multiply-calculator/%5Cbegin%7Bpmatrix%7D2%2611%2623%2641%5C%5C%203%2613%2629%2643%5C%5C%205%2617%2631%2647%5C%5C%207%2619%2637%2653%5Cend%7Bpmatrix%7D%5Cbegin%7Bpmatrix%7D59%2673%2697%26109%5C%5C%20%2061%2679%26101%26113%5C%5C%20%2067%2683%26103%26127%5C%5C%20%2071%2689%26107%26131%5Cend%7Bpmatrix%7D
	test(
		mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
			*
		mat4(
			59, 61, 67, 71,
			73, 79, 83, 89,
			97,101,103,107,
			109,113,127,131
		)
			==
		mat4(
			5241, 5966, 6746, 7814,
			6573, 7480, 8464, 9800,
			8061, 9192, 10424, 12080,
			9753, 11112, 12560, 14552
		)
	);
	test(
		mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
			*
		vec4(59, 61, 67, 71)
			==
		vec4(5241, 5966, 6746, 7814)
	);
	test(
		vec4(59, 61, 67, 71)
			*
		mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		) 
			==
		vec4(1133, 3930, 7830, 11954)
	);
	test(
		mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
			*
		2
			==
		mat4(
			2*2, 3*2, 5*2, 7*2,
			11*2,13*2,17*2,19*2,
			23*2,29*2,31*2,37*2,
			41*2,43*2,47*2,53*2
		)
	);
	test(
		2 * mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
			==
		mat4(
			2*2, 3*2, 5*2, 7*2,
			11*2,13*2,17*2,19*2,
			23*2,29*2,31*2,37*2,
			41*2,43*2,47*2,53*2
		)
	);
	// divide
	test(
		mat4(
			2*2, 3*2, 5*2, 7*2,
			11*2,13*2,17*2,19*2,
			23*2,29*2,31*2,37*2,
			41*2,43*2,47*2,53*2
		) / mat4(
			2,2,2,2,
			2,2,2,2,
			2,2,2,2,
			2,2,2,2
		)
			==
		mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
	);
	test(
		1 / mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)
			==
		mat4(
			1/2, 1/3, 1/5, 1/7,
			1/11,1/13,1/17,1/19,
			1/23,1/29,1/31,1/37,
			1/41,1/43,1/47,1/53
		)
	);
	test({
		var expected = [
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		];
		var result = mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		).copyIntoArray([], 0);
		var matching = true;
		for (i in 0...expected.length) {
			if (expected[i] != result[i]) {
				matching = false; break;
			}
		}
		matching;
	});

	// ------------
	// # Misc
	// ------------

	test({
		var v = vec2(incrementingNumber());
		v.x == v.y;
	});

	test(mat2(2) * vec2(1, 2) == vec2(2, 4));
	test(vec2(1, 2) * mat2(2) == vec2(2, 4));
	test(vec4(vec3(1, 2, 3), 4) == vec4(1, 2, 3, 4));
	test(length(vec2(2, 3) + 1) == 5);

	test(normalize(0.1) == 1.0);
	test(normalize(vec2(3, 4)) == vec2(3/5, 4/5));
	test(normalize(0.0) == 0.0, "technically the spec doesn't define what happens when you normalize a 0-length vector but returning 0.0 seems to be common in implementations");
	test(normalize(vec4(0.0)) == vec4(0.0), "technically the spec doesn't define what happens when you normalize a 0-length vector but returning 0.0 seems to be common in implementations");

	testsComplete();
}

var _incrementingNumber: Int = 12;
function incrementingNumber() {
	return _incrementingNumber++;
}

/**
	--------------
	Test Framework
	--------------
**/

var testsPassed = 0;
var testsFailed = 0;
var tStart_s = 0.0;
function testPassed() {
	testsPassed++;
}
function testFailed() {
	testsFailed++;
}
function testsStart() {
	tStart_s = haxe.Timer.stamp();
}
function testsComplete() {
	var dt_ms = (haxe.Timer.stamp() - tStart_s) * 1000;
	dt_ms = Math.round(dt_ms * 10000) / 10000;

	var testsTotal = testsPassed + testsFailed;
	if (testsTotal == 0) {
		println('[${getTargetName()}] No tests were run');
		return;
	}
	if (testsFailed == 0) {
		println('[${getTargetName()}] All tests passed ($testsPassed/$testsTotal) [$dt_ms ms]');
	} else {
		println('[${getTargetName()}] $testsFailed tests failed ($testsPassed/$testsTotal passed) [$dt_ms ms]');
	}
}


macro function test(expr, ?details) {
	var pos = Context.currentPos();
	var isBoolExpr = Context.unify(Context.typeof(expr), ComplexTypeTools.toType(macro :Bool));
	if (!isBoolExpr) {
		Context.fatalError('Test expression should be a Bool expression', pos);
	}

	var p = new haxe.macro.Printer('\t');
	var exprString = p.printExpr(expr);
	var posInfo = PositionTools.toLocation(pos);

	var binop = getFinalBinop(expr.expr);
	var valuesPrint = if (binop != null) {
		macro println(
			'\n\tResolved values:\n\n' +
			'\t' + $e{binop.e1} + '\n' +
			'\t ' + $v{p.printBinop(binop.op)} + '\n' +
			'\t' + $e{binop.e2} + '\n'
		);
	} else {
		macro null;
	}
	
	return macro if (!${expr}) {
		testFailed();
		var detail = ${details};
		println(
			'Test failed (' + $v{posInfo.file} + ':' + $v{posInfo.range.start.line} + ')\n\n' +
			(detail != null ? '\t' + detail + '\n' : '') +
			$v{exprString.split('\n').map(l -> '\t' + l).join('\n')}
		);
		$valuesPrint;
	} else {
		testPassed();
	};
}

function println(str) {
	#if sys
	Sys.println(str);
	#elseif js
	js.Browser.console.log(str);
	#else
	trace(str);
	#end
}

macro function getTargetName() {
	return macro $v{Context.definedValue('target.name')};
}

#if macro
function getFinalBinop(expr) {
	return switch expr {
		case EBinop(op, e1, e2): { op: op, e1: e1, e2: e2 };
		// case EBlock(exprs): getFinalBinop(exprs[exprs.length - 1].expr);
		default: null;
	}
}
#end