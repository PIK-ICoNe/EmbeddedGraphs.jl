module EmbeddedGraphs

    using Graphs, SparseArrays, Distances, GraphPlot

    # extension of Graphs.jl for subtypes of AbstractEmbeddedGraph
    include(joinpath(dirname(@__FILE__), "graphs_extensions.jl"))

    # EmbeddedGraph constructors
    include(joinpath(dirname(@__FILE__), "embeddedgraph.jl"))

    # EuclideanGraph constructors
    include(joinpath(dirname(@__FILE__), "euclideangraph.jl"))

    export AbstractEmbeddedGraph, EmbeddedGraph, EuclideanGraph
    export edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
           is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
           add_edge!, add_vertex!, add_vertices!, rem_vertex!
    export weights, rem_vertices!, vertices_loc
    export getindex, rand


    # network characteristics
    include(joinpath(dirname(@__FILE__), "graph_characteristics.jl"))
    export characteristic_length, wiring_length, small_world_ness_HG,
    small_world_ness_Telesford, largest_component, largest_component!
    export degree_array, local_clustering_histogram
    export detour_indices, global_clustering_coefficient_ER, characteristic_length_ER,
    global_clustering_coefficient_Latt

    include(joinpath(dirname(@__FILE__), "graph_generators.jl"))

    export random_geometric, random_geometric!

    include(joinpath(dirname(@__FILE__), "gplot_extensions.jl"))

    export gplot

end # end of module EmbeddedGraphs
