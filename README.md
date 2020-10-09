# EmbeddedGraphs.jl

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://fhell.github.io/EmbeddedGraphs.jl/dev)

# Example usage

The example requires
```julia
using EmbeddedGraphs
using Distances
using LightGraphs
```

Set the position of the vertices that need to be placed on the graph
```julia
positions = map(i->[rand(),rand()], 1:10)
```

Create the graph with a given SimpleGraph structure and positions
```julia 
eg = EmbeddedGraph(SimpleGraph(10), positions)
```

In case you want to have a different metric this is possible with a third argument, where the
points `P` and `Q` should be the positions of the vertices.
```julia 
eg_minkowski = EmbeddedGraph(SimpleGraph(10), positions, (P, Q) -> minkowski(P, Q, 2.))
```

Calculate the distance between two vertices ...
```julia 
eg[1,9]
```

... or likewise
```julia 
euclidean(eg.vertexpos[1], eg.vertexpos[9])
```


Get the x value of all the vertices ...
```julia 
vertices_loc(eg, 1)
```

... or y location
```julia 
vertices_loc(eg, 2)
```

Get the Weightsmatrix with distances between every vertex ...
```julia 
weights(eg, dense=true)
```

... or only a sparse matrix with only connected vertices
```julia 
weights(eg, dense=false)
```


Add an edge
```julia 
add_edge!(eg, 1, 9)
add_edge!(eg, 5, 7)
```


Remove an edge
```julia 
rem_edge!(eg, 1, 9)
```


Add a vertex at position `(0.1, 0.7)`
```julia 
add_vertex!(eg, [0.1, 0.7])
```


Remove a vertex
```julia 
rem_vertex!(eg, 5)
rem_vertices!(eg, [1, 2, 3])
```


Plot the graph embedded in 2D
```julia 
gplot(eg)
```

