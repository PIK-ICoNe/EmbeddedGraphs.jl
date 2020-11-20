"""
Define characteristic quantities for spatial networks from
    https://arxiv.org/pdf/1010.0302.pdf
"""

import LightGraphs: dijkstra_shortest_paths

"""
detour_indices(eg::AbstractEmbeddedGraph, i)
"""
function detour_indices(eg::AbstractEmbeddedGraph, i)
    weight_matrix = zeros(nv(eg), nv(eg))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = eg[I]
    end
    paths = dijkstra_shortest_paths(eg.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / eg.distance(i, j) for j in 1:nv(eg)]
end


function detour_indices(EG::EuclideanGraph, i)
    weight_matrix = zeros(nv(EG), nv(EG))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = EG[I]
    end
    paths = dijkstra_shortest_paths(EG.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / EG[i, j] for j in 1:nv(EG)]
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
function small_world_ness_HG(graph::AbstractGraph)
    larg_comp_graph = largest_component(graph)
    small_world_ness_HG(nv(larg_comp_graph), ne(larg_comp_graph), global_clustering_coefficient(larg_comp_graph),
        characteristic_length(larg_comp_graph))
end

function small_world_ness_HG(NV::Integer, NE::Integer, gcc::Real, cl::Real)
    γ_C = gcc / global_clustering_coefficient_ER(NV, NE)
    γ_L = cl / characteristic_length_ER(NV, NE)
    return γ_C / γ_L
end
function small_world_ness_HG(NV::Integer, k::Real, gcc::Real, cl::Real)
    return small_world_ness_HG(NV, round(Integer, k*NV/2), gcc, cl)
end

"""
Small-world-ness measure as in 10.1089/brain.2011.0038
"""
function small_world_ness_Telesford(graph::AbstractGraph)
    small_world_ness_Telesford(graph, characteristic_length_ER(graph), global_clustering_coefficient_Latt(graph))
end
function small_world_ness_Telesford(graph::AbstractGraph, L_ER::Real, C_Latt::Real)
    L_ER / characteristic_length(graph; cutoff=100) -
    global_clustering_coefficient(graph) / C_Latt
end


""" Calculate the characteristic length (average shortest path) of a graph."""
function characteristic_length1(graph::AbstractGraph; cutoff::Real=Inf)
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


function characteristic_length(graph::AbstractGraph; cutoff::Real=1000., distmx::AbstractMatrix=weights(graph))
    dists = clamp.(LightGraphs.Parallel.floyd_warshall_shortest_paths(graph, distmx).dists, 0., cutoff)
    # clamp!(dists, 0., cutoff)
    return sum(dists) / (nv(graph) * (nv(graph) - 1))
end



function characteristic_length3(graph::AbstractGraph; cutoff::Real=1000., distmx::AbstractMatrix=weights(graph))
    L = sum(clamp.(LightGraphs.Parallel.dijkstra_shortest_paths(graph,collect(1:nv(graph))).dists, 0., cutoff))
    return L / (nv(graph) * (nv(graph) - 1))
end

"""
Average path length of ER network as in 10.1103/PhysRevE.70.056110 .
"""
characteristic_length_ER(g::AbstractGraph) = characteristic_length_ER(nv(g), ne(g))
characteristic_length_ER(n::Integer, k::Real) = characteristic_length_ER(n, round(Integer, n / (2k)))
characteristic_length_ER(n::Integer, m::Integer) = (log(n) - Base.MathConstants.eulergamma) / log((2 * m) / n) + 0.5



"""
clustering coefficient of an erdos renyi graph is equal to <k>/(n-1),
because the probability of any vertex to be connected to any other vertex is the
same and equal to the existence of any link. """
global_clustering_coefficient_ER(g::AbstractGraph) = global_clustering_coefficient_ER(nv(g), ne(g))
global_clustering_coefficient_ER(n::Integer, k::Real) = global_clustering_coefficient_ER(n, round(Integer, k * n / 2))
global_clustering_coefficient_ER(n::Integer, m::Integer) = 2m / (n * (n - 1))



"""
clustering coefficient of a ring lattice with average degree k = 2m/n. Only
graphs with even k can be created, therefore the upper and lower even k lattices
are average with weights
"""
global_clustering_coefficient_Latt(g::AbstractGraph) = global_clustering_coefficient_Latt(nv(g), ne(g))
global_clustering_coefficient_Latt(n::Integer, m::Integer) = global_clustering_coefficient_Latt(n, 2m / n)
function global_clustering_coefficient_Latt(n::Integer, k::Real)
    0.5 * (2 - k % 2) * global_clustering_coefficient(watts_strogatz(n, 2*round(Integer, k/2, RoundDown), 0.)) +
    0.5 * (k % 2) * global_clustering_coefficient(watts_strogatz(n, 2*round(Integer, k/2, RoundUp), 0.))
end
