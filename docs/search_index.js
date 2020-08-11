var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.jl",
    "category": "page",
    "text": ""
},

{
    "location": "#EmbeddedGraphs.EmbeddedGraph",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.EmbeddedGraph",
    "category": "type",
    "text": "EmbeddedGraph{T<:Integer} <: AbstractEmbeddedGraph{T}\n\nEmbedded Graph\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.EmbeddedGraph-Union{Tuple{T}, Tuple{LightGraphs.SimpleGraphs.SimpleGraph{T},Array,Function}} where T<:Integer",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.EmbeddedGraph",
    "category": "method",
    "text": "Constructor functions for the EmbeddedGraph structure\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.EuclideanGraph",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.EuclideanGraph",
    "category": "type",
    "text": "EuclideanGraph{T<:Integer} <: AbstractEmbeddedGraph{T}\n\nEuclidean Graph\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.EuclideanGraph-Union{Tuple{T}, Tuple{LightGraphs.SimpleGraphs.SimpleGraph{T},Array}} where T<:Integer",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.EuclideanGraph",
    "category": "method",
    "text": "Constructor functions for the EuclideanGraph structure\n\n\n\n\n\n"
},

{
    "location": "#Base.getindex-Tuple{AbstractEmbeddedGraph,Integer,Integer}",
    "page": "EmbeddedGraphs.jl",
    "title": "Base.getindex",
    "category": "method",
    "text": "Extends Base.getindex function to be able to call EG[i,j]. Returns the distance of the two vertices in the metric of the graph.\n\n\n\n\n\n"
},

{
    "location": "#Base.getindex-Tuple{EuclideanGraph,Integer,Integer}",
    "page": "EmbeddedGraphs.jl",
    "title": "Base.getindex",
    "category": "method",
    "text": "Extends Base.getindex function to be able to call EG[i,j]. Returns the distance of the two vertices in the metric of the graph.\n\n\n\n\n\n"
},

