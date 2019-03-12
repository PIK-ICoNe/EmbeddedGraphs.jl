module EmbeddedGraphs

    # EmbeddedGraph constructors
    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsBase.jl"))
    export  edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
            is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
            add_edge!, add_vertex!, add_vertices!, rem_vertex!

    export weights, EmbeddedGraph, rem_vertices!, vertices_loc

    export getindex, rand


    # network characteristics
    include(joinpath(dirname(@__FILE__), "Characteristics.jl"))

    export detour_indices

    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsPlot.jl"))

    export gplot

end # end of module EmbeddedGraphs
