"""
EuclideanGraph{T<:Integer} <: AbstractEmbeddedGraph{T}

Euclidean Graph
"""
struct EuclideanGraph{T<:Integer} <: AbstractEmbeddedGraph{T}
    graph::SimpleGraph{T}
    vertexpos::Array
    function EuclideanGraph{T}(graph::SimpleGraph{T}, vertexpos::Array) where T <: Integer
        new(graph, vertexpos)
    end
end

"""Constructor functions for the EuclideanGraph structure"""
function EuclideanGraph(graph::SimpleGraph{T}, vertexpos::Array) where T <: Integer
    EuclideanGraph{T}(graph, vertexpos)
end
EuclideanGraph(graph::SimpleGraph) = EuclideanGraph(graph, map(i->[rand(),rand()], 1:nv(graph)))
EuclideanGraph(nv::Integer) = EuclideanGraph(SimpleGraph(nv))
EuclideanGraph() = EuclideanGraph(SimpleGraph(0), [])

"""
Extends Base.getindex function to be able to call EG[i,j]. Returns the
distance of the two vertices in the metric of the graph.
"""
Base.getindex(EG::EuclideanGraph, i::Integer, j::Integer) = euclidean(EG[i], EG[j])
Base.getindex(EG::EuclideanGraph, I::CartesianIndex{2}) = euclidean(EG[I[1]], EG[I[2]])


function detour_indices(EG::EuclideanGraph, i)
    weight_matrix = zeros(nv(EG), nv(EG))
    for I in CartesianIndices(weight_matrix)
        weight_matrix[I] = EG[I]
    end
    paths = dijkstra_shortest_paths(EG.graph, i, weight_matrix, allpaths=false)
    [paths.dists[j] / EG[i, j] for j in 1:nv(EG)]
end
