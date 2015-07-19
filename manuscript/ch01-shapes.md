# Shapes

A vertex is the coordinate of a point. In a three-dimensional context, a vertex
might look like {1, 2, 3} for x, y, z coordinates. A line is made of two
vertices, and a triangle is made of three vertices.

When we define vertices, we need to indicate how they should be treated. Whether
each one is an independent point (`GL_POINTS`) or a line (`GL_LINES`) or more
commonly, a triangle (`GL_TRIANGLES`).

Triangles are the elementary shapes of GPUs. A square can be constructed with
two triangles, for example. Some versions of OpenGL drivers know about other
shapes (such as `GL_QUADS` and `GL_POLYGONS`) but support for them is being
removed to reduce API complexity.

Another handy benefit of triangles is that moving any vertex on a triangle will
still keep it as a single-plane triangle (just maybe a different proportion or
orientation). On the other hand, if you use a quad or complex polygon, then
moving a vertex can transform it into a multi-plane shape or disturb the
original properties of the shape, and this can cause unexpected rendering issues
if we're making assumptions about our shapes. For example, moving a single
corner of a rectangle will produce a shape that is no longer a rectangle.
Triangles are always triangles.

When in doubt, use triangles.

Example:

```go
var triangle = []float32{
    0.0, 1.0, 0.0, // Top-left
    0.0, 0.0, 0.0, // Bottom-left
    1.0, 0.0, 0.0, // Bottom-right
}
```

Vertices are defined as an array of floats in *counter-clockwise order*. (By
default, the [face culling feature](https://www.opengl.org/wiki/Face_Culling)
is setup to determine the front/back of a shape by assuming that vertices'
"winding order" is counter-clockwise. This can be changed but it needs to be
consistent.)

Because it's a single array, not an array of three three-point arrays, we need
to tell GL how to interpret the array (is it a bunch of 2D coordinates? 3D? is
there extra texture data?). When we bind our vertices variable into a shader
attribute, we pass in a size value that tells it how to treat that data.
