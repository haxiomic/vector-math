import TestFramework;
import VectorMath;

// Tolerance for floating point comparisons
// f32 has ~7 significant digits, so 1e-5 is reasonable
final epsilon = 1e-5;

// Helper for approximate equality
inline function approxEq(a: Float, b: Float): Bool {
	return Math.abs(a - b) < epsilon;
}

inline function approxZero(a: Float): Bool {
	return Math.abs(a) < epsilon;
}

function testAlgebra() {
	// ============================================
	// Complex Number Tests
	// ============================================

	// Construction
	test(complex(3, 4).re == 3);
	test(complex(3, 4).im == 4);
	test(complex(5) == complex(5, 0));
	test(complex(vec2(1, 2)) == complex(1, 2));

	// Arithmetic
	test(complex(1, 2) + complex(3, 4) == complex(4, 6));
	test(complex(5, 7) - complex(2, 3) == complex(3, 4));
	test(complex(1, 2) * complex(3, 4) == complex(-5, 10)); // (1+2i)(3+4i) = 3+4i+6i+8i^2 = 3+10i-8 = -5+10i
	test(complex(3, 4) + 2 == complex(5, 4));
	test(complex(6, 8) * 0.5 == complex(3, 4));

	// Conjugate
	test(conjugate(complex(3, 4)) == complex(3, -4));
	test(conjugate(complex(-1, -2)) == complex(-1, 2));

	// Modulus
	test(length(complex(3, 4)) == 5.0); // |3+4i| = sqrt(9+16) = 5
	test(complex(3, 4).modulusSquared() == 25.0);

	// Argument
	test(approxEq(complex(1, 1).argument(), Math.PI / 4));
	test(approxEq(complex(0, 1).argument(), Math.PI / 2));

	// Division
	var divResult = complex(1, 0) / complex(0, 1);
	test(approxZero(divResult.re) && approxEq(divResult.im, -1)); // 1/i = -i

	var divResult2 = complex(2, 3) / complex(1, 1);
	test(approxEq(divResult2.re, 2.5) && approxEq(divResult2.im, 0.5));

	// Euler's formula: e^(i*pi) = -1
	var euler = complex(0, Math.PI).exp();
	test(approxEq(euler.re, -1.0));
	test(approxZero(euler.im));

	// Square root: sqrt(-1) = i
	var sqrtNeg1 = complex(-1, 0).sqrt();
	test(approxZero(sqrtNeg1.re));
	test(approxEq(sqrtNeg1.im, 1.0));

	// Polar roundtrip
	var c = complex(3, 4);
	var polar = c.toPolar();
	var roundtrip = Complex.fromPolar(polar.x, polar.y);
	test(approxEq(roundtrip.re, c.re));
	test(approxEq(roundtrip.im, c.im));

	// Normalize
	var normalized = normalize(complex(3, 4));
	test(approxEq(length(normalized), 1.0));

	// Inverse
	var inv = inverse(complex(3, 4));
	var product = complex(3, 4) * inv;
	test(approxEq(product.re, 1.0));
	test(approxZero(product.im));

	// Tan: tan(z) = sin(z) / cos(z)
	var tanResult = complex(1.0, 0.5).tan();
	var sinC = complex(1.0, 0.5).sin();
	var cosC = complex(1.0, 0.5).cos();
	var tanExpected = sinC / cosC;
	test(approxEq(tanResult.re, tanExpected.re));
	test(approxEq(tanResult.im, tanExpected.im));

	// Pow with real exponent: z^2 should equal z * z
	var z = complex(2, 3);
	var zSquaredPow = z.pow(2.0);
	var zSquaredMul = z * z;
	test(approxEq(zSquaredPow.re, zSquaredMul.re));
	test(approxEq(zSquaredPow.im, zSquaredMul.im));

	// Scalar - complex subtraction
	var scalarMinusComplex = 5.0 - complex(2, 3);
	test(approxEq(scalarMinusComplex.re, 3.0));
	test(approxEq(scalarMinusComplex.im, -3.0));

	// Scalar / complex
	var scalarDivComplex = 1.0 / complex(0, 1);
	test(approxZero(scalarDivComplex.re));
	test(approxEq(scalarDivComplex.im, -1.0)); // 1/i = -i

	// ============================================
	// Quaternion Tests
	// ============================================

	// Identity
	test(Quat.identity() == quat(0, 0, 0, 1));

	// Construction
	test(quat(1, 2, 3, 4).x == 1);
	test(quat(1, 2, 3, 4).y == 2);
	test(quat(1, 2, 3, 4).z == 3);
	test(quat(1, 2, 3, 4).w == 4);
	test(quat(vec4(1, 2, 3, 4)) == quat(1, 2, 3, 4));

	// Normalization
	test(approxEq(length(normalize(quat(1, 2, 3, 4))), 1.0));

	// Conjugate
	test(conjugate(quat(1, 2, 3, 4)) == quat(-1, -2, -3, 4));

	// Hamilton product: i*j = k
	var i = quat(1, 0, 0, 0);
	var j = quat(0, 1, 0, 0);
	var k = quat(0, 0, 1, 0);
	test(i * j == k);
	// j*i = -k (non-commutative!)
	test(j * i == quat(0, 0, -1, 0));

	// More Hamilton identities
	test(j * k == i);
	test(k * i == j);
	test(i * i == quat(0, 0, 0, -1)); // i^2 = -1

	// Rotation: 90 degrees around Z rotates (1,0,0) to (0,1,0)
	var rotZ90 = Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 2);
	var rotated = rotZ90.rotateVec3(vec3(1, 0, 0));
	test(approxZero(rotated.x));
	test(approxEq(rotated.y, 1.0));
	test(approxZero(rotated.z));

	// Axis-angle roundtrip
	var axis = vec3(1, 1, 1).normalize();
	var angle = Math.PI / 3;
	var q = Quat.fromAxisAngle(axis, angle);
	var axisAngle = q.toAxisAngle();
	test(approxEq(axisAngle.x, axis.x));
	test(approxEq(axisAngle.y, axis.y));
	test(approxEq(axisAngle.z, axis.z));
	test(approxEq(axisAngle.w, angle));

	// SLERP: Use a simpler case - 90 degree rotation to avoid 180 degree edge case
	// which is numerically unstable with f32
	var identityQuat = Quat.identity();
	var rot90 = Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 2);
	var mid = slerp(identityQuat, rot90, 0.5);
	// At t=0.5, should be 45 degree rotation
	var midRotated = mid.rotateVec3(vec3(1, 0, 0));
	// 45 degree rotation of (1,0,0) gives (cos45, sin45, 0) = (0.707, 0.707, 0)
	test(approxEq(midRotated.x, Math.cos(Math.PI / 4)));
	test(approxEq(midRotated.y, Math.sin(Math.PI / 4)));
	test(approxZero(midRotated.z));

	// Matrix roundtrip
	var q1 = Quat.fromAxisAngle(vec3(1, 2, 3).normalize(), 1.23);
	var mat = q1.toMat3();
	var q2 = Quat.fromMat3(mat);
	// Quaternions can differ by sign but represent same rotation
	var same = (approxEq(q1.x, q2.x) && approxEq(q1.y, q2.y) &&
		approxEq(q1.z, q2.z) && approxEq(q1.w, q2.w)) ||
		(approxEq(q1.x, -q2.x) && approxEq(q1.y, -q2.y) &&
			approxEq(q1.z, -q2.z) && approxEq(q1.w, -q2.w));
	test(same);

	// Rotation arc
	var v1 = vec3(1, 0, 0);
	var v2 = vec3(0, 1, 0);
	var arcQuat = Quat.fromRotationArc(v1, v2);
	var arcRotated = arcQuat.rotateVec3(v1);
	test(approxEq(arcRotated.x, v2.x));
	test(approxEq(arcRotated.y, v2.y));
	test(approxEq(arcRotated.z, v2.z));

	// Dot product
	test(approxEq(dot(quat(1, 2, 3, 4), quat(5, 6, 7, 8)), 70.0)); // 1*5 + 2*6 + 3*7 + 4*8 = 70

	// Mix (lerp)
	var mixResult = mix(quat(0, 0, 0, 1), quat(1, 0, 0, 0), 0.5);
	test(approxEq(mixResult.x, 0.5));
	test(approxEq(mixResult.w, 0.5));

	// fromRotationX/Y/Z vs fromAxisAngle
	var rotX = Quat.fromRotationX(Math.PI / 4);
	var rotXAxis = Quat.fromAxisAngle(vec3(1, 0, 0), Math.PI / 4);
	test(approxEq(rotX.x, rotXAxis.x));
	test(approxEq(rotX.w, rotXAxis.w));

	var rotY = Quat.fromRotationY(Math.PI / 4);
	var rotYAxis = Quat.fromAxisAngle(vec3(0, 1, 0), Math.PI / 4);
	test(approxEq(rotY.y, rotYAxis.y));
	test(approxEq(rotY.w, rotYAxis.w));

	var rotZ = Quat.fromRotationZ(Math.PI / 4);
	var rotZAxis = Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 4);
	test(approxEq(rotZ.z, rotZAxis.z));
	test(approxEq(rotZ.w, rotZAxis.w));

	// Euler angles roundtrip (simple case: single axis rotation)
	var pitch = Math.PI / 6;
	var yaw = 0.0;
	var roll = 0.0;
	var fromEuler = Quat.fromEuler(pitch, yaw, roll);
	var euler = fromEuler.toEuler();
	test(approxEq(euler.x, pitch)); // pitch
	test(approxZero(euler.y)); // yaw
	test(approxZero(euler.z)); // roll

	// Quaternion inverse: q * q^-1 = identity
	var qForInv = Quat.fromAxisAngle(vec3(1, 2, 3).normalize(), 1.0);
	var qInv = inverse(qForInv);
	var shouldBeIdentity = qForInv * qInv;
	test(approxZero(shouldBeIdentity.x));
	test(approxZero(shouldBeIdentity.y));
	test(approxZero(shouldBeIdentity.z));
	test(approxEq(shouldBeIdentity.w, 1.0));

	// nlerp: same as slerp for small angles
	var nlerpResult = identityQuat.nlerp(rot90, 0.5);
	var nlerpRotated = nlerpResult.rotateVec3(vec3(1, 0, 0));
	test(approxEq(nlerpRotated.x, Math.cos(Math.PI / 4)));
	test(approxEq(nlerpRotated.y, Math.sin(Math.PI / 4)));

	// angleBetween
	var angleResult = identityQuat.angleBetween(rot90);
	test(approxEq(angleResult, Math.PI / 2));

	// lengthSquared
	test(approxEq(quat(1, 2, 3, 4).lengthSquared(), 30.0)); // 1+4+9+16=30

	// Subtraction
	test(quat(5, 6, 7, 8) - quat(1, 2, 3, 4) == quat(4, 4, 4, 4));

	// Scalar division
	var divScalar = quat(2, 4, 6, 8) / 2.0;
	test(divScalar == quat(1, 2, 3, 4));

	// ============================================
	// Dual Number Tests
	// ============================================

	// Construction
	test(dual(3, 4).re == 3);
	test(dual(3, 4).du == 4);
	test(dual(5) == dual(5, 0));

	// Arithmetic
	test(dual(1, 2) + dual(3, 4) == dual(4, 6));
	test(dual(5, 7) - dual(2, 3) == dual(3, 4));
	// Dual multiplication: (a + εb)(c + εd) = ac + ε(ad + bc) since ε²=0
	test(dual(2, 3) * dual(4, 5) == dual(8, 22)); // 2*4 + ε(2*5 + 3*4) = 8 + 22ε
	test(dual(3, 4) + 2 == dual(5, 4));
	test(dual(6, 8) * 0.5 == dual(3, 4));

	// Conjugate
	test(conjugate(dual(3, 4)) == dual(3, -4));

	// Nilpotent property: ε² = 0
	// If d = dual(0, 1) (pure epsilon), then d*d should have du = 0
	var epsilonDual = dual(0, 1);
	var epsSq = epsilonDual * epsilonDual;
	test(epsSq.re == 0);
	test(epsSq.du == 0);

	// Automatic differentiation tests
	// d/dx sin(x) = cos(x)
	var x = 1.5;
	var sinDeriv = sin(Dual.variable(x));
	test(approxEq(sinDeriv.re, Math.sin(x)));
	test(approxEq(sinDeriv.du, Math.cos(x)));

	// d/dx exp(x) = exp(x)
	var expDeriv = exp(Dual.variable(x));
	test(approxEq(expDeriv.re, Math.exp(x)));
	test(approxEq(expDeriv.du, Math.exp(x)));

	// d/dx sqrt(x) = 0.5/sqrt(x)
	var sqrtDeriv = sqrt(Dual.variable(x));
	test(approxEq(sqrtDeriv.re, Math.sqrt(x)));
	test(approxEq(sqrtDeriv.du, 0.5 / Math.sqrt(x)));

	// d/dx cos(x) = -sin(x)
	var cosDeriv = cos(Dual.variable(x));
	test(approxEq(cosDeriv.re, Math.cos(x)));
	test(approxEq(cosDeriv.du, -Math.sin(x)));

	// d/dx log(x) = 1/x
	var logDeriv = log(Dual.variable(x));
	test(approxEq(logDeriv.re, Math.log(x)));
	test(approxEq(logDeriv.du, 1.0 / x));

	// d/dx x^3 = 3x^2
	var powDeriv = pow(Dual.variable(x), 3);
	test(approxEq(powDeriv.re, Math.pow(x, 3)));
	test(approxEq(powDeriv.du, 3 * Math.pow(x, 2)));

	// Chain rule: d/dx sin(x^2)
	// = cos(x^2) * 2x
	var xDual = Dual.variable(x);
	var chainResult = sin(xDual * xDual);
	test(approxEq(chainResult.re, Math.sin(x * x)));
	test(approxEq(chainResult.du, Math.cos(x * x) * 2 * x));

	// Division derivative: d/dx (1/x) = -1/x^2
	var divDeriv = 1.0 / Dual.variable(x);
	test(approxEq(divDeriv.re, 1.0 / x));
	test(approxEq(divDeriv.du, -1.0 / (x * x)));

	// d/dx tan(x) = sec^2(x) = 1/cos^2(x)
	var tanDeriv = Dual.variable(x).tan();
	test(approxEq(tanDeriv.re, Math.tan(x)));
	var cosX = Math.cos(x);
	test(approxEq(tanDeriv.du, 1.0 / (cosX * cosX)));

	// d/dx asin(x) = 1/sqrt(1-x^2), use x=0.5 to stay in domain
	var asinX = 0.5;
	var asinDeriv = Dual.variable(asinX).asin();
	test(approxEq(asinDeriv.re, Math.asin(asinX)));
	test(approxEq(asinDeriv.du, 1.0 / Math.sqrt(1 - asinX * asinX)));

	// d/dx acos(x) = -1/sqrt(1-x^2)
	var acosDeriv = Dual.variable(asinX).acos();
	test(approxEq(acosDeriv.re, Math.acos(asinX)));
	test(approxEq(acosDeriv.du, -1.0 / Math.sqrt(1 - asinX * asinX)));

	// d/dx atan(x) = 1/(1+x^2)
	var atanDeriv = Dual.variable(x).atan();
	test(approxEq(atanDeriv.re, Math.atan(x)));
	test(approxEq(atanDeriv.du, 1.0 / (1 + x * x)));

	// d/dx |x| = sign(x) for x > 0
	var absDeriv = Dual.variable(x).abs();
	test(approxEq(absDeriv.re, x));
	test(approxEq(absDeriv.du, 1.0));

	// Dual.constant has zero derivative
	var constDual = Dual.constant(5.0);
	test(constDual.re == 5.0);
	test(constDual.du == 0.0);

	// Negation
	test(-dual(3, 4) == dual(-3, -4));

	// Subtraction variants
	test(dual(5, 6) - 2.0 == dual(3, 6));
	test(10.0 - dual(3, 4) == dual(7, -4));

	// Division variants
	test(approxEq((dual(6, 8) / 2.0).re, 3.0));
	test(approxEq((dual(6, 8) / 2.0).du, 4.0));

	// ============================================
	// Dual Quaternion Tests
	// ============================================

	// Identity
	var dqIdentity = DualQuat.identity();
	test(dqIdentity.real == Quat.identity());
	test(dqIdentity.dual == quat(0, 0, 0, 0));

	// Identity transform doesn't change point
	var point = vec3(1, 2, 3);
	var identityTransformed = dqIdentity.transformPoint(point);
	test(identityTransformed == point);

	// Pure rotation (no translation)
	var pureRot = dualquat(Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 2), vec3(0, 0, 0));
	var rotPoint = pureRot.transformPoint(vec3(1, 0, 0));
	test(approxZero(rotPoint.x));
	test(approxEq(rotPoint.y, 1.0));
	test(approxZero(rotPoint.z));

	// Pure translation (no rotation)
	var pureTrans = dualquat(Quat.identity(), vec3(1, 2, 3));
	var transPoint = pureTrans.transformPoint(vec3(0, 0, 0));
	test(approxEq(transPoint.x, 1.0));
	test(approxEq(transPoint.y, 2.0));
	test(approxEq(transPoint.z, 3.0));

	// Combined rotation and translation
	var combined = dualquat(Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 2), vec3(10, 0, 0));
	var combinedResult = combined.transformPoint(vec3(1, 0, 0));
	// First rotate (1,0,0) -> (0,1,0), then translate by (10,0,0)
	test(approxEq(combinedResult.x, 10.0));
	test(approxEq(combinedResult.y, 1.0));
	test(approxZero(combinedResult.z));

	// Transform vector (direction) - should only rotate, not translate
	var transformedVec = combined.transformVector(vec3(1, 0, 0));
	test(approxZero(transformedVec.x));
	test(approxEq(transformedVec.y, 1.0));
	test(approxZero(transformedVec.z));

	// Composition: dq1 * dq2 combines transforms
	var dq1 = dualquat(Quat.identity(), vec3(1, 0, 0));
	var dq2 = dualquat(Quat.identity(), vec3(0, 1, 0));
	var composed = dq1 * dq2;
	var composedResult = composed.transformPoint(vec3(0, 0, 0));
	test(approxEq(composedResult.x, 1.0));
	test(approxEq(composedResult.y, 1.0));
	test(approxZero(composedResult.z));

	// Extraction
	var rot = Quat.fromAxisAngle(vec3(0, 1, 0), Math.PI / 4);
	var trans = vec3(5, 10, 15);
	var dq = dualquat(rot, trans);
	var extractedRot = dq.getRotation();
	var extractedTrans = dq.getTranslation();
	// Rotation should match (possibly negated)
	var rotMatch = (approxEq(extractedRot.x, rot.x) && approxEq(extractedRot.y, rot.y) &&
		approxEq(extractedRot.z, rot.z) && approxEq(extractedRot.w, rot.w));
	test(rotMatch);
	test(approxEq(extractedTrans.x, trans.x));
	test(approxEq(extractedTrans.y, trans.y));
	test(approxEq(extractedTrans.z, trans.z));

	// Mat4 roundtrip
	var dqOriginal = dualquat(Quat.fromAxisAngle(vec3(1, 0, 0), Math.PI / 6), vec3(2, 3, 4));
	var mat4 = dqOriginal.toMat4();
	var dqFromMat = DualQuat.fromMat4(mat4);
	var originalTrans = dqOriginal.getTranslation();
	var roundtripTrans = dqFromMat.getTranslation();
	test(approxEq(originalTrans.x, roundtripTrans.x));
	test(approxEq(originalTrans.y, roundtripTrans.y));
	test(approxEq(originalTrans.z, roundtripTrans.z));

	// nlerp interpolation test
	var dqStart = dualquat(Quat.identity(), vec3(0, 0, 0));
	var dqEnd = dualquat(Quat.identity(), vec3(10, 0, 0));
	var dqMid = dqStart.nlerp(dqEnd, 0.5);
	var midTrans = dqMid.getTranslation();
	test(approxEq(midTrans.x, 5.0));

	// Normalize
	var unnormalized = new DualQuat(quat(1, 2, 3, 4), quat(0.1, 0.2, 0.3, 0.4));
	var normalizedDq = normalize(unnormalized);
	test(approxEq(normalizedDq.real.length(), 1.0));

	// Mix (lerp) for dual quaternions
	var mixDq = mix(dqStart, dqEnd, 0.5);
	test(mixDq != null);

	// Conjugate
	var conjDq = conjugate(combined);
	test(conjDq.real == combined.real.conjugate());
	test(conjDq.dual == combined.dual.conjugate());

	// dualConjugate: negates dual part only
	var dualConj = combined.dualConjugate();
	test(dualConj.real == combined.real);
	test(dualConj.dual == -combined.dual);

	// fullConjugate: both conjugates
	var fullConj = combined.fullConjugate();
	test(fullConj.real == combined.real.conjugate());
	test(fullConj.dual == -combined.dual.conjugate());

	// toRotationTranslation decomposition
	var decomp = dq.toRotationTranslation();
	test(approxEq(decomp.rotation.x, rot.x));
	test(approxEq(decomp.rotation.y, rot.y));
	test(approxEq(decomp.rotation.z, rot.z));
	test(approxEq(decomp.rotation.w, rot.w));
	test(approxEq(decomp.translation.x, trans.x));
	test(approxEq(decomp.translation.y, trans.y));
	test(approxEq(decomp.translation.z, trans.z));

	// length
	test(approxEq(dqIdentity.length(), 1.0));

	// ScLERP: test produces valid intermediate transform with correct rotation
	var sclerpStart = dualquat(Quat.identity(), vec3(0, 0, 0));
	var sclerpEnd = dualquat(Quat.fromAxisAngle(vec3(0, 0, 1), Math.PI / 2), vec3(10, 0, 0));

	// At t=0, should be at start
	var sclerpAtZero = sclerpStart.sclerp(sclerpEnd, 0.0);
	var transAtZero = sclerpAtZero.getTranslation();
	test(approxZero(transAtZero.x));
	test(approxZero(transAtZero.y));

	// At t=0.5, rotation should be at approximately 45 degrees
	var sclerpMid = sclerpStart.sclerp(sclerpEnd, 0.5);
	var sclerpRot = sclerpMid.getRotation();
	var sclerpRotatedVec = sclerpRot.rotateVec3(vec3(1, 0, 0));
	test(approxEq(sclerpRotatedVec.x, Math.cos(Math.PI / 4)));
	test(approxEq(sclerpRotatedVec.y, Math.sin(Math.PI / 4)));

	// Result should be a valid normalized dual quaternion
	test(approxEq(sclerpMid.real.length(), 1.0));

	// ScLERP with identical dual quaternions should return the same (from pytransform3d tests)
	var sclerpSame = sclerpStart.sclerp(sclerpStart, 0.5);
	test(approxZero(sclerpSame.getTranslation().x));
	test(approxEq(sclerpSame.real.w, 1.0)); // identity rotation

	// ScLERP pure translation (no rotation) - should interpolate translation linearly
	var transStart = dualquat(Quat.identity(), vec3(0, 0, 0));
	var transEnd = dualquat(Quat.identity(), vec3(10, 20, 30));
	var transMid = transStart.sclerp(transEnd, 0.5);
	var transMidTrans = transMid.getTranslation();
	// For pure translation, sclerp should match nlerp
	var nlerpMid = transStart.nlerp(transEnd, 0.5);
	var nlerpTrans = nlerpMid.getTranslation();
	test(approxEq(transMidTrans.x, nlerpTrans.x));
	test(approxEq(transMidTrans.y, nlerpTrans.y));
	test(approxEq(transMidTrans.z, nlerpTrans.z));

	// ScLERP shortest path: negated quaternion should give same result
	// (tests the dot product < 0 handling)
	var negatedEnd = new DualQuat(-sclerpEnd.real, -sclerpEnd.dual);
	var sclerpNeg = sclerpStart.sclerp(negatedEnd, 0.5);
	// Should still produce 45 degree rotation (same as with non-negated)
	var sclerpNegRot = sclerpNeg.getRotation().rotateVec3(vec3(1, 0, 0));
	test(approxEq(sclerpNegRot.x, Math.cos(Math.PI / 4)));
	test(approxEq(sclerpNegRot.y, Math.sin(Math.PI / 4)));

	// fromScrewAxis: rotation around axis with translation along axis
	var screwDq = DualQuat.fromScrewAxis(vec3(0, 0, 1), vec3(0, 0, 0), Math.PI / 2, 2.0);
	// Should rotate 90 degrees around Z and translate 2 units along Z
	var screwPoint = screwDq.transformPoint(vec3(1, 0, 0));
	test(approxZero(screwPoint.x));
	test(approxEq(screwPoint.y, 1.0));
	test(approxEq(screwPoint.z, 2.0));

	// Operators
	// Negation
	var negDq = -dqStart;
	test(negDq.real == -dqStart.real);
	test(negDq.dual == -dqStart.dual);

	// Addition
	var addDq = dq1 + dq2;
	test(addDq.real == dq1.real + dq2.real);
	test(addDq.dual == dq1.dual + dq2.dual);

	// Subtraction
	var subDq = dq1 - dq2;
	test(subDq.real == dq1.real - dq2.real);
	test(subDq.dual == dq1.dual - dq2.dual);

	// Scalar multiplication
	var scaledDq = dq * 2.0;
	test(scaledDq.real == dq.real * 2.0);
	test(scaledDq.dual == dq.dual * 2.0);
}
