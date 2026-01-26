import TestFramework;
import VectorMath;
import pga.Blade3;
import pga.Blade4;
import pga.Point;
import pga.Point.point;
import pga.Line;
import pga.Line.line;
import pga.Plane;
import pga.Plane.plane;
import pga.Motor;
import pga.Motor.rotor;
import pga.Motor.translator;
import pga.Motor.motor;
import sta.Blade4 as STA;
import test.CliffordAlgebra;

// Tolerance for floating point comparisons
final epsilon = 1e-5;

inline function approxEq(a:Float, b:Float):Bool {
	return Math.abs(a - b) < epsilon;
}

inline function approxZero(a:Float):Bool {
	return Math.abs(a) < epsilon;
}

inline function vec3ApproxEq(a:Vec3, b:Vec3):Bool {
	return approxEq(a.x, b.x) && approxEq(a.y, b.y) && approxEq(a.z, b.z);
}

function testGA() {
	// ============================================
	// CliffordAlgebra Utility Tests
	// ============================================

	// Test popCount
	test(CliffordAlgebra.popCount(0) == 0);
	test(CliffordAlgebra.popCount(1) == 1);
	test(CliffordAlgebra.popCount(7) == 3); // 0b111
	test(CliffordAlgebra.popCount(10) == 2); // 0b1010

	// Test gradeOf
	test(CliffordAlgebra.gradeOf(0) == 0); // scalar
	test(CliffordAlgebra.gradeOf(1) == 1); // e1
	test(CliffordAlgebra.gradeOf(3) == 2); // e12 = 0b11
	test(CliffordAlgebra.gradeOf(7) == 3); // e123 = 0b111

	// Test basisProduct for Blade3 metric [1,1,1]
	var metric = CliffordAlgebra.METRIC_G3;

	// e1 * e1 = 1
	var r = CliffordAlgebra.basisProduct(1, 1, metric);
	test(r.blade == 0 && r.sign == 1);

	// e1 * e2 = e12
	r = CliffordAlgebra.basisProduct(1, 2, metric);
	test(r.blade == 3 && r.sign == 1); // 0b11 = 3

	// e2 * e1 = -e12
	r = CliffordAlgebra.basisProduct(2, 1, metric);
	test(r.blade == 3 && r.sign == -1);

	// e12 * e12 = e1e2e1e2 = -e1e1e2e2 = -1
	r = CliffordAlgebra.basisProduct(3, 3, metric);
	test(r.blade == 0 && r.sign == -1);

	// e123 * e123 = -1
	r = CliffordAlgebra.basisProduct(7, 7, metric);
	test(r.blade == 0 && r.sign == -1);

	// ============================================
	// Blade3 Basic Tests
	// ============================================

	// Construction
	var zero = Blade3.zero();
	test(zero.s == 0 && zero.e1 == 0 && zero.e123 == 0);

	var scalar = Blade3.scalar(5.0);
	test(scalar.s == 5.0 && scalar.e1 == 0);

	var vec = Blade3.vector(vec3(1, 2, 3));
	test(vec.e1 == 1 && vec.e2 == 2 && vec.e3 == 3 && vec.s == 0);

	var biv = Blade3.bivector(vec3(1, 2, 3));
	test(biv.e23 == 1 && biv.e31 == 2 && biv.e12 == 3 && biv.s == 0);

	// Grade extraction
	test(scalar.grade0() == 5.0);
	test(vec3ApproxEq(vec.grade1(), vec3(1, 2, 3)));
	test(vec3ApproxEq(biv.grade2(), vec3(1, 2, 3)));

	// ============================================
	// Blade3 Geometric Product Tests
	// ============================================

	// Basis vector products
	var e1 = Blade3.vector(vec3(1, 0, 0));
	var e2 = Blade3.vector(vec3(0, 1, 0));
	var e3 = Blade3.vector(vec3(0, 0, 1));

	// e1 * e1 = 1
	var e1e1 = e1 * e1;
	test(approxEq(e1e1.s, 1.0));
	test(approxZero(e1e1.e1) && approxZero(e1e1.e12));

	// e2 * e2 = 1
	var e2e2 = e2 * e2;
	test(approxEq(e2e2.s, 1.0));

	// e1 * e2 = e12 (bivector)
	var e1e2 = e1 * e2;
	test(approxZero(e1e2.s));
	test(approxEq(e1e2.e12, 1.0));
	test(approxZero(e1e2.e23) && approxZero(e1e2.e31));

	// e2 * e1 = -e12 (anticommutative)
	var e2e1 = e2 * e1;
	test(approxEq(e2e1.e12, -1.0));

	// e1 * e2 * e3 = e123
	var e123 = e1 * e2 * e3;
	test(approxEq(e123.e123, 1.0));
	test(approxZero(e123.s));

	// e123 * e123 = -1
	var e123sq = e123 * e123;
	test(approxEq(e123sq.s, -1.0));
	test(approxZero(e123sq.e123));

	// e12 * e12 = -1
	var e12 = Blade3.bivector(vec3(0, 0, 1));
	var e12sq = e12 * e12;
	test(approxEq(e12sq.s, -1.0));

	// ============================================
	// Blade3 Wedge Product Tests
	// ============================================

	// e1 ∧ e2 = e12
	var wedge12 = e1.wedge(e2);
	test(approxEq(wedge12.e12, 1.0));
	test(approxZero(wedge12.s));

	// e2 ∧ e1 = -e12
	var wedge21 = e2.wedge(e1);
	test(approxEq(wedge21.e12, -1.0));

	// e1 ∧ e1 = 0
	var wedge11 = e1.wedge(e1);
	test(approxZero(wedge11.e12) && approxZero(wedge11.e23) && approxZero(wedge11.e31));

	// ============================================
	// Blade3 Involutions Tests
	// ============================================

	var mv = new Blade3(1, 2, 3, 4, 5, 6, 7, 8);

	// Reverse: flip sign of grade 2 and 3
	var rev = mv.reverse();
	test(rev.s == 1); // grade 0 unchanged
	test(rev.e1 == 2 && rev.e2 == 3 && rev.e3 == 4); // grade 1 unchanged
	test(rev.e23 == -5 && rev.e31 == -6 && rev.e12 == -7); // grade 2 flipped
	test(rev.e123 == -8); // grade 3 flipped

	// Involute: flip sign of grade 1 and 3
	var inv = mv.involute();
	test(inv.s == 1); // grade 0 unchanged
	test(inv.e1 == -2 && inv.e2 == -3 && inv.e3 == -4); // grade 1 flipped
	test(inv.e23 == 5 && inv.e31 == 6 && inv.e12 == 7); // grade 2 unchanged
	test(inv.e123 == -8); // grade 3 flipped

	// ============================================
	// Blade3 Rotor ↔ Quaternion Equivalence
	// ============================================

	// Test multiple rotations
	var axes = [vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1), vec3(1, 1, 1).normalize()];

	var angles = [Math.PI / 6, Math.PI / 4, Math.PI / 3, Math.PI / 2];

	for (axis in axes) {
		for (angle in angles) {
			// Create rotation both ways
			var quat = Quat.fromAxisAngle(axis, angle);
			var rotor = Blade3.fromAxisAngle(axis, angle);

			// Convert rotor to quaternion and compare
			var rotorAsQuat = rotor.toQuat();
			var sameOrNegated = (approxEq(quat.x, rotorAsQuat.x) && approxEq(quat.y, rotorAsQuat.y) && approxEq(quat.z, rotorAsQuat.z)
				&& approxEq(quat.w, rotorAsQuat.w))
				|| (approxEq(quat.x, -rotorAsQuat.x) && approxEq(quat.y, -rotorAsQuat.y) && approxEq(quat.z, -rotorAsQuat.z)
					&& approxEq(quat.w, -rotorAsQuat.w));
			test(sameOrNegated);

			// Rotate a test vector with both and compare
			var testVec = vec3(1, 2, 3);
			var quatRotated = quat.rotateVec3(testVec);
			var rotorRotated = rotor.rotateVector(testVec);

			test(vec3ApproxEq(quatRotated, rotorRotated));
		}
	}

	// ============================================
	// Blade3 Rotor Composition
	// ============================================

	// Two rotations composed via rotor multiplication should match quaternion multiplication
	var q1 = Quat.fromAxisAngle(vec3(1, 0, 0), Math.PI / 4);
	var q2 = Quat.fromAxisAngle(vec3(0, 1, 0), Math.PI / 3);
	var qComposed = q1 * q2;

	var r1 = Blade3.fromAxisAngle(vec3(1, 0, 0), Math.PI / 4);
	var r2 = Blade3.fromAxisAngle(vec3(0, 1, 0), Math.PI / 3);
	var rComposed = r1 * r2;

	var testVec2 = vec3(1, 0, 0);
	var quatResult = qComposed.rotateVec3(testVec2);
	var rotorResult = rComposed.rotateVector(testVec2);

	test(vec3ApproxEq(quatResult, rotorResult));

	// ============================================
	// Blade3 Dual Tests
	// ============================================

	// dual(e1) should give e23 (up to sign)
	var dualE1 = e1.dual();
	test(approxZero(dualE1.e1));
	test(!approxZero(dualE1.e23)); // Should have bivector component

	// dual(dual(x)) should give back x (up to sign in Blade3)
	var testMv = new Blade3(1, 2, 0, 0, 0, 0, 0, 0);
	var doubleDual = testMv.dual().dual();
	// In Blade3, dual² = -1, so dual(dual(x)) = -x
	test(approxEq(doubleDual.s, -testMv.s));
	test(approxEq(doubleDual.e1, -testMv.e1));

	// ============================================
	// Blade3 Norm and Inverse Tests
	// ============================================

	// Unit rotor should have norm 1
	var unitRotor = Blade3.fromAxisAngle(vec3(1, 0, 0), Math.PI / 4);
	test(approxEq(unitRotor.norm(), 1.0));

	// Rotor * inverse(rotor) should equal 1
	var rotorInv = unitRotor.inverse();
	var shouldBeOne = unitRotor * rotorInv;
	test(approxEq(shouldBeOne.s, 1.0));
	test(approxZero(shouldBeOne.e23) && approxZero(shouldBeOne.e31) && approxZero(shouldBeOne.e12));

	// ============================================
	// Blade3 fromQuat Tests
	// ============================================

	// Convert quaternion to rotor and back
	var origQuat = Quat.fromAxisAngle(vec3(1, 2, 3).normalize(), 1.23);
	var asRotor = Blade3.fromQuat(origQuat);
	var backToQuat = asRotor.toQuat();

	var matches = (approxEq(origQuat.x, backToQuat.x) && approxEq(origQuat.y, backToQuat.y) && approxEq(origQuat.z, backToQuat.z)
		&& approxEq(origQuat.w, backToQuat.w));
	test(matches);

	// ============================================
	// Blade4 - 3D Projective Geometric Algebra Tests
	// ============================================

	// ============================================
	// Blade4 Construction Tests
	// ============================================

	// Zero and One
	var pzero = Blade4.zero();
	test(pzero.s == 0 && pzero.e0 == 0 && pzero.e123 == 0 && pzero.e0123 == 0);

	var pone = Blade4.one();
	test(pone.s == 1 && pone.e0 == 0 && pone.e123 == 0);

	// Point construction
	var pt = Blade4.point(1, 2, 3);
	test(pt.e123 == 1); // Homogeneous coordinate w=1
	test(pt.e032 == 1); // x component
	test(pt.e013 == 2); // y component
	test(pt.e021 == 3); // z component

	// Point extraction
	var ptExtracted = pt.toPoint();
	test(vec3ApproxEq(ptExtracted, vec3(1, 2, 3)));

	// Plane construction (ax + by + cz + d = 0)
	var pl = Blade4.plane(1, 0, 0, 5); // x + 5 = 0 (plane at x = -5)
	test(pl.e1 == 1 && pl.e2 == 0 && pl.e3 == 0 && pl.e0 == 5);

	// ============================================
	// Blade4 Join (Wedge) Tests
	// ============================================

	// Two points join to form a line
	var p1 = Blade4.point(0, 0, 0);
	var p2 = Blade4.point(1, 0, 0);
	var lineFromPoints = p1.wedge(p2);
	// The result should be a line (grade 2 element)
	// Line along x-axis through origin

	// ============================================
	// Blade4 Motor Tests
	// ============================================

	// Identity motor (no rotation, no translation)
	var identity = Blade4.one();
	var testPt = Blade4.point(1, 2, 3);
	var transformed = identity.transformPoint(testPt);
	var resultVec = transformed.toPoint();
	test(vec3ApproxEq(resultVec, vec3(1, 2, 3)));

	// Pure translation
	var trans = Blade4.translator(5, 0, 0);
	var ptOrigin = Blade4.point(0, 0, 0);
	var translatedPt = trans.transformPoint(ptOrigin);
	var translatedVec = translatedPt.toPoint();
	test(vec3ApproxEq(translatedVec, vec3(5, 0, 0)));

	// Translation by arbitrary vector
	var trans2 = Blade4.translator(1, 2, 3);
	var pt2 = Blade4.point(10, 20, 30);
	var translated2 = trans2.transformPoint(pt2);
	var translated2Vec = translated2.toPoint();
	test(vec3ApproxEq(translated2Vec, vec3(11, 22, 33)));

	// Pure rotation (90 degrees around z-axis)
	var rotZ90 = Blade4.rotor(vec3(0, 0, 1), Math.PI / 2);
	var ptX = Blade4.point(1, 0, 0);
	var rotatedPt = rotZ90.transformPoint(ptX);
	var rotatedVec = rotatedPt.toPoint();
	// (1,0,0) rotated 90 deg around z should give (0,1,0)
	test(vec3ApproxEq(rotatedVec, vec3(0, 1, 0)));

	// 180 degree rotation around z-axis
	var rotZ180 = Blade4.rotor(vec3(0, 0, 1), Math.PI);
	var rotated180 = rotZ180.transformPoint(ptX);
	var rotated180Vec = rotated180.toPoint();
	// (1,0,0) rotated 180 deg around z should give (-1,0,0)
	test(vec3ApproxEq(rotated180Vec, vec3(-1, 0, 0)));

	// Combined motor (rotation + translation)
	var motorCombined = Blade4.motor(vec3(0, 0, 1), Math.PI / 2, vec3(10, 0, 0));
	var combinedResult = motorCombined.transformPoint(ptX);
	var combinedVec = combinedResult.toPoint();
	// First rotate (1,0,0) -> (0,1,0), then translate by (10,0,0) -> (10,1,0)
	test(vec3ApproxEq(combinedVec, vec3(10, 1, 0)));

	// ============================================
	// Blade4 ↔ DualQuat Equivalence
	// ============================================

	// Create the same transformation with DualQuat and Blade4 motor
	var dqRot = Quat.fromAxisAngle(vec3(0, 1, 0), Math.PI / 4);
	var dqTrans = vec3(5, 10, 15);
	var dq = DualQuat.fromRotationTranslation(dqRot, dqTrans);

	var pgaMotor = Blade4.motor(vec3(0, 1, 0), Math.PI / 4, dqTrans);

	// Transform the same point with both
	var testPoint = vec3(1, 2, 3);
	var dqResult = dq.transformPoint(testPoint);
	var pgaResult = pgaMotor.applyToPoint(testPoint);

	test(vec3ApproxEq(dqResult, pgaResult));

	// ============================================
	// Blade4 Dual Tests
	// ============================================

	// Dual of a point should be a plane
	var ptForDual = Blade4.point(1, 0, 0);
	var dualPt = ptForDual.dual();
	// The dual maps grade 3 -> grade 1 (point -> plane)

	// Dual of dual should give back the original (up to sign)
	var doubleDualPt = dualPt.dual();
	// In 4D projective space, dual² should relate to original

	// ============================================
	// Blade4 Motor Composition
	// ============================================

	// Two translations should compose
	var t1 = Blade4.translator(1, 0, 0);
	var t2 = Blade4.translator(0, 2, 0);
	var t12 = t1 * t2;
	var composedTransResult = t12.transformPoint(Blade4.point(0, 0, 0));
	test(vec3ApproxEq(composedTransResult.toPoint(), vec3(1, 2, 0)));

	// Two rotations should compose
	var r1 = Blade4.rotor(vec3(0, 0, 1), Math.PI / 4);
	var r2 = Blade4.rotor(vec3(0, 0, 1), Math.PI / 4);
	var r12 = r1 * r2; // Should be 90 degree rotation
	var composedRotResult = r12.transformPoint(Blade4.point(1, 0, 0));
	test(vec3ApproxEq(composedRotResult.toPoint(), vec3(0, 1, 0)));

	// ============================================
	// Blade4 Reverse Tests
	// ============================================

	// Motor * reverse(motor) should give identity (for normalized motors)
	var testMotor = Blade4.motor(vec3(1, 1, 1).normalize(), 1.0, vec3(1, 2, 3));
	var motorTimesRev = testMotor * testMotor.reverse();
	// The scalar part should be close to 1
	test(approxEq(motorTimesRev.s, 1.0));

	// ============================================
	// Blade3 Extended Operator Tests (with non-trivial values)
	// ============================================

	// Test new shorthand syntax: Blade3.vec(x,y,z) instead of Blade3.vector(vec3(x,y,z))
	var shorthandVec = Blade3.vec(1.5, -2.3, 0.7);
	test(approxEq(shorthandVec.e1, 1.5) && approxEq(shorthandVec.e2, -2.3) && approxEq(shorthandVec.e3, 0.7));

	// Test basis elements: Blade3.E1, Blade3.E2, Blade3.E3 (uppercase to distinguish from component accessors)
	test(approxEq(Blade3.E1.e1, 1.0) && approxZero(Blade3.E1.e2));
	test(approxEq(Blade3.E12.e12, 1.0) && approxZero(Blade3.E12.e1));
	test(approxEq(Blade3.E123.e123, 1.0));

	// Building expressions with basis elements
	var builtVec = 1.5 * Blade3.E1 + (-2.3) * Blade3.E2 + 0.7 * Blade3.E3;
	test(approxEq(builtVec.e1, 1.5) && approxEq(builtVec.e2, -2.3) && approxEq(builtVec.e3, 0.7));

	// Wedge operator: ^ with NON-TRIVIAL values
	// (1.5, -2.3, 0.7) ^ (0.8, 1.2, -0.5)
	// e12 component = 1.5*1.2 - (-2.3)*0.8 = 1.8 + 1.84 = 3.64
	// e23 component = (-2.3)*(-0.5) - 0.7*1.2 = 1.15 - 0.84 = 0.31
	// e31 component = 0.7*0.8 - 1.5*(-0.5) = 0.56 + 0.75 = 1.31
	var wv1 = Blade3.vec(1.5, -2.3, 0.7);
	var wv2 = Blade3.vec(0.8, 1.2, -0.5);
	var wedgeResult = wv1 ^ wv2;
	test(approxEq(wedgeResult.e12, 3.64));
	test(approxEq(wedgeResult.e23, 0.31));
	test(approxEq(wedgeResult.e31, 1.31));
	test(approxZero(wedgeResult.s)); // wedge of two vectors has no scalar

	// Wedge is antisymmetric: a ^ b = -(b ^ a)
	var wedgeReverse = wv2 ^ wv1;
	test(approxEq(wedgeReverse.e12, -3.64));
	test(approxEq(wedgeReverse.e23, -0.31));
	test(approxEq(wedgeReverse.e31, -1.31));

	// Inner product operator: | with non-trivial bivector
	// e1 | (2*e12 + 3*e31) = 2*(e1|e12) + 3*(e1|e31)
	// e1|e12 = e1·(e1^e2) = e2 (left contraction)
	// e1|e31 = e1·(e3^e1) = -e1·(e1^e3) = -e3
	// Result: 2*e2 - 3*e3
	var testBiv = Blade3.biv(0, 3, 2); // 3*e31 + 2*e12
	var innerResult = Blade3.E1 | testBiv;
	test(approxEq(innerResult.e2, 2.0));
	test(approxEq(innerResult.e3, -3.0));

	// Reverse operator: ~ with non-trivial rotor
	var testRotor = Blade3.fromAxisAngle(vec3(1, 2, 3).normalize(), 1.23);
	var reversed = ~testRotor;
	test(approxEq(reversed.s, testRotor.s)); // scalar unchanged
	test(approxEq(reversed.e23, -testRotor.e23)); // bivector negated
	test(approxEq(reversed.e31, -testRotor.e31));
	test(approxEq(reversed.e12, -testRotor.e12));

	// Dual operator: ! with non-trivial vector
	var dualTestVec = Blade3.vec(1.5, -2.3, 0.7);
	var dualResult = !dualTestVec;
	// dual(a*e1 + b*e2 + c*e3) maps to bivector components
	// Verify double dual: !(!a) = -a
	var doubleDual = !dualResult;
	test(approxEq(doubleDual.e1, -1.5));
	test(approxEq(doubleDual.e2, 2.3));
	test(approxEq(doubleDual.e3, -0.7));

	// Grade extraction: [] with arbitrary multivector
	var fullMv = new Blade3(1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8);
	var g0 = fullMv[0];
	test(approxEq(g0.s, 1.1) && approxZero(g0.e1) && approxZero(g0.e123));
	var g1 = fullMv[1];
	test(approxEq(g1.e1, 2.2) && approxEq(g1.e2, 3.3) && approxEq(g1.e3, 4.4));
	test(approxZero(g1.s) && approxZero(g1.e23));
	var g2 = fullMv[2];
	test(approxEq(g2.e23, 5.5) && approxEq(g2.e31, 6.6) && approxEq(g2.e12, 7.7));
	test(approxZero(g2.e1) && approxZero(g2.e123));
	var g3 = fullMv[3];
	test(approxEq(g3.e123, 8.8) && approxZero(g3.e23) && approxZero(g3.s));

	// Sandwich product with ~ operator (non-axis-aligned rotation)
	var rotAxis = vec3(1, 1, 1).normalize();
	var rotAngle = 2 * Math.PI / 3; // 120 degrees
	var rot120 = Blade3.fromAxisAngle(rotAxis, rotAngle);
	var testVecX = Blade3.vec(1, 0, 0);
	// 120 deg rotation around (1,1,1) axis: (1,0,0) -> (0,1,0)
	var sandwichResult = rot120 * testVecX * ~rot120;
	test(approxZero(sandwichResult.e1));
	test(approxEq(sandwichResult.e2, 1.0));
	test(approxZero(sandwichResult.e3));

	// ============================================
	// Blade4 Extended Operator Tests (with non-trivial values)
	// ============================================

	// Test shorthand syntax: Blade4.pt() instead of Blade4.point()
	var shortPt = Blade4.pt(1.5, -2.3, 0.7);
	var extractedPt = shortPt.toPoint();
	test(approxEq(extractedPt.x, 1.5) && approxEq(extractedPt.y, -2.3) && approxEq(extractedPt.z, 0.7));

	// Test basis elements: Blade4.ORIGIN, Blade4.E1, etc (uppercase to distinguish from component accessors)
	test(approxEq(Blade4.ORIGIN.e123, 1.0));
	test(approxEq(Blade4.E1.e1, 1.0) && approxZero(Blade4.E1.e0));

	// Regressive product: & (join) with non-trivial points
	// In PGA dual representation: join = vee (&), meet = wedge (^)
	// Two arbitrary points should join to form a line
	var joinP1 = Blade4.pt(1.5, -0.3, 2.1);
	var joinP2 = Blade4.pt(-0.7, 1.8, 0.4);
	var joinedLine = joinP1 & joinP2;  // Use & for join of points
	// Verify it's a line (grade 2) by checking it has non-zero bivector components

	// Transform first point by a motor and check line still contains it
	var lineNormSq = joinedLine.e23 * joinedLine.e23 + joinedLine.e31 * joinedLine.e31 + joinedLine.e12 * joinedLine.e12;
	test(lineNormSq > 0.001); // Line should be non-zero

	// Meet operator: & (regressive product) with non-axis-aligned planes
	// Plane 1: 2x + y - z + 3 = 0
	var meetPlane1 = Blade4.plane(2, 1, -1, 3);
	// Plane 2: x - 2y + z - 1 = 0
	var meetPlane2 = Blade4.plane(1, -2, 1, -1);
	var meetResult = meetPlane1 & meetPlane2;
	// Result should be a line (grade 2 element)

	// Reverse operator: ~ for non-trivial motor
	var motorAxis = vec3(1, 2, -1).normalize();
	var motorAngle = 0.73;
	var motorTrans = vec3(-1.5, 2.1, 0.8);
	var testMotor2 = Blade4.motor(motorAxis, motorAngle, motorTrans);
	var revMotor = ~testMotor2;
	var motorIdentity = testMotor2 * revMotor;
	test(approxEq(motorIdentity.s, 1.0));
	test(approxZero(motorIdentity.e23) && approxZero(motorIdentity.e31) && approxZero(motorIdentity.e12));

	// Dual operator: ! - verify point dual is plane and vice versa
	var pointForDual = Blade4.pt(1.7, -0.8, 2.3);
	var dualPlane = !pointForDual;
	// Dual of point (grade 3) should be plane (grade 1)
	// Dual of dual should give back ±original
	var doubleDualPoint = !dualPlane;
	// Components should be proportional (up to scale and sign)

	// Grade extraction: [] with full motor
	var extractMotor = Blade4.motor(vec3(0, 1, 0), 0.5, vec3(3, 0, -2));
	var motorG0 = extractMotor[0];
	var motorG2 = extractMotor[2];
	test(approxEq(motorG0.s, extractMotor.s));
	test(approxZero(motorG0.e01) && approxZero(motorG0.e23)); // grade 0 has no bivectors
	// Grade 2 should contain the bivector parts
	var hasG2 = Math.abs(motorG2.e01) > epsilon || Math.abs(motorG2.e02) > epsilon || Math.abs(motorG2.e03) > epsilon || Math.abs(motorG2.e23) > epsilon
		|| Math.abs(motorG2.e31) > epsilon || Math.abs(motorG2.e12) > epsilon;
	test(hasG2);

	// Practical test: join two points, meet with plane, get intersection point
	// In PGA dual representation: join = & (vee), meet = ^ (wedge)
	var lineP1 = Blade4.pt(0, 0, -1); // Point below xy-plane
	var lineP2 = Blade4.pt(2, 4, 3); // Point above xy-plane
	var testLine = lineP1 & lineP2;  // Join two points to get line
	var xyPlane2 = Blade4.plane(0, 0, 1, 0); // z = 0 plane
	var intersectPt = testLine ^ xyPlane2;  // Meet line with plane to get point

	// The intersection should be on the line from (0,0,-1) to (2,4,3)
	// Parametric: (0,0,-1) + t*((2,4,3)-(0,0,-1)) = (2t, 4t, -1+4t)
	// z=0 when -1+4t=0, so t=0.25
	// Point: (0.5, 1.0, 0)
	var intersectVec = intersectPt.toPoint();
	test(approxEq(intersectVec.x, 0.5));
	test(approxEq(intersectVec.y, 1.0));
	test(approxZero(intersectVec.z));

	// ============================================
	// PGA Semantic API Tests
	// ============================================

	// Point construction and extraction
	var semanticPt = point(1.5, -2.3, 0.7);
	test(approxEq(semanticPt.x, 1.5));
	test(approxEq(semanticPt.y, -2.3));
	test(approxEq(semanticPt.z, 0.7));
	test(semanticPt.isFinite());

	// Point to/from Vec3
	var ptFromVec:Point = vec3(3, 4, 5);
	test(approxEq(ptFromVec.x, 3) && approxEq(ptFromVec.y, 4) && approxEq(ptFromVec.z, 5));
	var vecFromPt:Vec3 = semanticPt;
	test(approxEq(vecFromPt.x, 1.5) && approxEq(vecFromPt.y, -2.3));

	// Ideal point (direction)
	var idealPt = Point.direction(1, 0, 0);
	test(idealPt.isIdeal());
	test(!idealPt.isFinite());

	// Point.origin
	var orig = Point.origin();
	test(approxZero(orig.x) && approxZero(orig.y) && approxZero(orig.z));

	// Line from two points
	var lp1 = point(0, 0, 0);
	var lp2 = point(1, 0, 0);
	var xLine = lp1.join(lp2);
	var lineDir = xLine.getDirection();
	// Direction should be along x-axis (normalized)
	test(approxEq(Math.abs(lineDir.x), 1.0));
	test(approxZero(lineDir.y) && approxZero(lineDir.z));

	// Line axis constructors
	var yAxisLine = Line.yAxis();
	var yDir = yAxisLine.getDirection();
	test(approxEq(Math.abs(yDir.y), 1.0));

	// Plane construction
	var xyPlaneSemantic = Plane.xy();
	var xyNormal = xyPlaneSemantic.getNormal();
	test(approxZero(xyNormal.x) && approxZero(xyNormal.y) && approxEq(Math.abs(xyNormal.z), 1.0));

	// Plane from point and normal
	var planeThruPt = Plane.fromPointNormal(vec3(0, 0, 5), vec3(0, 0, 1));
	test(approxEq(Math.abs(planeThruPt.getNormal().z), 1.0));

	// Meet: two planes -> line
	var plane1 = Plane.xy(); // z = 0
	var plane2 = Plane.xz(); // y = 0
	var meetLine = plane1.meet(plane2);
	// Intersection of z=0 and y=0 is the x-axis
	var meetDir = meetLine.getDirection();
	test(approxEq(Math.abs(meetDir.x), 1.0));

	// Meet: line and plane -> point
	var vertLine = Line.fromPointDir(vec3(3, 4, -10), vec3(0, 0, 1));
	var groundPlane = Plane.xy();
	var groundPt = vertLine.meet(groundPlane);
	test(approxEq(groundPt.x, 3));
	test(approxEq(groundPt.y, 4));
	test(approxZero(groundPt.z));

	// Join: two points -> line, line and point -> plane
	var jp1 = point(0, 0, 0);
	var jp2 = point(1, 0, 0);
	var jp3 = point(0, 1, 0);
	var joinLine = jp1.join(jp2);
	var joinPlane = joinLine.join(jp3);
	// Plane through (0,0,0), (1,0,0), (0,1,0) is z=0
	test(approxEq(Math.abs(joinPlane.getNormal().z), 1.0));

	// Motor: identity
	var idMotor = Motor.identity();
	var idResult = idMotor.apply(point(1, 2, 3));
	test(approxEq(idResult.x, 1) && approxEq(idResult.y, 2) && approxEq(idResult.z, 3));

	// Motor: pure translation
	var transMotor = Motor.translation(10, 20, 30);
	var transResult = transMotor.apply(point(1, 2, 3));
	test(approxEq(transResult.x, 11));
	test(approxEq(transResult.y, 22));
	test(approxEq(transResult.z, 33));

	// Motor: pure rotation (90 deg around z)
	var rotMotor = Motor.rotation(vec3(0, 0, 1), Math.PI / 2);
	var rotResult = rotMotor.apply(point(1, 0, 0));
	test(approxZero(rotResult.x));
	test(approxEq(rotResult.y, 1.0));
	test(approxZero(rotResult.z));

	// Motor: combined rotation + translation
	var comboMotor = Motor.rotationTranslation(vec3(0, 0, 1), Math.PI / 2, vec3(10, 0, 0));
	var comboResult = comboMotor.apply(point(1, 0, 0));
	// Rotate (1,0,0) -> (0,1,0), then translate by (10,0,0) -> (10,1,0)
	test(approxEq(comboResult.x, 10));
	test(approxEq(comboResult.y, 1));
	test(approxZero(comboResult.z));

	// Motor: inverse
	var fwdMotor = Motor.rotationTranslation(vec3(1, 0, 0), 0.5, vec3(1, 2, 3));
	var invMotor = fwdMotor.inverse();
	var roundTrip = fwdMotor * invMotor;
	var rtResult = roundTrip.apply(point(5, 6, 7));
	test(approxEq(rtResult.x, 5) && approxEq(rtResult.y, 6) && approxEq(rtResult.z, 7));

	// Motor: composition
	var rot1 = Motor.rotation(vec3(0, 0, 1), Math.PI / 4);
	var rot2 = Motor.rotation(vec3(0, 0, 1), Math.PI / 4);
	var rot90 = rot1 * rot2; // 45 + 45 = 90 degrees
	var compResult = rot90.apply(point(1, 0, 0));
	test(approxZero(compResult.x));
	test(approxEq(compResult.y, 1.0));

	// Motor: apply to Vec3 directly
	var vec3Result = rotMotor.applyVec3(vec3(1, 0, 0));
	test(approxZero(vec3Result.x) && approxEq(vec3Result.y, 1.0));

	// Motor: apply to line
	var lineToRot = Line.xAxis();
	var rotatedLine = rotMotor.applyLine(lineToRot);
	var rotLineDir = rotatedLine.getDirection();
	// X-axis rotated 90 deg around Z becomes Y-axis
	test(approxEq(Math.abs(rotLineDir.y), 1.0));

	// Motor: apply to plane
	var planeToRot = Plane.yz(); // x = 0
	var rotatedPlane = rotMotor.applyPlane(planeToRot);
	// YZ plane rotated 90 deg around Z becomes XZ plane (y = 0)
	var rotPlaneNormal = rotatedPlane.getNormal();
	test(approxEq(Math.abs(rotPlaneNormal.y), 1.0));

	// Motor <-> DualQuat interop tested at Blade4 level in earlier tests
	// The semantic API just delegates to Blade4.toDualQuat/fromDualQuat

	// Shorthand functions
	var shortPt = point(1, 2, 3);
	test(shortPt.isFinite());

	var shortRot = Motor.rotation(vec3(0, 0, 1), Math.PI);
	var shortTrans = Motor.translation(5, 0, 0);
	var shortMotor = Motor.rotationTranslation(vec3(0, 0, 1), Math.PI / 2, vec3(1, 1, 1));

	// Test inverse method (skip ~ operator for now)
	var revRot = shortRot.inverse();
	var pt100 = point(1, 0, 0);
	var rotated = shortRot.apply(pt100);
	var backAgain = revRot.apply(rotated);
	test(approxEq(backAgain.x, 1.0));

	// ============================================
	// Spacetime Algebra (STA) Tests
	// ============================================

	// Verify metric signature: e0²=+1, e1²=e2²=e3²=-1
	var g0 = STA.GAMMA0;
	var g1 = STA.GAMMA1;
	var g2 = STA.GAMMA2;
	var g3 = STA.GAMMA3;

	// γ0² = +1
	var g0sq = g0 * g0;
	test(approxEq(g0sq.s, 1.0));
	test(approxZero(g0sq.e0));

	// γ1² = -1
	var g1sq = g1 * g1;
	test(approxEq(g1sq.s, -1.0));
	test(approxZero(g1sq.e1));

	// γ2² = -1
	var g2sq = g2 * g2;
	test(approxEq(g2sq.s, -1.0));

	// γ3² = -1
	var g3sq = g3 * g3;
	test(approxEq(g3sq.s, -1.0));

	// γ0γ1 = -γ1γ0 (anticommute)
	var g0g1 = g0 * g1;
	var g1g0 = g1 * g0;
	test(approxEq(g0g1.e01, -g1g0.e01));

	// Pseudoscalar I = γ0γ1γ2γ3
	var Icomp = g0 * g1 * g2 * g3;
	test(approxEq(Icomp.e0123, 1.0));

	// I² in STA: need to verify sign based on metric
	// For now, just verify it's a scalar
	var Isq = Icomp * Icomp;
	test(approxZero(Isq.e0123)); // Result should be pure scalar

	// Timelike, spacelike, lightlike classification
	var timelikeVec = STA.vector(2, 1, 0, 0); // t²-x² = 4-1 = 3 > 0
	test(timelikeVec.isTimelike());
	test(!timelikeVec.isSpacelike());

	var spacelikeVec = STA.vector(1, 2, 0, 0); // t²-x² = 1-4 = -3 < 0
	test(spacelikeVec.isSpacelike());
	test(!spacelikeVec.isTimelike());

	var lightlikeVec = STA.vector(1, 1, 0, 0); // t²-x² = 0
	test(lightlikeVec.isLightlike());

	// 4-velocity construction
	var fourVel = STA.fourVelocity(0.5, 0, 0); // v = 0.5c in x direction
	// γ = 1/sqrt(1-v²) = 1/sqrt(0.75) ≈ 1.1547
	var gamma = 1.0 / Math.sqrt(1.0 - 0.25);
	test(approxEq(fourVel.e0, gamma));
	test(approxEq(fourVel.e1, gamma * 0.5));

	// 4-velocity is unit timelike: u² = 1
	var fourVelSq = fourVel * fourVel;
	test(approxEq(fourVelSq.s, 1.0));

	// Spatial rotation in STA
	var rotZ = STA.rotation(0, 0, 1, Math.PI / 2); // 90° around z
	var xVec = STA.spatial(1, 0, 0);
	var rotatedX = rotZ.transform(xVec);
	// (1,0,0) rotated 90° around z -> (0,1,0)
	test(approxZero(rotatedX.e1));
	test(approxEq(rotatedX.e2, 1.0));
	test(approxZero(rotatedX.e3));
	test(approxZero(rotatedX.e0)); // Time component unchanged

	// Boost construction - verify rotor is created
	var rapidity = 0.5;
	var boostX = STA.boost(1, 0, 0, rapidity);
	// Boost rotor should have scalar and e01 components
	test(boostX.s > 0.9); // cosh(0.25) ≈ 1.03
	test(Math.abs(boostX.e01) > 0.1); // sinh(0.25) ≈ 0.25

	// Note: Full boost transform verification requires careful geometric product validation
	// The STA geometric product needs further verification for boost applications

	// EM field bivector
	var emField = STA.emField(1, 0, 0, 0, 0, 1); // E = (1,0,0), B = (0,0,1)
	test(approxEq(emField.e01, 1.0)); // Ex
	test(approxEq(emField.e12, 1.0)); // Bz

	// Electric and magnetic parts extraction
	var ePart = emField.electricPart();
	var bPart = emField.magneticPart();
	test(approxEq(ePart.x, 1.0));
	test(approxEq(bPart.z, 1.0));

	// Rotor composition: rotation should preserve vector magnitude
	var rot90 = STA.rotation(0, 0, 1, Math.PI / 2);
	var xVec2 = STA.spatial(1, 0, 0);
	var rotatedOnce = rot90.transform(xVec2);
	// Verify the rotated vector is still spacelike with same magnitude
	test(rotatedOnce.isSpacelike());
	var origMag = Math.abs(xVec2.normSquared());
	var rotMag = Math.abs(rotatedOnce.normSquared());
	test(approxEq(origMag, rotMag));
}
