module EmbeddedGraphs

    # EmbeddedGraph constructors
    include(joinpath(dirname(pathof(@__MODULE__)), "EmbeddedGraphBase.jl"))

    export euclidean, weights, edges, EmbeddedGraph,
            has_edge, has_vertex, inneighbors, ne, nv, outneighbors,
            vertices, is_directed, add_vertex!, rem_vertex!, edgetype, euclidean

    # network characteristics
    include(joinpath(dirname(pathof(@__MODULE__)), "Characteristics.jl"))

    export detour_indices

end # end of module EmbeddedGraphs
