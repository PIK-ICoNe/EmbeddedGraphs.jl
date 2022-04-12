"""
    EmbeddedGraph{T<:Integer, T2 <:AbstractFloat} <: AbstractEmbeddedGraph{T}

Embedded Graph
"""
struct EmbeddedGraph{T<:Integer, T2<:AbstractFloat} <: AbstractEmbeddedGraph{T}
    graph::SimpleGraph{T}
    vertexpos::Vector{Vector{T2}}
    distance::Function
    function EmbeddedGraph{T, T2}(graph::SimpleGraph{T}, vertexpos::Vector{Vector{T2}}, distance::Function) where {T <: Integer, T2 <: AbstractFloat}
        new(graph, vertexpos, distance)
    end
end

"""Constructor functions for the EmbeddedGraph structure"""
function EmbeddedGraph(graph::SimpleGraph{T}, vertexpos::Vector{Vector{T2}}, distance::Function) where {T <: Integer, T2 <: AbstractFloat}
    EmbeddedGraph{T, T2}(graph, vertexpos, (i, j) -> distance(vertexpos[i], vertexpos[j]))
end

EmbeddedGraph(graph::SimpleGraph, vertexpos::Array) = EmbeddedGraph(graph, vertexpos, euclidean)
EmbeddedGraph(graph::SimpleGraph, vertexpos::Array, distance::Metric) = EmbeddedGraph(graph, vertexpos, (i, j) -> evaluate(distance, i, j))
EmbeddedGraph() = EmbeddedGraph(SimpleGraph(0), Vector{Vector{Float64}}())
EmbeddedGraph(graph::SimpleGraph) = EmbeddedGraph(graph, map(i->[rand(),rand()], 1:nv(graph)))
EmbeddedGraph(nv::Integer) = EmbeddedGraph(SimpleGraph(nv))

# the empty graph
zero(::Type{EmbeddedGraph{T}}) where T = EmbeddedGraph()