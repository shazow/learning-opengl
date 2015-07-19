# Textures

Ref: https://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_06

Textures can be loaded into a buffer, configured, and used on many different
surfaces. The process is similar to our rendering boilerplate above:

```go
// Allocate a texture buffer
texture = gl.CreateTexture()

// TODO: Explain this?
gl.ActiveTexture(gl.TEXTURE0)

// Select which texture buffer we're referring to
gl.BindTexture(gl.TEXTURE_2D, texture)

// Set rendering parameters for interpolation, clamping, wrapping, etc.
gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
// ... 

// Upload image data
gl.TexImage2D(
    gl.TEXTURE_2D,      // target
    0,                  // level
    img.Rect.Size().X,  // width
    img.Rect.Size().Y,  // height
    gl.RGBA,            // format
    gl.UNSIGNED_BYTE,   // type
    img.Pix,            // texture image pixel data
)
```

Before we can start using the texture in our fragment shader to render onto the
surface of our shape, we need to communicate the texture coordinates.

To do this, we'll need to update out fragment shader:

```glsl
#version 100

precision mediump float;

uniform sampler2D tex;

varying vec2 fragTexCoord;

void main() {
    gl_FragColor = texture2D(tex, fragTexCoord);
}
```

We pass in a `varying vec3 fragTexCoord` which we'll set from our vertex shader.
The `texture2D` function will interpolate values from the image data in `tex`
based on the vertices we pass in through `fragTexCoord`. Remember how we
rendered a gradient of colours between vertex values? This does the same thing
but it uses sampling across image data to get the colour values.

Now, we update our vertex shader to pass in the `fragTexCoord` value:

```glsl
#version 100

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

attribute vec3 pos;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

void main() {
	fragTexCoord = vertTexCoord;
    gl_Position = projection * view * model * vec4(pos, 1);
}
```

Specifically, note the `fragTexCoord = vertTexCoord;` line, that's how we
communicate from the vertex shader and into the fragment shader. We'll also need
to pass in a new attribute into the vertex shader, the `vertTexCoord` value.

The next part is a bit tricky because we need to worry about how the texture is
clamped to the coordinates we give it, which will also determine its orientation
and stretching. 

Ref: https://en.wikibooks.org/wiki/OpenGL_Programming/Intermediate/Textures

## UV mapping

Ref: https://en.wikipedia.org/wiki/UV_mapping

Texture coordinates are often specified alongside mesh vertex coordinates.
Similarly, they are specified as `{X, Y}` coordinates (or `{X, Y, Z}` for 3D)
but instead use the consecutive letters UVW because the letters XYZ are already
used for vertices. That is, `{U, V, W}` is `{X, Y, Z}` for texture mapping.
Sometimes it's referred to as `{TU, TV, TW}` with T-for-texture prefix for
clarity.

Most 3D modelling tools like Blender will export texture maps alongside the
object mesh. Usually a 2D texture map is used for a 3D mesh, so an object
mesh will include the fields `{X, Y, Z, U, V}` where the last two are the
texture map coordinates for that vertex.

Unlike vector coordinates, the texture coordinates are used by the fragment
shader so their values are used for the face of the fragment.


## Texture mapping

Ref: https://en.wikipedia.org/wiki/Texture_mapping

TODO
