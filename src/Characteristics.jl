"""
Define characteristic quantities for spatial networks from
    https://arxiv.org/pdf/1010.0302.pdf
"""

import LightGraphs: dijkstra_shortest_paths

function detour_indices(eg::AbstractEmbeddedGraph, i)
    weight_matrix = zeros(nv(eg), nv(eg))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = eg[I]
    end
    paths = dijkstra_shortest_paths(eg.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / eg.distance(i, j) for j in 1:nv(eg)]
end

""" Changes the given graph, so that only the largest component remains"""
function largest_component!(graph::AbstractGraph)
    ### FIRST COMPONENT IS NOT LARGEST COMPONENT!!!
    components = connected_components(graph)
    len = map(i -> length(components[i]), 1:length(components))
    deleteat!(components, findmax(len)[2])
    components = collect(Iterators.flatten(components))
    LightGraphs.rem_vertices!(graph, components)
    graph
end

largest_component(graph::AbstractGraph) = largest_component!(Graph(graph))
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
function small_world_ness(graph::AbstractGraph)
    larg_comp_graph = largest_component(graph)
    small_world_ness(nv(larg_comp_graph), ne(larg_comp_graph), global_clustering_coefficient(larg_comp_graph),
        characteristic_length(larg_comp_graph))
end

function small_world_ness(NV::Integer, NE::Integer, gcc::Real, cl::Real)
    γ_C = gcc / global_clustering_coefficient_ER(NV, NE)
    γ_L = cl / characteristic_length_ER(NV, NE)
    return γ_C / γ_L
end

""" Calculate the characteristic length (average shortest path) of a graph."""
function characteristic_length(graph::AbstractGraph; cutoff::Real=Inf)
    L = 0
    for i in 1:nv(graph)
        L += sum(clamp.(dijkstra_shortest_paths(graph, i).dists, 0, cutoff))
    end
    return L / (nv(graph) * (nv(graph) - 1))
end

""" Calculate the sum of all the weights of the edges of a graph. """
function wiring_length(EG::AbstractEmbeddedGraph; distmx::AbstractMatrix=weights(EG))
    return sum(distmx) / 2. / ne(EG)
end

""" Returns the degree histogram in an array."""
function degree_array(graph::AbstractGraph; bins::Integer=50)
    histogram = degree_histogram(graph)
    degree_array = zeros(bins)
    for pair in histogram
        degree_array[pair.first + 1] = pair.second
    end
    degree_array ./ nv(graph)
end

""" Returns the local clustering coefficient as a histogram in an array."""
function local_clustering_histogram(graph::AbstractGraph; bins::Integer=101)
    coefficient = local_clustering_coefficient(graph)
    histogram = zeros(bins)
    for value in coefficient
        histogram[floor(Integer, value*(bins-1)) + 1] += 1.
    end
    histogram ./ nv(graph)
end


function characteristic_length1(graph::AbstractGraph; cutoff::Real=1000., distmx::AbstractMatrix=weights(graph))
    dists = clamp.(LightGraphs.Parallel.floyd_warshall_shortest_paths(graph, distmx).dists, 0., cutoff)
    # clamp!(dists, 0., cutoff)
    return sum(dists) / (nv(graph) * (nv(graph) - 1))
end



function characteristic_length3(graph::AbstractGraph; cutoff::Real=1000., distmx::AbstractMatrix=weights(graph))
    L = sum(clamp.(LightGraphs.Parallel.dijkstra_shortest_paths(g,collect(1:250)).dists, 0., cutoff))
    return L / (nv(graph) * (nv(graph) - 1))
end

"""
Average path length of ER network as in 10.1103/PhysRevE.70.056110 .
"""
characteristic_length_ER(n, m) = (log(n) - Base.MathConstants.eulergamma) / log((2 * m) / n) + 0.5

global_clustering_coefficient_ER(n, m) = 2m / (n * (n - 1))
