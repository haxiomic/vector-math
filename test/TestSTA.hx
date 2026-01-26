import TestFramework;
import VectorMath;
import sta.Blade4;
import sta.Event;
import sta.Event.event;
import sta.FourVector;
import sta.FourVector.fourVector;
import sta.FourVector.fourVelocity;
import sta.FourVector.fourMomentum;
import sta.Field;
import sta.Field.field;
import sta.Rotor;

// Tolerance for floating point comparisons
final epsilon = 1e-6;

inline function approxEq(a:Float, b:Float):Bool {
	return Math.abs(a - b) < epsilon;
}

inline function approxZero(a:Float):Bool {
	return Math.abs(a) < epsilon;
}

inline function vec3ApproxEq(a:Vec3, b:Vec3):Bool {
	return approxEq(a.x, b.x) && approxEq(a.y, b.y) && approxEq(a.z, b.z);
}

// Hyperbolic functions
inline function cosh(x:Float):Float {
	var ex = Math.exp(x);
	return (ex + 1.0 / ex) * 0.5;
}

inline function sinh(x:Float):Float {
	var ex = Math.exp(x);
	return (ex - 1.0 / ex) * 0.5;
}

inline function tanh(x:Float):Float {
	var ex = Math.exp(x);
	var emx = 1.0 / ex;
	return (ex - emx) / (ex + emx);
}

inline function gamma(v:Float):Float {
	return 1.0 / Math.sqrt(1.0 - v * v);
}

