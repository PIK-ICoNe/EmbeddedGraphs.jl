import LightGraphs: edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
                    is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
                    add_edge!, add_vertex!, add_vertices!, rem_vertex!
                    # rem_vertices!
import Base: getindex, eltype, rand

abstract type AbstractEmbeddedGraph{T} <: AbstractGraph{T} end

# Our first design is to make g indexable to get distances
# weights(EG::EmbeddedGraph) = EG
# Distance is constructed with a sparse matrix
"""
    Weights function gives back the weightmatrix of the graph.
    It can be choosen whether the matrix should be dense, i.e. the distance
    between every vertex is inserted, or sparse, i.e. only the distance
    between connected vertices is given back.
"""
function weights(EG::AbstractEmbeddedGraph; dense::Bool = false)
    if dense
        A = zeros(nv(EG), nv(EG))
        for i in 1:nv(EG) - 1
            for j in i:nv(EG)
                A[i,j] = A[j,i] = EG[i,j]
            end
        end
    else
        A = spzeros(nv(EG), nv(EG))
        for edge in edges(EG.graph)
            A[src(edge), dst(edge)] = A[dst(edge), src(edge)] = EG[src(edge), dst(edge)]
        end
    end
    A
end


""" Adds vertex in the given graph. Position in the form [x,y,z,...] needed."""
function add_vertex!(EG::AbstractEmbeddedGraph, pos::Array, args...)
    add_vertex!(EG.graph, args...)
    push!(EG.vertexpos, pos)
end

""" Adds multiple vertices in the given graph at once. Position Array is needed."""
function add_vertices!(EG::AbstractEmbeddedGraph, pos::Array, args...)
    for i in pos
        add_vertex!(EG, pos, args...)
    end
end

"""
    Extends LightGraphs function and deletes also the element in the
    EG.vertexpos array. rem_vertex! in LightGraphs swaps the vertex v with
    the last vertex and then uses pop! on the list to delete the last element.
"""
function rem_vertex!(EG::AbstractEmbeddedGraph, v::Integer, args...)
    rem_vertex!(EG.graph, v, args...)
    EG.vertexpos[v] = EG.vertexpos[end]
    pop!(EG.vertexpos)
end

""" Removes multiple vertices with given Indices at once"""
function rem_vertices!(EG::AbstractEmbeddedGraph, vs::AbstractVector{<:Integer}, args...)
    for i in vs
        rem_vertex!(EG, i, args...)
    end
end

"""
Functions return an array with the value of the vertices in the given spatial direction
1 == x direction, 2 == y direction, 3 == z direction ...
"""
vertices_loc(EG::AbstractEmbeddedGraph, spatial_dir::Int) = map(i -> EG.vertexpos[i][spatial_dir], 1:nv(EG))

"""
Extends Base.getindex function to be able to call EG[i,j]. Returns the
distance of the two vertices in the metric of the graph.
"""
Base.getindex(EG::AbstractEmbeddedGraph, i::Integer, j::Integer) = EG.distance(i, j)
Base.getindex(EG::AbstractEmbeddedGraph, I::CartesianIndex{2}) = EG.distance(Tuple(I)...)
Base.getindex(EG::AbstractEmbeddedGraph, i::Integer) = EG.vertexpos[i]


"""Extends the Base.rand function to work with a SimpleEdgeIter"""
Base.rand(edge_iter::LightGraphs.SimpleGraphs.SimpleEdgeIter) = rand(collect(edge_iter))

"""Extends basic LightGraphs functions to work with AbstractEmbeddedGraphs"""
SimpleGraph(EG::AbstractEmbeddedGraph) = EG.graph
edges(EG::AbstractEmbeddedGraph, args...) = LightGraphs.edges(EG.graph, args...)
Base.eltype(EG::AbstractEmbeddedGraph, args...) = Base.eltype(EG.graph, args...)
has_edge(EG::AbstractEmbeddedGraph, args...) = LightGraphs.has_edge(EG.graph, args...)
has_vertex(EG::AbstractEmbeddedGraph, args...) = has_vertex(EG.graph, args...)
inneighbors(EG::AbstractEmbeddedGraph, args...) = inneighbors(EG.graph, args...)
ne(EG::AbstractEmbeddedGraph, args...) = ne(EG.graph, args...)
nv(EG::AbstractEmbeddedGraph, args...) = nv(EG.graph, args...)
outneighbors(EG::AbstractEmbeddedGraph, args...) = outneighbors(EG.graph, args...)
vertices(EG::AbstractEmbeddedGraph, args...) = vertices(EG.graph, args...)
is_directed(EG::AbstractEmbeddedGraph, args...) = false
is_directed(::Type{<:AbstractEmbeddedGraph}) = false
add_edge!(EG::AbstractEmbeddedGraph, args...) = add_edge!(EG.graph, args...)
rem_edge!(EG::AbstractEmbeddedGraph, args...) = rem_edge!(EG.graph, args...)

# The following four are not in the Developer Documentation
is_directed(::Type{AbstractEmbeddedGraph{T}}) where T <: Integer = false
# edgetype(EG::AbstractEmbeddedGraph) = edgetype(EG.graph)
# The following is not in LightGraphs Interface jl
edgetype(::AbstractEmbeddedGraph{T}) where T <: Integer = LightGraphs.SimpleEdge{T}

# This should return a method for a concrete type and not AbstractEmbeddedGraph()
zero(eg::EG) where EG <: AbstractEmbeddedGraph = zero(EG)
