# Objects & Materials

There are several common object encoding formats used for importing models.


## Artisanally hand-crafted matrices

When building our first 3D rendering, it's easiest to just specify a few
vertices and get on with it. For example, a triangle might look like this:

```go
var triangle = []float32{
    // X, Y, Z
    -1.0, -1.0, 1.0,
    1.0, -1.0, 1.0,
    -1.0, 1.0, 1.0,
```

Or a square, made up of two triangles:

```go
var square = []float32{
    // X, Y, Z
    -1.0, -1.0, 1.0,
    1.0, -1.0, 1.0,
    -1.0, 1.0, 1.0,
    1.0, -1.0, 1.0,
    1.0, 1.0, 1.0,
    -1.0, 1.0, 1.0,
}
```

That square could be the front face of a cube, if we write up 5 more such
faces.

Next up, we'll want to define texture coordinates and normal vectors. We can do
this as separate datasets and use a different buffer for each, or we can
interleave the data with each vertex which improves the memory locality.

Ref: https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/TechniquesforWorkingwithVertexData/TechniquesforWorkingwithVertexData.html

### Interleaving Vertex Blocks

Ref: https://www.opengl.org/wiki/Vertex_Specification_Best_Practices

This is an optional optimization, feel free to skip it if you'd prefer to use
separate buffers for different data types.

When adding two more sets of columns for textures and normals, it looks like
this:

```go
var cube = []float32{
    // X, Y, Z, TU, TV, NX, NY, NZ
    ...

	// Front face
	-1.0, -1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0,
	1.0, -1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0,
	-1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0,
	1.0, -1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0,
	1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0,
	-1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0,

    ...
}
```

For now, we're going to have the same normal for every vertex on a single face.
This will give the effect that each polygon is flat, and our lighting equations
will react accordingly. Later, we'll look at [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping)
which generates normals for every *fragment* by referring to a bump map texture
for the values.

The matrix is just a large one-dimensional float array, not a two-dimensional
thing. This lets us pass in the full matrix as a single buffer to the GPU with a
specific *size*, *stride*, and *offset*, and it will extract the columns
appropriately.

```go
// Activate the buffer that contains our cube data
gl.BindBuffer(gl.ARRAY_BUFFER, cubeBuffer)

// Configure our vertex setup for the elements in our active buffer
gl.VertexAttribPointer(
    attrib,    // attribut we're passing data into (e.g. pos or tex or normal)
    size,      // number of vertices per row
    gl.FLOAT,  // type of each component in the array
    false,     // whether fixed-point data values should be normalized
    stride,    // stride: byte size of each row
    offset,    // byte offset of the first element in our active buffer
)
```

If our `attrib` is the vertex position (first three columns), then:

```go
offset = 0               // no offset, the vertex is first
size = 3                 // 3 columns in our vertex
stride = 4 * (3 + 2 + 3) // 4 bytes per float * (3d vertex + 2d texture coord + 3d normal)
```

Or if we're loading our texture map:

```go
offset = 4 * 3 // 4 bytes per float * 3d vertex
size = 2       // 2 columns in our texture map (TU, TW)
```

Or if we're loading our normal map:

```go
offset = 4 * (3 + 2) // 4 bytes per float * (3d vertex + 2d texture coord)
size = 3             // 3 columns in our normal map (NX, NY, NYZ)
```

The stride should stay the same. Remember that the GPU is a massively parallel
pipeline, so it will want to pass different data to each unit of concurrency to
be executed simultaneously. To do this, it will need to quickly dispatch whole
rows so that the parallel execution can begin as early as possible, and using
the stride to traverse rows is how it can do that.

Ultimately, when we're importing objects, this is the format that we'll end up
converting our models into before passing them into a GPU buffer.


## Wavefront OBJ geometry format

Ref: https://en.wikipedia.org/wiki/Wavefront_.obj_file

Most 3D modeling software (like [Blender](https://en.wikipedia.org/wiki/Blender_(software)))
know how to export models in OBJ format, and most languages have libraries for
importing these objects. This is the most common format used in production
engines.

Ref: http://www.opengl-tutorial.org/beginners-tutorials/tutorial-7-model-loading/

TODO: Talk about materials