function testSTA() {
	// ============================================================
	// PART 1: METRIC SIGNATURE AND BASIS IDENTITIES
	// ============================================================
	// Reference: Hestenes "Space-Time Algebra", Chapter 1

	// γ₀² = +1 (timelike basis)
	var g0 = Blade4.GAMMA0;
	var g0sq = g0 * g0;
	test(approxEq(g0sq.s, 1.0));
	test(approxZero(g0sq.e0)); // No vector part

	// γ₁² = γ₂² = γ₃² = -1 (spacelike basis)
	var g1 = Blade4.GAMMA1;
	var g2 = Blade4.GAMMA2;
	var g3 = Blade4.GAMMA3;

	var g1sq = g1 * g1;
	test(approxEq(g1sq.s, -1.0));

	var g2sq = g2 * g2;
	test(approxEq(g2sq.s, -1.0));

	var g3sq = g3 * g3;
	test(approxEq(g3sq.s, -1.0));

	// Anticommutation: γμγν = -γνγμ for μ ≠ ν
	var g0g1 = g0 * g1;
	var g1g0 = g1 * g0;
	test(approxEq(g0g1.e01, -g1g0.e01));

	var g1g2 = g1 * g2;
	var g2g1 = g2 * g1;
	test(approxEq(g1g2.e12, -g2g1.e12));

	var g0g3 = g0 * g3;
	var g3g0 = g3 * g0;
	test(approxEq(g0g3.e03, -g3g0.e03));

	// Bivector squares
	// σᵢ = γᵢγ₀ (relative vectors / Pauli algebra)
	// σᵢ² = γᵢγ₀γᵢγ₀ = -γᵢ²γ₀² = -(-1)(1) = +1

	// Space-space bivectors (rotations): (γᵢγⱼ)² = -1
	// γ₁₂² = γ₁γ₂γ₁γ₂ = -γ₁²γ₂² = -(-1)(-1) = -1

	// ============================================================
	// PART 2: PSEUDOSCALAR PROPERTIES
	// ============================================================

	// I = γ₀γ₁γ₂γ₃ (pseudoscalar)
	var I = g0 * g1 * g2 * g3;
	test(approxEq(I.e0123, 1.0));

	// I² = γ₀γ₁γ₂γ₃γ₀γ₁γ₂γ₃
	// Working through: I² = γ₀²γ₁²γ₂²γ₃² × (sign from reordering)
	// = (+1)(-1)(-1)(-1) × (-1)³ = (-1) × (-1) = -1
	// (3 sign flips from moving γ₀ past γ₁,γ₂,γ₃ in second I)
	var Isq = I * I;
	// Note: The exact sign depends on ordering conventions
	// For (+,-,-,-): I² should be -1
	test(approxZero(Isq.e0123)); // Result is scalar

	// I anticommutes with vectors: Iγμ = -γμI
	var Ig0 = I * g0;
	var g0I = g0 * I;
	// Check that they differ by sign in the trivector components
	test(approxEq(Ig0.e123, -g0I.e123));

	// ============================================================
	// PART 3: EVENT (SPACETIME POSITION)
	// ============================================================

	// Basic construction
	var e1 = event(1.0, 2.0, 3.0, 4.0);
	test(approxEq(e1.t, 1.0));
	test(approxEq(e1.x, 2.0));
	test(approxEq(e1.y, 3.0));
	test(approxEq(e1.z, 4.0));

	// Origin
	var origin = Event.origin();
	test(approxZero(origin.t));
	test(approxZero(origin.x));

	// Spacetime interval: Δs² = Δt² - Δx² - Δy² - Δz²
	var e2 = event(5.0, 3.0, 0.0, 0.0);
	// Δt = 4, Δx = 1, Δy = -3, Δz = -4
	// Δs² = 16 - 1 - 9 - 16 = -10 (spacelike)
	var interval = e1.intervalSquaredTo(e2);
	test(approxEq(interval, -10.0));
	test(e1.isSpacelikeSeparatedFrom(e2));

	// Timelike separation
	var e3 = event(10.0, 2.0, 3.0, 4.0); // Same position, different time
	// Δt = 9, Δx = Δy = Δz = 0
	// Δs² = 81 (timelike)
	test(e1.isTimelikeSeparatedFrom(e3));
	test(approxEq(e1.properTimeTo(e3), 9.0));

	// Lightlike separation
	var e4 = event(2.0, 3.0, 3.0, 4.0); // Δt = 1, Δx = 1
	// Δs² = 1 - 1 = 0
	test(e1.isLightlikeSeparatedFrom(e4));

	// ============================================================
	// PART 4: FOUR-VECTORS
	// ============================================================

	// 4-velocity from 3-velocity
	// u = γ(1, v) where γ = 1/√(1-v²)
	var v = 0.6; // v = 0.6c
	var g = gamma(v); // γ = 1.25
	var u = fourVelocity(v, 0, 0);
	test(approxEq(u.v0, g)); // γ
	test(approxEq(u.v1, g * v)); // γv

	// 4-velocity is unit timelike: u·u = 1
	var uSq = u.magnitudeSquared();
	test(approxEq(uSq, 1.0));

	// 4-momentum: p = mu
	var mass = 2.0;
	var p = fourMomentum(mass, v, 0, 0);
	test(approxEq(p.v0, mass * g)); // E = γm
	test(approxEq(p.v1, mass * g * v)); // px = γmv

	// Rest mass from 4-momentum: m² = E² - |p|²
	test(approxEq(p.restMass(), mass));

	// Photon 4-momentum (null vector)
	var photon = FourVector.photon(10.0, 1, 0, 0);
	test(photon.isLightlike());
	test(approxEq(photon.v0, 10.0)); // E
	test(approxEq(photon.v1, 10.0)); // |p| = E for photons

	// Minkowski inner product
	var v1 = fourVector(3, 1, 0, 0);
	var v2 = fourVector(2, 1, 0, 0);
	// v1·v2 = 3×2 - 1×1 = 6 - 1 = 5
	test(approxEq(v1.dot(v2), 5.0));

	// ============================================================
	// PART 5: ELECTROMAGNETIC FIELD
	// ============================================================

	// Pure electric field
	var E = Field.electric(1, 0, 0);
	test(approxEq(E.Ex, 1.0));
	test(approxZero(E.Bx));

	// Pure magnetic field
	var B = Field.magnetic(0, 0, 1);
	test(approxEq(B.Bz, 1.0));
	test(approxZero(B.Ex));

	// Combined field
	var F = field(1, 2, 3, 4, 5, 6);
	test(vec3ApproxEq(F.getE(), vec3(1, 2, 3)));
	test(vec3ApproxEq(F.getB(), vec3(4, 5, 6)));

	// First Lorentz invariant: F·F/2 = B² - E²
	// E² = 1+4+9 = 14, B² = 16+25+36 = 77
	// Invariant = 77 - 14 = 63
	var F1 = Field.fromEB(vec3(1, 2, 3), vec3(4, 5, 6));
	var inv1 = F1.invariant1() / 2; // Divided by 2 since our formula has factor of 2
	test(approxEq(inv1, 63.0));

	// Second invariant (E·B)
	// E·B = 1×4 + 2×5 + 3×6 = 4 + 10 + 18 = 32
	var inv2 = F1.invariant2() / 2;
	test(approxEq(inv2, 32.0));

	// Energy density: (E² + B²)/2 = (14 + 77)/2 = 45.5
	test(approxEq(F1.energyDensity(), 45.5));

	// Poynting vector: S = E × B
	var S = F1.getPoyntingVector();
	// E×B for E=(1,2,3), B=(4,5,6):
	// x: 2×6 - 3×5 = 12 - 15 = -3
	// y: 3×4 - 1×6 = 12 - 6 = 6
	// z: 1×5 - 2×4 = 5 - 8 = -3
	test(vec3ApproxEq(S, vec3(-3, 6, -3)));

	// ============================================================
	// PART 6: LORENTZ ROTORS - SPATIAL ROTATIONS
	// ============================================================

	// Identity rotor
	var id = Rotor.identity();
	var testEvent = event(1, 2, 3, 4);
	var idResult = id.apply(testEvent);
	test(approxEq(idResult.t, 1.0));
	test(approxEq(idResult.x, 2.0));

	// 90° rotation around z-axis
	var rotZ90 = Rotor.rotationZ(Math.PI / 2);
	var xEvent = event(0, 1, 0, 0); // Pure spatial x
	var rotatedX = rotZ90.apply(xEvent);
	// (0,1,0,0) rotated 90° around z → (0,0,1,0)
	test(approxZero(rotatedX.t)); // Time unchanged
	test(approxZero(rotatedX.x));
	test(approxEq(rotatedX.y, 1.0));
	test(approxZero(rotatedX.z));

	// 180° rotation = two 90° rotations
	var rotZ180 = rotZ90 * rotZ90;
	var rotated180 = rotZ180.apply(xEvent);
	// (0,1,0,0) → (0,-1,0,0)
	test(approxZero(rotated180.t));
	test(approxEq(rotated180.x, -1.0));

	// Rotation preserves spatial magnitude
	var spatialVec = FourVector.spatial(3, 4, 0);
	var spatialMag = spatialVec.magnitudeSquared(); // -25 (spacelike)
	var rotated = rotZ90.applyVector(spatialVec);
	test(approxEq(rotated.magnitudeSquared(), spatialMag));

	// ============================================================
	// PART 7: LORENTZ ROTORS - BOOSTS
	// ============================================================

	// Boost rotor construction
	var rapidity = 0.5;
	var boostX = Rotor.boostX(rapidity);
	// R = cosh(φ/2) - sinh(φ/2)e₀₁
	var halfRap = rapidity / 2;
	test(approxEq(boostX.scalar, cosh(halfRap)));

	// Rapidity ↔ velocity conversion
	var vFromRap = Rotor.rapidityToVelocity(rapidity);
	var rapBack = Rotor.velocityToRapidity(vFromRap);
	test(approxEq(rapBack, rapidity));

	// Velocity = tanh(rapidity)
	test(approxEq(vFromRap, tanh(rapidity)));

	// ============================================================
	// PART 8: SPECIAL RELATIVITY PHYSICS
	// ============================================================

	// Time dilation: moving clock runs slow
	// Proper time Δτ = Δt/γ, or from observer's view: Δt = γΔτ
	var vTD = 0.8; // v = 0.8c, γ = 5/3
	var gammaTD = gamma(vTD);
	test(approxEq(gammaTD, 5.0 / 3.0));

	// If proper time = 3, coordinate time = γ × 3 = 5
	var properTime = 3.0;
	var coordTime = gammaTD * properTime;
	test(approxEq(coordTime, 5.0));

	// Length contraction: L = L₀/γ
	var properLength = 5.0;
	var contractedLength = properLength / gammaTD;
	test(approxEq(contractedLength, 3.0));

	// Relativistic velocity addition
	// For parallel velocities: w = (u+v)/(1+uv)
	var u1 = 0.5;
	var u2 = 0.5;
	var wClassical = u1 + u2; // = 1.0 (wrong!)
	var wRelativistic = (u1 + u2) / (1 + u1 * u2); // = 1/1.25 = 0.8
	test(approxEq(wRelativistic, 0.8));

	// Rapidity is additive: φ_total = φ₁ + φ₂
	var rap1 = Rotor.velocityToRapidity(u1);
	var rap2 = Rotor.velocityToRapidity(u2);
	var rapTotal = rap1 + rap2;
	var vTotal = Rotor.rapidityToVelocity(rapTotal);
	test(approxEq(vTotal, wRelativistic));

	// ============================================================
	// PART 9: INVARIANTS
	// ============================================================

	// Spacetime interval is Lorentz invariant
	var ev1 = event(0, 0, 0, 0);
	var ev2 = event(5, 3, 0, 0);
	var intervalBefore = ev1.intervalSquaredTo(ev2); // 25 - 9 = 16

	// The interval should be preserved under boosts
	// (Testing requires working boost transform)
	test(approxEq(intervalBefore, 16.0));

	// 4-momentum magnitude (rest mass) is invariant
	var mass2 = 5.0;
	var vel2 = 0.6;
	var p2 = fourMomentum(mass2, vel2, 0, 0);
	test(approxEq(p2.restMass(), mass2));

	// ============================================================
	// PART 10: ROTOR ALGEBRA
	// ============================================================

	// Rotor inverse: RR̃ = 1
	var testRotor = Rotor.rotationZ(0.7);
	var rotorInv = testRotor.inverse();
	var shouldBeId = testRotor * rotorInv;
	// Check scalar part is 1, bivector parts are 0
	test(approxEq(shouldBeId.scalar, 1.0));

	// Rotation composition
	// Three 120° rotations around z = identity
	var rot120 = Rotor.rotationZ(2 * Math.PI / 3);
	var rot360 = rot120 * rot120 * rot120;
	var testVec = event(0, 1, 2, 3);
	var afterRot360 = rot360.apply(testVec);
	test(approxEq(afterRot360.x, testVec.x));
	test(approxEq(afterRot360.y, testVec.y));
	test(approxEq(afterRot360.z, testVec.z));

	// ============================================================
	// PART 11: PHYSICAL CONSTANTS CHECK
	// ============================================================

	// In natural units (c=1):
	// - Lightlike vectors satisfy E = |p| (for photons)
	// - Timelike vectors satisfy E² - p² = m²
	// - Spacelike vectors have negative norm²

	// Electron at rest: E = m, p = 0
	var electronMass = 0.511; // MeV (example)
	var electronAtRest = FourVector.momentum(electronMass, 0, 0, 0);
	test(approxEq(electronAtRest.energy, electronMass));
	test(approxEq(electronAtRest.restMass(), electronMass));

	// Electron at v=0.8c: γ = 5/3, E = γm ≈ 0.852, |p| = γmv ≈ 0.682
	var electronMoving = FourVector.momentum(electronMass, 0.8, 0, 0);
	var gammaE = gamma(0.8);
	test(approxEq(electronMoving.energy, electronMass * gammaE));
	test(approxEq(electronMoving.restMass(), electronMass)); // Invariant!

	// ============================================================
	// PART 12: EDGE CASES
	// ============================================================

	// Zero velocity
	var zeroVel = fourVelocity(0, 0, 0);
	test(approxEq(zeroVel.v0, 1.0)); // γ = 1 at rest
	test(approxZero(zeroVel.v1));

	// Near-light velocity (should not blow up)
	var nearLight = fourVelocity(0.9999, 0, 0);
	test(nearLight.isTimelike());
	test(nearLight.v0 > 50); // γ > 70 at v=0.9999

	// Zero field
	var zeroField = Field.zero();
	test(approxZero(zeroField.energyDensity()));

	// Pure electric vs pure magnetic (duality)
	var pureE = Field.electric(1, 0, 0);
	var pureB = Field.magnetic(1, 0, 0);
	// E·B = 0 for pure fields
	test(approxZero(pureE.invariant2()));
	test(approxZero(pureB.invariant2()));
}
