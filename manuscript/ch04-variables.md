## Shader Variables

Ref: https://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_03


### Attribute

`attribute` variables we can change for every vertex array that we render.


### Uniform

`uniform` variables contain global information that is the same across all
vertex arrays. This can be used to create a global opacity value, or a lighting
angle. `uniform` variables are set with `Uniform*` functions depending on the
type.


### Varying

`varying` variables can be used to communicate from the vertex shader into the
fragment shader.

If we have a `varying` variable with the same declaration in both shaders, then
setting its value in the vertex shader will set it in the fragment shader.
Because fragment shaders are run on every pixel in the body of a polygon, the
varying value will be interpolated between the vertex points on the polygon
creating a gradient.

`varying` variables are set from inside the vertex shader.


## Matrix transformations

Shaders support convenient matrix computations but if a translation is going
to be the same for many vertices then it's better to pre-compute it once and
pass it in.

When scaling, rotating, and moving a set of vertices in one operation, it's
important to scale first, rotate second, and move last. In the opposite order,
the rotation will happen around the origin before moving and scaling.


### Model-View-Projection matrix

Ref: https://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_05

To support depth, perspective, and an independent camera, we compute a
Model-View-Projection (MVP) matrix that we'll use to multiply against vertices
in our vertex shader.

> To work with multiple objects, and position each object in the 3D world, we compute a transformation matrix that will:
>
> - shift from model (object) coordinates to world coordinates (model->world)
> - then from world coordinates to view (camera) coordinates (world->view)
> - then from view coordinates to projection (2D screen) coordinates (view->projection)

To compute the projection matrix, we need the field of view, aspect ratio, and
the clipping planes for near and far. Example:

```go
matrix.Perspective(
    0.785,        // fov: 45 degrees = 60-degree horizontal FOV in 4:3 resolution
    width/height, // aspect ratio of our viewport
    0.1,  // Near clipping plane
    10.0, // Far clipping plane
)
```

To compute the view matrix, we need the position of the camera, the center of
the view port, and the upwards vector direction. Example:

```go
matrix.LookAt(
    Vec3{3, 3, 3}, // eye: position of the camera
    Vec3{0, 0, 0}, // center of the viewport
    Vec3{0, 1, 0}, // up: used to roll the view
)
```

*Note: If rotating the viewport upwards, it's important to rotate the up vector
as well as the center vector. There can be unexpected behaviour if the two
vectors approach each other.*

To compute the model matrix we need to translate into where we want it to live
in our world coordinates. For example, if we want to rotate it a bit on the Y
plane:

```go
matrix.Rotate(
    identity,      // center of rotation (e.g. identity matrix)
    0.3,           // angle in radians
    Vec3{0, 1, 0}, // plane
)
```

Finally, we can pass the MVP either as a single pre-computed `uniform` variable
or in its various pieces to the vertex shader and multiply the input vertices to
get the desired result. When dealing with more complicated shaders, the separate
pieces can be useful individually.
