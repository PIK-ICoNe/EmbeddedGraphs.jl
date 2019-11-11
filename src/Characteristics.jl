"""
Define characteristic quantities for spatial networks from
    https://arxiv.org/pdf/1010.0302.pdf
"""

import LightGraphs: dijkstra_shortest_paths

""" Calculate the characteristic length (average shortest path) of a graph."""
function characteristic_length(graph::AbstractGraph; cutoff::Real=1000)
    L = 0
    for i in 1:nv(graph)
        L += sum(clamp.(dijkstra_shortest_paths(graph, i).dists, 0, cutoff))
    end
    return L / (nv(graph) * (nv(graph) - 1))
end

function detour_indices(eg::EmbeddedGraph, i)
    weight_matrix = zeros(nv(eg), nv(eg))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = eg[I]
    end
    paths = dijkstra_shortest_paths(eg.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / eg.distance(i, j) for j in 1:nv(eg)]
end

""" Changes the given graph, so that only the largest component remains"""
function get_largest_component!(graph::AbstractGraph)
    ### FIRST COMPONENT IS NOT LARGEST COMPONENT!!!
    components = connected_components(graph)
    len = map(i -> length(components[i]), 1:length(components))
    deleteat!(components, findmax(len)[2])
    components = collect(Iterators.flatten(components))
    LightGraphs.rem_vertices!(graph, components)
    graph
end

"""
Implementation of the Small-World-Ness measure by M. D. Humphries and K. Gurney.
doi:10.1371/journal.pone.0002051

S = γ_C / γ_L,
where
γ_C = GCC(graph) / GCC(random graph) , and
γ_L = CL(graph)  /  CL(random graph)

GCC := Global Clustering Coefficient
CL  := arachteristic Length
"""
function small_world_ness(graph::AbstractGraph; Num_rand_graph::Integer=1000)
    rgcc = 0
    rcl  = 0
    NV = nv(graph)
    NE = ne(graph)
    get_largest_component!(graph)
    for i in 1:Num_rand_graph
        rg = erdos_renyi(NV, NE)
        get_largest_component!(rg)
        rgcc += global_clustering_coefficient(rg)
        rcl  += characteristic_length(rg)
        # println(rcl==NaN)
    end
    γ_C = global_clustering_coefficient(graph) / (rgcc / Num_rand_graph)
    γ_L = characteristic_length(graph) / (rcl / Num_rand_graph)
    println(γ_C, ", ", γ_L, ", ", rcl)
    return γ_C / γ_L
end

""" Calculate the characteristic length (average shortest path) of a graph."""
function characteristic_length(graph::AbstractGraph; cutoff::Real=Inf, silent=false)
    (!silent && !is_connected(graph)) && (@warn "Graph is not connected")
    L = 0
    for i in 1:nv(graph)
        L += sum(clamp.(dijkstra_shortest_paths(graph, i).dists, 0, cutoff))
    end
    return L / (nv(graph) * (nv(graph) - 1))
end
