var documenterSearchIndex = {"docs":
[{"location":"#EmbeddedGraphs.jl","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.jl","text":"","category":"section"},{"location":"","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.jl","text":"Documentation for EmbeddedGraphs.jl","category":"page"},{"location":"","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.jl","text":"A simple package that provides support for embedded graphs.","category":"page"},{"location":"","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.jl","text":"Modules = [EmbeddedGraphs]","category":"page"},{"location":"#EmbeddedGraphs.EmbeddedGraph","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.EmbeddedGraph","text":"EmbeddedGraph{T<:Integer} <: AbstractEmbeddedGraph{T}\n\nEmbedded Graph\n\n\n\n\n\n","category":"type"},{"location":"#EmbeddedGraphs.EmbeddedGraph-Union{Tuple{T}, Tuple{Graphs.SimpleGraphs.SimpleGraph{T}, Array, Function}} where T<:Integer","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.EmbeddedGraph","text":"Constructor functions for the EmbeddedGraph structure\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.EuclideanGraph","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.EuclideanGraph","text":"EuclideanGraph{T<:Integer} <: AbstractEmbeddedGraph{T}\n\nEuclidean Graph\n\n\n\n\n\n","category":"type"},{"location":"#EmbeddedGraphs.EuclideanGraph-Union{Tuple{T}, Tuple{Graphs.SimpleGraphs.SimpleGraph{T}, Array}} where T<:Integer","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.EuclideanGraph","text":"Constructor functions for the EuclideanGraph structure\n\n\n\n\n\n","category":"method"},{"location":"#Base.getindex-Tuple{AbstractEmbeddedGraph, Integer, Integer}","page":"EmbeddedGraphs.jl","title":"Base.getindex","text":"Extends Base.getindex function to be able to call EG[i,j]. Returns the distance of the two vertices in the metric of the graph.\n\n\n\n\n\n","category":"method"},{"location":"#Base.getindex-Tuple{EuclideanGraph, Integer, Integer}","page":"EmbeddedGraphs.jl","title":"Base.getindex","text":"Extends Base.getindex function to be able to call EG[i,j]. Returns the distance of the two vertices in the metric of the graph.\n\n\n\n\n\n","category":"method"},{"location":"#Base.rand-Tuple{Graphs.SimpleGraphs.SimpleEdgeIter}","page":"EmbeddedGraphs.jl","title":"Base.rand","text":"Extends the Base.rand function to work with a SimpleEdgeIter\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.detour_indices-Tuple{AbstractEmbeddedGraph, Any}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.detour_indices","text":"detour_indices(eg::AbstractEmbeddedGraph, i)\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.random_geometric!-Tuple{AbstractEmbeddedGraph, Integer}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.random_geometric!","text":"Adds m shortest edges.\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.random_geometric!-Tuple{AbstractEmbeddedGraph, Real}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.random_geometric!","text":"Adds all edges shorter than r.\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.random_geometric_graph!-Tuple{AbstractEmbeddedGraph, Real}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.random_geometric_graph!","text":"random_geometric_graph!(eg, radius; dist_func=Nothing)\n\nFrom an existing embedded complete graph eg, create a random geometric graph by removing edges between vertices that are more than radius apart. This in-place graph generator offers more flexibility with respect to the properties of the resulting EmbeddedGraph instance eg. For instance, the embedding metric determining the values of weights(eg) can be distinct from the distance function dist_func that is used to  create the random geometric graph.\n\nRef.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.\n\nOptional Arguments\n\ndist_func: distance function used to construct the random geometric graph. It can differ from the distance attribute of eg to allow for independent edge weights. Defaults to eg.distance when dist_func=Nothing is passed.\n\nExamples\n\njulia> egh = EmbeddedGraph(complete_graph(n), pos, hamming);\n\njulia> random_geometric_graph!(egh, rad; dist_func=euclidean)\n\njulia> egh.graph\n{50, 71} undirected simple Int64 graph\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.random_geometric_graph-Tuple{Int64, Real}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.random_geometric_graph","text":"random_geometric_graph(n, radius; dim=2, pos=Nothing, embedding_metric=Nothing, dist_func=Nothing)\n\nCreate a random geometric graph with n vertices that are connected when their distance is less than radius. The vertex locations are randomly drawn from a uniform distribution on the unit interval in each dimension.\n\nRef.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.\n\nOptional Arguments\n\ndim: embedding dimension. Defaults to dim=2.\npos: vertex positions can be given as a list of n points with dim coordinates. Defaults to pos=Nothing.\ndist_func: distance function used to construct the random geometric graph. It can differ from the distance attribute of eg to allow for independent edge weights. Defaults to eg.distance when dist_func=Nothing is passed.\n\nExamples\n\njulia> random_geometric_graph(50, 0.2).graph\n{50, 105} undirected simple Int64 graph\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.rem_vertices!-Tuple{AbstractEmbeddedGraph, AbstractVector{<:Integer}, Vararg{Any}}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.rem_vertices!","text":"Removes multiple vertices with given Indices at once\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.vertices_loc-Tuple{AbstractEmbeddedGraph, Int64}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.vertices_loc","text":"Functions return an array with the value of the vertices in the given spatial direction 1 == x direction, 2 == y direction, 3 == z direction ...\n\n\n\n\n\n","category":"method"},{"location":"#EmbeddedGraphs.wiring_length-Tuple{AbstractEmbeddedGraph}","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.wiring_length","text":"Calculate the sum of all the weights of the edges of a graph. \n\n\n\n\n\n","category":"method"},{"location":"#Graphs.SimpleGraphs.add_vertex!-Tuple{AbstractEmbeddedGraph, Array, Vararg{Any}}","page":"EmbeddedGraphs.jl","title":"Graphs.SimpleGraphs.add_vertex!","text":"Adds vertex in the given graph. Position in the form [x,y,z,...] needed.\n\n\n\n\n\n","category":"method"},{"location":"#Graphs.SimpleGraphs.rem_vertex!-Tuple{AbstractEmbeddedGraph, Integer, Vararg{Any}}","page":"EmbeddedGraphs.jl","title":"Graphs.SimpleGraphs.rem_vertex!","text":"Extends Graphs.jl function and deletes also the element in the\nEG.vertexpos array. rem_vertex! in Graphs.jl swaps the vertex v with\nthe last vertex and then uses pop! on the list to delete the last element.\n\n\n\n\n\n","category":"method"},{"location":"#Graphs.add_vertices!-Tuple{AbstractEmbeddedGraph, Array, Vararg{Any}}","page":"EmbeddedGraphs.jl","title":"Graphs.add_vertices!","text":"Adds multiple vertices in the given graph at once. Position Array is needed.\n\n\n\n\n\n","category":"method"},{"location":"#Graphs.edges-Tuple{AbstractEmbeddedGraph, Vararg{Any}}","page":"EmbeddedGraphs.jl","title":"Graphs.edges","text":"Extends basic Graphs.jl functions to work with AbstractEmbeddedGraphs\n\n\n\n\n\n","category":"method"},{"location":"#Graphs.weights-Tuple{AbstractEmbeddedGraph}","page":"EmbeddedGraphs.jl","title":"Graphs.weights","text":"Weights function gives back the weightmatrix of the graph.\nIt can be choosen whether the matrix should be dense, i.e. the distance\nbetween every vertex is inserted, or sparse, i.e. only the distance\nbetween connected vertices is given back.\n\n\n\n\n\n","category":"method"},{"location":"#Index","page":"EmbeddedGraphs.jl","title":"Index","text":"","category":"section"},{"location":"","page":"EmbeddedGraphs.jl","title":"EmbeddedGraphs.jl","text":"","category":"page"}]
}
