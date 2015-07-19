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
