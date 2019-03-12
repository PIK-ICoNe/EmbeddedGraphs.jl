using EmbeddedGraphs
using Distances
using LightGraphs

# Set the position of the vertices that need to be placed on the graph
positions = map(i->[rand(),rand()], 1:10)

# Create the graph with a given SimpleGraph structure and positions
eg = EmbeddedGraph(SimpleGraph(10), positions)

# In case you want to have a different Metric this is possible with a third argument
eg_minkowski = EmbeddedGraph(SimpleGraph(10), positions, minkowski)

# Calculate the distance between two vertices
eg[1,9]
# or likewise
euclidean(eg.vertexpos[1], eg.vertexpos[9])

# Get the x value of all the vertices
vertices_loc(eg, 1)
# or y location
vertices_loc(eg, 2)

# Get the Weightsmatrix with distances between every vertex
weights(eg, dense=true)
# or only a sparse matrix with only connected vertices
weights(eg, dense=false)

# Add an edge
add_edge!(eg, 1, 9)
add_edge!(eg, 5, 7)

# Remove an edge
rem_edge!(eg, 1, 9)

# Add a vertex
add_vertex!(eg, [0.1, 0.7])

# Remove a vertex
rem_vertex!(eg, 5)
rem_vertices!(eg, [1, 2, 3])

# Plot the Graph
gplot(eg)
