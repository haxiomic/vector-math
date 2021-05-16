import TestFramework;
import VectorMath;

// when comparing floats
final precision = 1000000;

inline function quatMul(q1: Vec4, q2: Vec4)
	return vec4(
		 q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x,
		-q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y,
		 q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z,
		-q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w
	);

inline function quatConj(q: Vec4)
	return vec4(-q.xyz, q.w);

inline function quatRotate(point: Vec3, q: Vec4) {
	var qp = quatMul(q, vec4(point, 0.0));
	return quatMul(qp, vec4(-q.xyz, q.w));
}

inline function quatRotationBetween(v1: Vec3, v2: Vec3) {
	return normalize(
		vec4(
			cross(v1, v2),
			sqrt(
				dot(v1, v1) * dot(v2, v2)
			) + dot(v1, v2)
		)
	);
}

function main() {
	testsStart();

	test(sign(1) == 1);
	test(sign(-1) == -1);
	test(sign(0) == 0);

	// mod
	testLimitedPrecision(mod(-7, 4.4) == 1.8);
	testLimitedPrecision(mod(2.9, 3) == 2.9);
	testLimitedPrecision(mod(3.5, 3) == 0.5);
	testLimitedPrecision(mod(6.5, 3.8) == 2.7);

	testLimitedPrecision(mod(vec2(-0.1, 6.5), 3) == vec2(2.9, 0.5));
	testLimitedPrecision(mod(vec2(-0.1, 6.5), vec2(2.2, 3.3)) == vec2(2.1, 3.2));
	testLimitedPrecision(mod(vec3(-0.1, 6.5, -7), vec3(2.2, 3.3, 4.4)) == vec3(2.1, 3.2, 1.8));

	// log2
	test(floor(log2(8)) == 3);
	testLimitedPrecision(log2(5) == 2.321928095);
	test(floor(log2(vec3(8))) == vec3(3));

	// swizzles aliases
	test(vec4(1,2,3,4).wzyx == vec4(4,3,2,1));
	test(vec4(1,2,3,4).abgr == vec4(4,3,2,1));
	test(vec4(1,2,3,4).qpts == vec4(4,3,2,1));

	var v4 = vec4(1,2,3,4);
	test(v4.a == 4.0);
	test(v4.q == 4.0);
	v4.a = -1;
	test(v4.a == -1.0);
	test(v4.q == -1.0);

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
	
	// transpose
	test(
		transpose(mat2(
			1, 2,
			3, 4
		)) == mat2(
			1, 3,
			2, 4
		)
	);

	// determinant
	test(
		determinant(mat2(
			2, 3, 
			11,13
		)) == -7
	);

	// inverse
	testLimitedPrecision(
		inverse(mat2(
			2, 3, 
			11,13
		))
			==
		mat2(
			-13/7, 3/7,
			11/7, -2/7
		)
	);

	// adjoint
	test(
		adjoint(mat2(
			2, 3,
			11,13
		)) == mat2(
			13, -3,
			-11, 2
		)
	);

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

	// transpose
	test(
		transpose(mat3(
			 1,  2,  3,
			 5,  6,  7,
			 9, 10, 11
		)) == mat3(
			1, 5, 9, 
			2, 6, 10,
			3, 7, 11
		)
	);

	// determinant
	test(
		determinant(mat3(
			2, 3, 5, 
			11,13,17,
			23,29,31
		)) == 70
	);

	// inverse
	testLimitedPrecision(
		inverse(mat3(
			2, 3, 5, 
			11,13,17,
			23,29,31
		))
		== 
		mat3(
			-9/7, 26/35, -1/5,
			5/7, -53/70, 3/10,
			2/7, 11/70, -1/10
		)
	);

	// adjoint
	test(
		adjoint(mat3(
			2, 3, 5,
			11,13,17,
			23,29,31
		)) == mat3(
			-90, 52, -14,
			50, -53, 21,
			20, 11, -7
		)
	);

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

	// matrixCompMult
	test(matrixCompMult(mat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), mat4(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)) == mat4(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32));

	// transpose
	test(
		transpose(mat4(
			 1,  2,  3,  4,
			 5,  6,  7,  8,
			 9, 10, 11, 12,
			13, 14, 15, 16
		)) == mat4(
			1, 5, 9, 13,
			2, 6, 10, 14,
			3, 7, 11, 15,
			4, 8, 12, 16
		)
	);

	// determinant
	test(
		determinant(mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)) == 880
	);

	// inverse
	testLimitedPrecision(
		inverse(mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		))
			==
		mat4(
			 3/11, -12/55, -1/5, 2/11,
			-5/11, -2/55, 3/10, -3/22,
			-13/22, 307/440, -1/10, -9/88,
			15/22, -37/88, 0, 7/88
		)
	);

	// adjoint
	test(
		adjoint(mat4(
			2, 3, 5, 7,
			11,13,17,19,
			23,29,31,37,
			41,43,47,53
		)) == mat4(
			240, -192, -176, 160,
			-400, -32, 264, -120,
			-520, 614, -88, -90,
			600, -370, 0, 70
		)
	);

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

	// find rotation quaternion between v1 and v2, then rotate v1 by this quaternion
	var v1 = vec3(3,-1,8).normalize();
	var v2 = vec3(1,2,3).normalize();
	var q = quatRotationBetween(v1, v2);
	var r = quatRotate(v1, q).xyz;
	test(floor(r * 10000) / 10000 == floor(v2 * 10000) / 10000);

	var pos = vec4(1);
	var result = pos.xy = vec2(0.0);
	test(result == vec2(0.0));
	var result = pos.xy += 0.5;
	test(result == vec2(0.5));

	testsComplete();
}

overload extern inline function limitPrecision(x: Float): Float return floor(x * precision) / precision;
overload extern inline function limitPrecision(x: Vec2): Vec2 return floor(x * precision) / precision;
overload extern inline function limitPrecision(x: Vec3): Vec3 return floor(x * precision) / precision;
overload extern inline function limitPrecision(x: Vec4): Vec4 return floor(x * precision) / precision;
overload extern inline function limitPrecision(x: Mat2): Mat2 {
	var m = x * precision;
	return mat2(floor(m[0]), floor(m[1])) / precision;
}
overload extern inline function limitPrecision(x: Mat3): Mat3 {
	var m = x * precision;
	return mat3(floor(m[0]), floor(m[1]), floor(m[2])) / precision;
}
overload extern inline function limitPrecision(x: Mat4): Mat4 {
	var m = x * precision;
	return mat4(floor(m[0]), floor(m[1]), floor(m[2]), floor(m[3])) / precision;
}