# Rendering Shaders

## Attributes

Interacting with variables inside of shaders is done by referring to the index
of an attribute. It's like a memory address for the shader variable that we use
to refer to query and assign values.

We use [`GetAttribLocation`](https://www.opengl.org/sdk/docs/man/html/glGetAttribLocation.xhtml)
to acquire the index of a variable inside of a vertex shader.

Example:

```go
var program gl.Program
var pos gl.Attrib
...
// Acquire the index of the `pos` variable inside of our vertex shader
pos = gl.GetAttribLocation(program, "pos")
```

When we're ready to set the value, we'll use [`VertexAttribPointer`](https://www.opengl.org/sdk/docs/man/html/glVertexAttribPointer.xhtml).
but first we need to tell it the shape we're referring to.


## Buffers

When we instruct the GPU to render something, we need to tell it what the thing
looks like. We can do this right as we ask it to render something, or better yet
we can upload it ahead of time into a buffer and just tell it which buffer to
refer to.

For example, we can create a vertex buffer object (VBO) to store our shape data
inside:

```go
// Allocate a buffer and return the address index
buf := gl.CreateBuffer()

// Activate the buffer we're referring to for the following instructions
gl.BindBuffer(gl.ARRAY_BUFFER, buf)

// Upload data to our active buffer
gl.BufferData(gl.ARRAY_BUFFER, &triangle, gl.STATIC_DRAW)
```

There are other kinds of buffers we can allocate, like texture buffers. More on
that below.


## Rendering boilerplate

Minimal rendering steps:

1. Set the background color (`ClearColor`).
1. Choose our compiled GPU program (`UseProgram`).
1. Upload our triangle vertices to the GPU (`BindBuffer`)
1. Activate attribute we're referring to (`EnableVertexAttribArray`).
1. Specify attribute value, configuration, and vertex data (`VertexAttribPointer`).
1. Draw with a given shape configuration (`DrawArrays`).
1. Deactivate attribute (`DisableVertexAttribArray`).
1. Display our new frame buffer.

Altogether, it might look something like this using our imaginary gl package:

```go
// Reset the canvas background
gl.ClearColor(1.0, 1.0, 1.0, 1.0) // White background
gl.Clear(gl.COLOR_BUFFER_BIT)

// Choose our compiled program
gl.UseProgram(program)

// Activate our pos attribute
gl.EnableVertexAttribArray(pos)

// Create a fresh a data buffer on the GPU to hold our vertex array
buf := gl.CreateBuffer()

// Select which buffer we're referring to for the following operations
gl.BindBuffer(gl.ARRAY_BUFFER, buf)

// Upload triangle data to the active buffer
gl.BufferData(gl.ARRAY_BUFFER, &triangle, gl.STATIC_DRAW)

// Configure our vertex setup for the elements in our active buffer
gl.VertexAttribPointer(
    pos,       // index of the generic vertex attribute to be modified
    3,         // number of components per generic vertex attribute
    gl.FLOAT,  // type of each component in the array
    false,     // whether fixed-point data values should be normalized
    0,         // stride: byte offset between consecutive generic vertex attributes
    0,         // offset of the first element in our active buffer
)

// Push our vertices into the vertex shader, 3 at a time
gl.DrawArrays(gl.TRIANGLES, 0, 3)

// Done with our active attribute
gl.DisableVertexAttribArray(pos)

// Swap our frame buffer...
```

The steps for configuring vertex attributes and drawing arrays can be repeated
multiple times to draw a complex scene.

Once we're done rendering things, we can clean up using `DeleteProgram` and
`DeleteBuffers` for our buffers.

Things that can be improved in this example:

- Initialize and upload our buffer data ahead of time so that it's not in our
  render loop.


