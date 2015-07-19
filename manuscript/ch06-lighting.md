# Lighting

When doing lighting, you can do the math in the vertex shader (per-vertex
shading) or in the fragment shader (per-fragment shading).

Per-vertex shading, such as [Gouraud shading](https://en.wikipedia.org/wiki/Gouraud_shading),
only does the processing per vertex, which is strictly 3 times per triangle, and
the values between are interpolated by the fragment shader. It's very efficient,
but the results aren't great. They're especially bad with large polygons.

Per-fragment shading, such as [Phong lighting](https://en.wikipedia.org/wiki/Phong_reflection_model),
is executing per fragment of a surface. A triangle is divided into many
fragments, proportional to its size. This method of lighting is more expensive
to compute, but yields better results and can be combined with things like bump
mapping.

See also: [Blinn–Phong shading model](https://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_shading_model),
an improvement over Phong shading.

Ref: http://www.tomdalling.com/blog/modern-opengl/06-diffuse-point-lighting/

Ref: http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/


## Components of lighting

A light's effect on the colour of a pixel is composed of several components:

- Normal vector (or perpendicular vector) of the fragment surface. The intensity
    of the light is related to the angle of reflection.

- Light position, shape (spot light? ambient light?), and intensity (or RGB
    values of the light).

- Material of the surface, including the colour, shininess, and possibly other
    attributes.

A light that is directly perpendicular to the surface will have maximum
intensity, whereas a light that is acute to the surface will only have a mild
effect in lighting it up. The normal vector of the surface is used to compute
this ratio against the position of the light origin. Similarly, the shape of the
light, such as if it's a cone, will determine how much a fragment is affected by
it.

The material of the surface determines how much of the light's intensities the
surface absorbs versus reflects. If it's a very shiny material, then the
resulting pixel will be more white at the most intense parts. If it's a matte
surface, then the underlying colour will be highlighted.


## Normal mapping

Surface normals of an object don't change, so pre-computing them is a useful
optimization. When importing an object model, it's common to include the normal
vectors for every surface.

Ref: http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-13-normal-mapping/

TODO

## Simple lighting shader

The trick to writing a performant yet effective lighting is properly dividing
the work done by the CPU in the game engine code (once per frame) versus the
instructions executed in the vertex shader (once per vertex) and fragment shader
(once per fragment).

TODO

Ref: http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/

