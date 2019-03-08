"""
Define characteristic quantities for spatial networks from
    https://arxiv.org/pdf/1010.0302.pdf
"""

import LightGraphs: dijkstra_shortest_paths

function detour_indices(eg::EmbeddedGraph, i)
    weight_matrix = zeros(nv(eg), nv(eg))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = eg[I]
    end
    paths = dijkstra_shortest_paths(eg.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / eg.distance(i, j) for j in 1:nv(eg)]
end
