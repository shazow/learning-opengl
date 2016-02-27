# Appendix

Things that haven't been fleshed out into chapters yet.

## Index Buffer Objects (IBO)

TODO

Ref: http://openglbook.com/chapter-3-index-buffer-objects-and-primitive-types.html

Ref: http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-9-vbo-indexing/


## Freeing resources

Once we're done using our shader program and various buffers, we should delete
them.

```go
gl.DeleteProgram(program)
gl.DeleteBuffer(buf)
gl.DeleteTexture(texture)
...
```

## Camera movement

Ref: https://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_Navigation


### Rotations

Remember hearing airplane people talk about roll, pitch, and yaw? Now it's time
to learn what they mean!

When we're staring at a point, we can rotate our view about three axes (plural
of axis, huh). We can look up and down, left and right, or tilt it to our sides.

Alright, let's go over these in a bunch of different ways:

- *Pitch*, or "rotate about the X axis", or look up and down.
- *Yaw", or "rotate about the Y axis", or look left and right.
- *Roll*, or "rotate about the Z axis", or tilt sideways.

The axis rotation assumes we're using OpenGL's default axis configuration. That
is, XYZ and positive-Y is upwards.

Roll is often ignored in most game genres (except for flight simulators), but
it's an important rotation for Virtual Reality--whenever that becomes a thing.


### Mouse Rotations

The simplest way to map mouse motions to camera rotations is to keep track of
the mouse position coordinate changes between each frame.

TODO: Code example


### Gimbal Lock

When computing camera rotation using separate pitch, yaw, and roll angles (known
as Euler Angles), we run into problems as the camera spins vertically
approaching the upwards vector.

If two rotation degrees come get into alignment then one degree of control is
lost until they're misaligned again. This is called a [Gimbal Lock](https://en.wikipedia.org/wiki/Gimbal_lock).

This can be worked around by intentionally limiting the vertical rotation to
stop just before the upwards and bottomwards positions, which is a common
solution for first person shooter games. If you're flying a plane and want to do
a barrel roll, then that's not going to *fly*.

Another solution to maintaining unrestricted full range of motion at all
orientations is to represent our rotation as a matrix or a quaternion.


## Quaternions

Ah, quaternions. What are they? How do they work? Why does the name sound so
scary?  Nobody really knows. Okay, some people know. Let's see what we can
figure out.

Some bookmarks for later:

Ref:

- http://www.ogre3d.org/tikiwiki/Quaternion+and+Rotation+Primer
- http://content.gpwiki.org/index.php/OpenGL%3aTutorials%3aUsing_Quaternions_to_represent_rotation
- https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation

Quaternions *units* are used to represent rotation...

TODO: ...


## Model Animation

Ref: http://wiki.polycount.com/wiki/Limb_Topology

Ref: https://www.opengl.org/wiki/Skeletal_Animation

## Advanced Lighting

Ref: http://0fps.net/2013/07/03/ambient-occlusion-for-minecraft-like-worlds/