{
    "location": "#Base.rand-Tuple{LightGraphs.SimpleGraphs.SimpleEdgeIter}",
    "page": "EmbeddedGraphs.jl",
    "title": "Base.rand",
    "category": "method",
    "text": "Extends the Base.rand function to work with a SimpleEdgeIter\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.characteristic_length-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.characteristic_length",
    "category": "method",
    "text": "Calculate the characteristic length (average shortest path) of a graph.\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.characteristic_length_ER-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.characteristic_length_ER",
    "category": "method",
    "text": "Average path length of ER network as in 10.1103/PhysRevE.70.056110 .\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.degree_array-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.degree_array",
    "category": "method",
    "text": "Returns the degree histogram in an array.\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.global_clustering_coefficient_ER-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.global_clustering_coefficient_ER",
    "category": "method",
    "text": "clustering coefficient of an erdos renyi graph is equal to <k>/(n-1), because the probability of any vertex to be connected to any other vertex is the same and equal to the existence of any link. \n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.global_clustering_coefficient_Latt-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.global_clustering_coefficient_Latt",
    "category": "method",
    "text": "clustering coefficient of a ring lattice with average degree k = 2m/n. Only graphs with even k can be created, therefore the upper and lower even k lattices are average with weights\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.largest_component!-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.largest_component!",
    "category": "method",
    "text": "Changes the given graph, so that only the largest component remains\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.local_clustering_histogram-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.local_clustering_histogram",
    "category": "method",
    "text": "Returns the local clustering coefficient as a histogram in an array.\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.random_geometric_graph!-Tuple{AbstractEmbeddedGraph,Real}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.random_geometric_graph!",
    "category": "method",
    "text": "random_geometric_graph!(eg, radius; dist_func=Nothing)\n\nFrom an existing embedded complete graph eg, create a random geometric graph by removing edges between vertices that are more than radius apart. This in-place graph generator offers more flexibility with respect to the properties of the resulting EmbeddedGraph instance eg. For instance, the embedding metric determining the values of weights(eg) can be distinct from the distance function dist_func that is used to  create the random geometric graph.\n\nRef.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.\n\nOptional Arguments\n\ndist_func: distance function used to construct the random geometric graph. It can differ from the distance attribute of eg to allow for independent edge weights. Defaults to eg.distance when dist_func=Nothing is passed.\n\nExamples\n\njulia> egh = EmbeddedGraph(complete_graph(n), pos, hamming);\n\njulia> random_geometric_graph!(egh, rad; dist_func=euclidean)\n\njulia> egh.graph\n{50, 71} undirected simple Int64 graph\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.random_geometric_graph-Tuple{Int64,Real}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.random_geometric_graph",
    "category": "method",
    "text": "random_geometric_graph(n, radius; dim=2, pos=Nothing, embedding_metric=Nothing, dist_func=Nothing)\n\nCreate a random geometric graph with n vertices that are connected when their distance is less than radius. The vertex locations are randomly drawn from a uniform distribution on the unit interval in each dimension.\n\nRef.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.\n\nOptional Arguments\n\ndim: embedding dimension. Defaults to dim=2.\npos: vertex positions can be given as a list of n points with dim coordinates. Defaults to pos=Nothing.\ndist_func: distance function used to construct the random geometric graph. It can differ from the distance attribute of eg to allow for independent edge weights. Defaults to eg.distance when dist_func=Nothing is passed.\n\nExamples\n\njulia> random_geometric_graph(50, 0.2).graph\n{50, 105} undirected simple Int64 graph\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.rem_vertices!-Tuple{AbstractEmbeddedGraph,AbstractArray{var\"#s15\",1} where var\"#s15\"<:Integer,Vararg{Any,N} where N}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.rem_vertices!",
    "category": "method",
    "text": "Removes multiple vertices with given Indices at once\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.small_world_ness_HG-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.small_world_ness_HG",
    "category": "method",
    "text": "Implementation of the Small-World-Ness measure by M. D. Humphries and K. Gurney. doi:10.1371/journal.pone.0002051\n\nS = γC / γL, where γC = GCC(graph) / GCC(random graph) , and γL = CL(graph)  /  CL(random graph)\n\nGCC := Global Clustering Coefficient CL  := arachteristic Length\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.small_world_ness_Telesford-Tuple{LightGraphs.AbstractGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.small_world_ness_Telesford",
    "category": "method",
    "text": "Small-world-ness measure as in 10.1089/brain.2011.0038\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.vertices_loc-Tuple{AbstractEmbeddedGraph,Int64}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.vertices_loc",
    "category": "method",
    "text": "Functions return an array with the value of the vertices in the given spatial direction 1 == x direction, 2 == y direction, 3 == z direction ...\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.wiring_length-Tuple{AbstractEmbeddedGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.wiring_length",
    "category": "method",
    "text": "Calculate the sum of all the weights of the edges of a graph. \n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.SimpleGraphs.add_vertex!-Tuple{AbstractEmbeddedGraph,Array,Vararg{Any,N} where N}",
    "page": "EmbeddedGraphs.jl",
    "title": "LightGraphs.SimpleGraphs.add_vertex!",
    "category": "method",
    "text": "Adds vertex in the given graph. Position in the form [x,y,z,...] needed.\n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.SimpleGraphs.rem_vertex!-Tuple{AbstractEmbeddedGraph,Integer,Vararg{Any,N} where N}",
    "page": "EmbeddedGraphs.jl",
    "title": "LightGraphs.SimpleGraphs.rem_vertex!",
    "category": "method",
    "text": "Extends LightGraphs function and deletes also the element in the\nEG.vertexpos array. rem_vertex! in LightGraphs swaps the vertex v with\nthe last vertex and then uses pop! on the list to delete the last element.\n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.add_vertices!-Tuple{AbstractEmbeddedGraph,Array,Vararg{Any,N} where N}",
    "page": "EmbeddedGraphs.jl",
    "title": "LightGraphs.add_vertices!",
    "category": "method",
    "text": "Adds multiple vertices in the given graph at once. Position Array is needed.\n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.edges-Tuple{AbstractEmbeddedGraph,Vararg{Any,N} where N}",
    "page": "EmbeddedGraphs.jl",
    "title": "LightGraphs.edges",
    "category": "method",
    "text": "Extends basic LightGraphs functions to work with AbstractEmbeddedGraphs\n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.weights-Tuple{AbstractEmbeddedGraph}",
    "page": "EmbeddedGraphs.jl",
    "title": "LightGraphs.weights",
    "category": "method",
    "text": "Weights function gives back the weightmatrix of the graph.\nIt can be choosen whether the matrix should be dense, i.e. the distance\nbetween every vertex is inserted, or sparse, i.e. only the distance\nbetween connected vertices is given back.\n\n\n\n\n\n"
},

{
    "location": "#EmbeddedGraphs.jl-1",
    "page": "EmbeddedGraphs.jl",
    "title": "EmbeddedGraphs.jl",
    "category": "section",
    "text": "Documentation for EmbeddedGraphs.jlA simple package that provides support for embedded graphs.Modules = [EmbeddedGraphs]"
},

{
    "location": "#Index-1",
    "page": "EmbeddedGraphs.jl",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
