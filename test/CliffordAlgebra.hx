package test;

/**
 * Clifford Algebra Utilities
 *
 * Shared utilities for Geometric/Clifford Algebras of various signatures.
 *
 * Metric signature G(p, q, r):
 *   p = number of basis vectors that square to +1
 *   q = number of basis vectors that square to -1
 *   r = number of basis vectors that square to 0 (degenerate)
 *
 * Common algebras:
 *   G(2,0,0) = Complex numbers (as even subalgebra)
 *   G(3,0,0) = 3D Euclidean (G3) - contains quaternions as even subalgebra
 *   G(3,0,1) = 3D Projective (PGA3) - points, lines, planes
 *   G(1,3,0) = Spacetime Algebra (STA) - special relativity
 *   G(4,1,0) = Conformal GA (CGA) - circles, spheres
 */
class CliffordAlgebra {

	/**
	 * Compute the sign and resulting blade from multiplying two basis blades.
	 *
	 * Each blade is represented as a bitmask where bit i indicates presence of basis vector e_i.
	 * For example, in 3D: e1=0b001, e2=0b010, e3=0b100, e12=0b011, e123=0b111
	 *
	 * @param a First blade bitmask
	 * @param b Second blade bitmask
	 * @param metric Array of signs: +1 (positive), -1 (negative), 0 (degenerate)
	 * @return {blade: resulting blade bitmask, sign: +1, -1, or 0}
	 */
	public static function basisProduct(a:Int, b:Int, metric:Array<Int>):{blade:Int, sign:Int} {
		var result = a ^ b; // XOR gives the resulting blade
		var sign = 1;

		// Count swaps needed to bring matching basis vectors together
		// For each bit in b, count how many bits in a are to the right of it
		var bTemp = b;
		var i = 0;
		while (bTemp != 0) {
			if ((bTemp & 1) == 1) {
				// Count bits in a that are above position i
				var aAbove = a >> (i + 1);
				var swaps = popCount(aAbove);

				// Each swap introduces a sign flip
				if (swaps % 2 == 1) {
					sign = -sign;
				}

				// If this basis vector is also in a, they annihilate with metric sign
				if ((a & (1 << i)) != 0) {
					sign *= metric[i];
					if (sign == 0)
						return {blade: 0, sign: 0};
				}
			}
			bTemp >>= 1;
			i++;
		}

		return {blade: result, sign: sign};
	}

	/**
	 * Count the number of 1 bits in an integer (population count).
	 */
	public static inline function popCount(x:Int):Int {
		var count = 0;
		while (x != 0) {
			count += x & 1;
			x >>= 1;
		}
		return count;
	}

	/**
	 * Get the grade (number of basis vectors) of a blade.
	 */
	public static inline function gradeOf(blade:Int):Int {
		return popCount(blade);
	}

	/**
	 * Generate blade name from bitmask.
	 * @param blade Blade bitmask
	 * @param basisNames Names for each basis vector, e.g. ["0", "1", "2", "3"] or ["t", "x", "y", "z"]
	 * @param prefix Prefix for compound names, e.g. "e" gives "e12"
	 */
	public static function bladeName(blade:Int, basisNames:Array<String>, prefix:String = "e"):String {
		if (blade == 0)
			return "1";

		var name = prefix;
		for (i in 0...basisNames.length) {
			if ((blade & (1 << i)) != 0) {
				name += basisNames[i];
			}
		}
		return name;
	}

	/**
	 * Generate the full Cayley (multiplication) table for an algebra.
	 *
	 * @param n Number of basis vectors
	 * @param metric Array of n signs (+1, -1, or 0)
	 * @return 2D array where result[a][b] = {blade, sign} for a*b
	 */
	public static function cayleyTable(n:Int, metric:Array<Int>):Array<Array<{blade:Int, sign:Int}>> {
		var size = 1 << n; // 2^n blades
		var table = new Array<Array<{blade:Int, sign:Int}>>();

		for (a in 0...size) {
			table.push(new Array<{blade:Int, sign:Int}>());
			for (b in 0...size) {
				table[a].push(basisProduct(a, b, metric));
			}
		}

		return table;
	}

	/**
	 * Pretty-print a Cayley table for debugging.
	 */
	public static function printCayleyTable(n:Int, metric:Array<Int>, basisNames:Array<String>):String {
		var table = cayleyTable(n, metric);
		var size = 1 << n;
		var lines = new Array<String>();

		// Header
		var header = "     ";
		for (b in 0...size) {
			header += StringTools.rpad(bladeName(b, basisNames), " ", 6);
		}
		lines.push(header);

		// Rows
		for (a in 0...size) {
			var row = StringTools.rpad(bladeName(a, basisNames), " ", 5);
			for (b in 0...size) {
				var result = table[a][b];
				var name = bladeName(result.blade, basisNames);
				if (result.sign == -1)
					name = "-" + name;
				else if (result.sign == 0)
					name = "0";
				row += StringTools.rpad(name, " ", 6);
			}
			lines.push(row);
		}

		return lines.join("\n");
	}

	// Common metric signatures

	/** G(3,0,0) - 3D Euclidean */
	public static var METRIC_G3 = [1, 1, 1];

	/** G(3,0,1) - 3D Projective (PGA) - e0 is degenerate */
	public static var METRIC_PGA3 = [0, 1, 1, 1];

	/** G(1,3,0) - Spacetime Algebra (Minkowski +---) */
	public static var METRIC_STA = [1, -1, -1, -1];

	/** G(3,1,0) - Alternative Spacetime (-+++) */
	public static var METRIC_STA_ALT = [-1, 1, 1, 1];

	/** G(4,1,0) - Conformal GA */
	public static var METRIC_CGA = [1, 1, 1, 1, -1];
}
