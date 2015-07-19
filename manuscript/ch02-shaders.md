# Shaders

Shaders are programmable pipelines that are compiled into GPU-native
instructions to be executed en-mass. Shaders can be have variables such as
`attribute` that can be used as inputs from external code.

There are many versions of OpenGL and thus of the GLSL (OpenGL Shading Language)
dialect used to program shaders. In fact, there are even two divergent versions:
*OpenGL* used on personal computers, and *OpenGL ES* (OpenGL for Embedded
Systems) used on mobile platforms and WebGL. Newer versions of OpenGL and GLSL
come with newer features, but if platform compatibility is important then use
the earliest version of GLSL that supports the features needed.

Our examples use `#version 100` that is compatible with OpenGL ES 2.0, which
should work on WebGL and most mobile platforms.

See:

- https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions
- https://en.wikipedia.org/wiki/OpenGL_ES

## Vertex Shaders

Vertex shaders work by setting the `gl_Position` variable, a [built-in output
variable](https://www.opengl.org/wiki/Built-in_Variable_(GLSL)), which defines
the `vec4` position (a 4D vector representing `{X, Y, Z, W}` for where a vertex
should be rendered.

*Aside: 4D positions are known as Homogeneous Coordinates. The `W` component is
a normalization value that moves the 3D position away and towards the origin.
We'll generally leave it at 1.0, but it will be changing as we multiply vectors
with our modelview projection matrix later.  ([Additional
reading](http://glprogramming.com/red/appendixf.html))*

Example:

```glsl
#version 100

attribute vec4 pos;

void main(void) {
    gl_Position = pos;
}
```

In this example, the `pos` variable can be manipulated by the caller.

Vertex shaders are executed for every vertex (usually corners) of a shape. In
the case of a triangle, it will be three times per triangle.


## Fragment Shaders

Fragment shaders work by setting the `gl_FragColor` variable which defines the
RGBA fill color of the face of a shape (usually a triangle, but sometimes a quad
or complex polygon);

Example:

```glsl
#version 100

void main(void) {
    gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
}
```

This will fill our shape's face with blue.

Fragment shaders are executed for every fragment of a shape's face, which is
often as small as a pixel. Fragment shaders do a lot more work than vertex
shaders, so it's a good idea to pre-compute what we can outside of the fragment
shader.


## Compiling

Once our shaders are defined, we need to [compile, attach, and link them into a
program](https://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Introduction#GLSL_program).
