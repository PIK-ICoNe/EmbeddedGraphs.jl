module EmbeddedGraphs

    # EmbeddedGraph constructors
    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsBase.jl"))
    export  weights, edges, EmbeddedGraph, add_edge!, rem_edge!
            has_edge, has_vertex, inneighbors, ne, nv, outneighbors, inneighbors
            vertices, is_directed, add_vertex!, add_vertices!, rem_vertex!,
            rem_vertices!, edgetype, add_edge!, rem_edge!

    export vertices_loc, rand


    # network characteristics
    include(joinpath(dirname(@__FILE__), "Characteristics.jl"))

    export detour_indices

    include(joinpath(dirname(@__FILE__), "EmbeddedGraphsPlot.jl"))

    export gplot

end # end of module EmbeddedGraphs
