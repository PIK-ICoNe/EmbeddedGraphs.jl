module EmbeddedGraphs

    using LightGraphs, SparseArrays, Distances, GraphPlot, Compose

    # EmbeddedGraph constructors
    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsBase.jl"))
    include(joinpath(dirname(@__FILE__), "embeddedgraph.jl"))
    include(joinpath(dirname(@__FILE__), "euclideangraphs.jl"))

    export AbstractEmbeddedGraph, EmbeddedGraph, EuclideanGraph
    export edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
           is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
           add_edge!, add_vertex!, add_vertices!, rem_vertex!
    export weights, rem_vertices!, vertices_loc
    export getindex, rand


    # network characteristics
    include(joinpath(dirname(@__FILE__), "Characteristics.jl"))
    export characteristic_length, wiring_length, small_world_ness_HG,
    small_world_ness_Telesford, largest_component, largest_component!
    export degree_array, local_clustering_histogram
    export detour_indices, global_clustering_coefficient_ER, characteristic_length_ER,
    global_clustering_coefficient_Latt

    include(joinpath(dirname(@__FILE__), "EmbeddedGraphGenerators.jl"))

    export random_geometric_graph, random_geometric_graph!

    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsPlot.jl"))

    export gplot

end # end of module EmbeddedGraphs
