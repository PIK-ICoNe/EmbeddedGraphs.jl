using LightGraphs
using Distances
using SparseArrays
import LightGraphs: edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
                    is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
                    add_edge!, add_vertex!, add_vertices!, rem_vertex!
import Base: getindex, eltype, rand

"""
    EmbeddedGraph{T<:Integer, U} <: AbstractGraph{T}

Embedded Graph
"""
struct EmbeddedGraph{T<:Integer, U} <: AbstractGraph{T}
    graph::SimpleGraph{T}
    vertexpos::Array{U, 1}
    distance::Function
end

"""
    Euclidean distance
"""
# function euclidean(pos1, pos2)
#     evaluate(Euclidean(), pos1, pos2)
# end

function EmbeddedGraph(graph::SimpleGraph, vertexpos::Array)
    EmbeddedGraph(graph, vertexpos, (i, j) -> euclidean(vertexpos[i], vertexpos[j]))
end

function EmbeddedGraph(graph::SimpleGraph, vertexpos::Array, distance::Function)
    EmbeddedGraph(graph, vertexpos, (i, j) -> distance(vertexpos[i], vertexpos[j]))
end

function EmbeddedGraph(graph::SimpleGraph, vertexpos::Array, distance::Metric)
    EmbeddedGraph(graph, vertexpos, (i, j) -> evaluate(distance, vertexpos[i], vertexpos[j]))
end

# Our first design is to make g indexable to get distances
# weights(g::EmbeddedGraph) = g
# Distance is constructed with a sparse matrix
function weights(g::EmbeddedGraph; dense::Bool=false)
    if dense
        A = zeros(nv(g), nv(g))
        for i in 1:nv(g)-1
            for j in i:nv(g)
                A[i,j] = A[j,i] = distance(g.vertexpos[i], g.vertexpos[j])
            end
        end
    else
        A = spzeros(nv(g),nv(g))
        for ed in edges(g.graph)
            A[src(ed), dst(ed)] = A[dst(ed), src(ed)] = distance(g.vertexpos[src(ed)], g.vertexpos[dst(ed)])
        end
    end
    A
end



function distance(pos1, pos2)
    evaluate(Euclidean(), pos1, pos2)
end

function vertices_loc_x(graph::EmbeddedGraph)
    map(i->graph.vertexpos[i][1], 1:nv(graph))
end

function vertices_loc_y(graph::EmbeddedGraph)
    map(i->graph.vertexpos[i][2], 1:nv(graph))
end

function Base.getindex(eg::EmbeddedGraph, i, j)
    eg.distance(i, j)
end

function Base.getindex(eg::EmbeddedGraph, I::CartesianIndex{2})
    eg.distance(Tuple(I)...)
end


function add_vertex!(g::EmbeddedGraph, pos::Array, args...)
    add_vertex!(g.graph, args...)
    push!(g.vertexpos, pos)
end

function add_vertices!(g::EmbeddedGraph, pos::Array, args...)
    for i in pos
        add_vertex!(g, pos, args...)
    end
end

function rem_vertices!(g::EmbeddedGraph, vs::AbstractVector{<:Integer}, args...)
    for i in vs
        rem_vertex!(g, i,args...)
    end
end

function rem_vertex!(g::EmbeddedGraph, vs::Integer, args...)
    rem_vertex!(g.graph, vs, args...)
    deleteat!(g.vertexpos, vs)
end


edges(g::EmbeddedGraph, args...) = LightGraphs.edges(g.graph, args...)
Base.eltype(g::EmbeddedGraph, args...) = Base.eltype(g.graph, args...)
has_edge(g::EmbeddedGraph, args...) = LightGraphs.has_edge(g.graph, args...)
has_vertex(g::EmbeddedGraph, args...) = has_vertex(g.graph, args...)
inneighbors(g::EmbeddedGraph, args...) = inneighbors(g.graph, args...)
ne(g::EmbeddedGraph, args...) = ne(g.graph, args...)
nv(g::EmbeddedGraph, args...) = nv(g.graph, args...)
outneighbors(g::EmbeddedGraph, args...) = outneighbors(g.graph, args...)
vertices(g::EmbeddedGraph, args...) = vertices(g.graph, args...)
is_directed(g::EmbeddedGraph, args...) = false
is_directed(::Type{EmbeddedGraph}) = false
add_edge!(g::EmbeddedGraph, args...) = add_edge!(g.graph,args...)
rem_edge!(g::EmbeddedGraph, args...) = rem_edge!(g.graph,args...)
rand(e::LightGraphs.SimpleGraphs.SimpleEdgeIter) = rand(collect(e))



# The following four are not in the Developer Documentation
is_directed(::Type{EmbeddedGraph{T, U}}) where T <: Integer where U = false
zero(g::EmbeddedGraph) = EmbeddedGraph(SimpleGraph(0), [], distance)
edgetype(g::EmbeddedGraph) = LightGraphs.SimpleEdge
# The following is not in LightGraphs Interface jl
edgetype(::EmbeddedGraph{T,U}) where T <: Integer where U = LightGraphs.SimpleEdge{T}
