# Haxe Vector Math

**Requires [haxe 4.2+](https://build.haxe.org/builds/haxe/)**

Haxe vector math library that enables GLSL vector and matrix operations to compile in haxe

## Features

**GLSL Built-in Functions**

All build-in functions are available after `import VectorMath;`
```haxe
import VectorMath;

var direction = normalize(velocity);
var speed = length(velocity);
```

**Vector and Matrix Constructors**

Vectors and matrices can be constructed in the same way as GLSL
```haxe
// new keyword not required
vec2(1, 2);

// single argument sets all components
vec2(0.0);

// vector composition
var color = vec3(0, 1, 0);
vec4(color, a);

// matrices can be composed from vectors
mat2(
	vec2(1, 0), // column 0
	vec2(0, 1)  // column 1
);

// a single argument sets the diagonal components (which creates a scale matrix)
mat2(scale);
```

**Operator Overloads**

All vector, matrix and scalar operations available in GLSL are supported
```haxe
// vectors can multiply with scalars
vec2(1, 2) * 0.5;

// vectors can be multiplied with compatible matrices
mat2(2) * vec2(3, 4);
var position = projection * view * model * vec4(xyz, 1.0);

// +=, *= etc work
var dt = 1/60;
var position = vec2(0.0);
var velocity = vec2(0.3, 0.4);
position += velocity * dt;

// component-wise comparison
vec2(1, 2) == vec2(1, 2) // true
```

**Swizzles**

Supports all possible _read_ and _write_ swizzle operations, including aliases `rgba` and `stpq`
```haxe
vec4(1, 2, 3, 4).wzyx == vec4(4, 3, 2, 1); // true

// set xy components to (1, 2)
var position = vec4(0.0);
position.xy = vec2(1, 2);

// set rgb components to green
var color4 = vec4(1.0); // white
color4.rgb = vec3(0., 1., 0); // green
```

**Performance**

All operations are inlined so that vector objects are rarely constructed, instead vector operations compile to stack variables (meaning we can avoid the GC completely for most vector operations!). For example, the following compiled with `-D analyzer-optimize`

```haxe
trace(length(mat2(2) * vec2(3, 4) * 0.5 - vec2(0.5)));
```

Generates

```js
console.log(Math.sqrt(18.5));
```
(Cool right?)

Furthermore, because vector components are just stack variables these operations are easily auto-vectorized (SIMD) on compiled targets like cpp


### Usage
Install with `haxelib install vector-math` (or simply copy [VectorMath.hx](VectorMath.hx) into your project as this is a single-file library)

Add `--library vector-math` to your hxml commands

Then simply import the VectorMath class: `import VectorMath;`

```haxe
import VectorMath;

function main() {
	var normal = normalize(vec2(Math.random(), Math.random()));
	var tangent = normal.yx * vec2(-1, 1);
	var transformedTangent = mat2(2) * tangent;
}
```

Add `--dce full` and `-D analyzer-optimize` to your hxml for clean output!

### Q/A
- **What are the differences to GLSL?**

	- Direct vector assignment is **reference** rather than **copy**, that is: in the following statement: `var ref = original`, 'ref' represents the same underlying vector as 'original', whereas in GLSL it would be a copy. To copy a vector you can do any of `var copy = original.clone()`, `var copy = vec3(original)` or `var copy = original.xyz`. When accessing sub vectors, the accessed vector **is** copied. For example `var column0Copy = matrix[0]`
	- You can call methods via dot syntax in addition to regular calls, for example: `vec3(1).length()` and `length(vec(1))` are equivalent
	- Boolean and integer vector types are not yet included (`bvec` and `ivec`). These may come in the future if there's a desire for them

- **Which haxe targets does this work on?**

	All haxe targets are supported with the exception of macros, this is an optimization to improve compile time performance

- **Can this be used to generate shader code?**

	Not _yet_, heaps has [hxsl](https://heaps.io/documentation/hxsl.html) which is similar in that it's a GLSL vector math implementation in haxe, but I believe it's only at the syntax-level and so can't be executed as regular haxe code or support autocomplete. I hope to combine these two approaches eventually to allow shader code to be generated from VectorMath operations

- **Which specification is this based on?**

	[GLSL ES 1.0 Specification](https://www.khronos.org/files/opengles_shading_language.pdf)