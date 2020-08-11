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

""" Calculate the sum of all the weights of the edges of a graph. """
function wiring_length(EG::AbstractEmbeddedGraph; distmx::AbstractMatrix=weights(EG))
    return sum(distmx) / 2. / ne(EG)
end

