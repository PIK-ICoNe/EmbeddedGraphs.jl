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

"""Constructor functions for the EmbeddedGraph structure"""
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
"""
    Weights function gives back the weightmatrix of the graph.
    It can be choosen whether the matrix should be dense, i.e. the distance
    between every vertex is inserted, or sparse, i.e. only the distance
    between connected vertices is given back.
"""
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

"""
    Extends Base.getindex function to be able to call g[i,j]. Returns the
    distance of the two vertices in the metric of the graph.
"""
Base.getindex(eg::EmbeddedGraph, i, j) = eg.distance(i, j)
Base.getindex(eg::EmbeddedGraph, I::CartesianIndex{2}) = eg.distance(Tuple(I)...)


""" Adds vertex in the given graph. Position in the form [x,y,z,...] needed."""
function add_vertex!(g::EmbeddedGraph, pos::Array, args...)
    add_vertex!(g.graph, args...)
    push!(g.vertexpos, pos)
end

""" Adds multiple vertices in the given graph at once. Position Array is needed."""
function add_vertices!(g::EmbeddedGraph, pos::Array, args...)
    for i in pos
        add_vertex!(g, pos, args...)
    end
end

""" Removes multiple vertices with given Indices at once"""
function rem_vertices!(g::EmbeddedGraph, vs::AbstractVector{<:Integer}, args...)
    for i in vs
        rem_vertex!(g, i, args...)
    end
end

"""
    Extends LightGraphs function and deletes also the element in the
    g.vertexpos array
"""
function rem_vertex!(g::EmbeddedGraph, vs::Integer, args...)
    rem_vertex!(g.graph, vs, args...)
    deleteat!(g.vertexpos, vs)
end

"""Extends the Base.rand function to work with a SimpleEdgeIter"""
Base.rand(e::LightGraphs.SimpleGraphs.SimpleEdgeIter) = rand(collect(e))

"""
    Functions return an array with the value of the vertices in the given spatial direction
    1 == x direction, 2 == y direction, 3 == z direction ...
"""
vertices_loc(graph::EmbeddedGraph, spatial_dir::Int) = map(i->graph.vertexpos[i][spatial_dir], 1:nv(graph))

"""Extends basic LightGraphs functions to work with EmbeddedGraphs"""
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

# The following four are not in the Developer Documentation
is_directed(::Type{EmbeddedGraph{T, U}}) where T <: Integer where U = false
zero(g::EmbeddedGraph) = EmbeddedGraph(SimpleGraph(0), [], euclidean)
edgetype(g::EmbeddedGraph) = LightGraphs.SimpleEdge
# The following is not in LightGraphs Interface jl
# edgetype(::EmbeddedGraph{T,U}) where T <: Integer where U = LightGraphs.SimpleEdge{T}
