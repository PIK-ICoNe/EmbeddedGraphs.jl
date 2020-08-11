"""
    EmbeddedGraph{T<:Integer} <: AbstractEmbeddedGraph{T}

Embedded Graph
"""
struct EmbeddedGraph{T<:Integer} <: AbstractEmbeddedGraph{T}
    graph::SimpleGraph{T}
    vertexpos::Array
    distance::Function
    function EmbeddedGraph{T}(graph::SimpleGraph{T}, vertexpos::Array, distance::Function) where T <: Integer
        new(graph, vertexpos, distance)
    end
end

"""Constructor functions for the EmbeddedGraph structure"""
function EmbeddedGraph(graph::SimpleGraph{T}, vertexpos::Array, distance::Function) where T <: Integer
    EmbeddedGraph{T}(graph, vertexpos, (i, j) -> distance(vertexpos[i], vertexpos[j]))
end
EmbeddedGraph(graph::SimpleGraph, vertexpos::Array) = EmbeddedGraph(graph, vertexpos, euclidean)
EmbeddedGraph(graph::SimpleGraph, vertexpos::Array, distance::Metric) = EmbeddedGraph(graph, vertexpos, (i, j) -> evaluate(distance, i, j))
EmbeddedGraph() = EmbeddedGraph(SimpleGraph(0), [])
EmbeddedGraph(graph::SimpleGraph) = EmbeddedGraph(graph, map(i->[rand(),rand()], 1:nv(graph)))
EmbeddedGraph(nv::Integer) = EmbeddedGraph(SimpleGraph(nv))

# the empty graph
zero(::Type{EmbeddedGraph{T}}) where T = EmbeddedGraph()
