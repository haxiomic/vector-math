# Haxe Vector Math
**Requires [haxe 4.2+](https://build.haxe.org/builds/haxe/) (which is currently unreleased!)**

Haxe vector math library that enables GLSL vector and matrix operations to compile in haxe

- Built-in GLSL vector & float functions: `dot(vec3(1,2,3), vec3(4,5,6))`
- Operator overloads: `mat2(2) * vec2(3, 4) * 0.5 - vec2(0.5)`
- Swizzled read and write, for example: `vec3(0).yxz = vec3(1,2,3)`
- GLSL vector constructors that support vector composition, for example: `vec4(vec3(0), 1.0)` or `vec4(vec2(1), vec2(2))`
- Fully inlined so that vector objects are rarely constructed, instead vector operations compile to stack variables. For example, the following compiled with `-D analyzer-optimize`
	```haxe
	trace(length((mat2(2) * vec2(3, 4) * 0.5 - vec2(0.5))));
	```
	Generates
	```js
	console.log(Math.sqrt(18.5));
	```
	(Cool right?)


### Usage
Install with `haxelib install vector-math` (or simply copy [VectorMath.hx](VectorMath.hx) into your project as this is a single-file library)

Add `--library vector-math` to your hxml commands

Then simply import the VectorMath class: `import VectorMath;`. Add `--dce full` and `-D analyzer-optimize` to your hxml for clean output

```haxe
import VectorMath;

function main() {
	var normal = normalize(vec2(Math.random(), Math.random()));
	var tangent = normal.yx * vec2(-1, 1);
	var transformedTangent = mat2(2) * tangent;
}
```

### Q/A
- **Why does it require haxe 4.2 – this isn't yet released**

	This library uses module-level functions which are introduced in 4.2, it can be written without them and so can be modified to work on haxe 4.0. I don't plan on doing this myself but I'm happy to accept PRs for this

- **What are the differences to GLSL?**

	- Direct vector assignment is **reference** rather than **copy**, that is in the following statement: `var ref = original`, 'ref' represents the same underlying vector as 'original', whereas in GLSL it would be a copy. To copy a vector you can do any of `var copy = original.clone()`, `var copy = vec3(original)` or `var copy = original.xyz`. When accessing sub vectors, the accessed vector **is** copied. For example `var column0Copy = matrix[0]`
	- Aliases for rgba and stpq have been [turned off](https://github.com/haxiomic/quark/blob/6a2bed951b2af79c78baf175a5f6fef46bc79a4a/Vec.hx#L222) for compile-time performance
	- You can call methods via dot syntax in addition to regular calls, for example: `vec3(1).length()` and `length(vec(1))` are equivalent
	- Boolean and integer vector types are not yet included (`bvec` and `ivec`). These may come in the future if there's a desire for them

- **Which haxe targets does this work on?**

	All haxe targets are supported :)

- **Can this be used to generate shader code**

	Not _yet_, heaps has [hxsl](https://heaps.io/documentation/hxsl.html) which is similar in that it's a GLSL vector math implementation in haxe, but I believe it's only at the syntax-level and so can't be executed as regular haxe code or support autocomplete. I hope to combine these two approaches eventually to allow shader code to be generated from VectorMath operations

- **Which specification is this based on?**

	[GLSL ES 1.0 Specification](https://www.khronos.org/files/opengles_shading_language.pdf)