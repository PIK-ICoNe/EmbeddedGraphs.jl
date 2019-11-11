import LightGraphs: edges, ne, nv, has_edge, has_vertex, outneighbors, vertices,
                    is_directed, edgetype, weights, inneighbors, zero, rem_edge!,
                    add_edge!, add_vertex!, add_vertices!, rem_vertex!, rem_vertices!
import Base: getindex, eltype, rand

"""
    EmbeddedGraph{T<:Integer} <: AbstractGraph{T}

Embedded Graph
"""
struct EmbeddedGraph{T<:Integer} <: AbstractGraph{T}
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
# Our first design is to make g indexable to get distances
# weights(EG::EmbeddedGraph) = EG
# Distance is constructed with a sparse matrix
"""
    Weights function gives back the weightmatrix of the graph.
    It can be choosen whether the matrix should be dense, i.e. the distance
    between every vertex is inserted, or sparse, i.e. only the distance
    between connected vertices is given back.
"""
function weights(EG::EmbeddedGraph; dense::Bool=false)
    if dense
        A = zeros(nv(EG), nv(EG))
        for i in 1:nv(EG)-1
            for j in i:nv(EG)
                A[i,j] = A[j,i] = EG[i,j]
            end
        end
    else
        A = spzeros(nv(EG),nv(EG))
        for edge in edges(EG.graph)
            A[src(edge), dst(edge)] = A[dst(edge), src(edge)] = EG[src(edge), dst(edge)]
        end
    end
    A
end


""" Adds vertex in the given graph. Position in the form [x,y,z,...] needed."""
function add_vertex!(EG::EmbeddedGraph, pos::Array, args...)
    add_vertex!(EG.graph, args...)
    push!(EG.vertexpos, pos)
end

""" Adds multiple vertices in the given graph at once. Position Array is needed."""
function add_vertices!(EG::EmbeddedGraph, pos::Array, args...)
    for i in pos
        add_vertex!(EG, pos, args...)
    end
end

"""
    Extends LightGraphs function and deletes also the element in the
    EG.vertexpos array. rem_vertex! in LightGraphs swaps the vertex v with
    the last vertex and then uses pop! on the list to delete the last element.
"""
function rem_vertex!(EG::EmbeddedGraph, v::Integer, args...)
    rem_vertex!(EG.graph, v, args...)
    EG.vertexpos[v] = EG.vertexpos[end]
    pop!(EG.vertexpos)
end

""" Removes multiple vertices with given Indices at once"""
function rem_vertices!(EG::EmbeddedGraph, vs::AbstractVector{<:Integer}, args...)
    for i in vs
        rem_vertex!(EG, i, args...)
    end
end

"""
Functions return an array with the value of the vertices in the given spatial direction
1 == x direction, 2 == y direction, 3 == z direction ...
"""
vertices_loc(EG::EmbeddedGraph, spatial_dir::Int) = map(i -> EG.vertexpos[i][spatial_dir], 1:nv(EG))

"""
Extends Base.getindex function to be able to call EG[i,j]. Returns the
distance of the two vertices in the metric of the graph.
"""
Base.getindex(EG::EmbeddedGraph, i, j) = EG.distance(i, j)
Base.getindex(EG::EmbeddedGraph, I::CartesianIndex{2}) = EG.distance(Tuple(I)...)
Base.getindex(EG::EmbeddedGraph, i) = EG.vertexpos[i]

"""Extends the Base.rand function to work with a SimpleEdgeIter"""
Base.rand(edge_iter::LightGraphs.SimpleGraphs.SimpleEdgeIter) = rand(collect(edge_iter))

"""Extends basic LightGraphs functions to work with EmbeddedGraphs"""
edges(EG::EmbeddedGraph, args...) = LightGraphs.edges(EG.graph, args...)
Base.eltype(EG::EmbeddedGraph, args...) = Base.eltype(EG.graph, args...)
has_edge(EG::EmbeddedGraph, args...) = LightGraphs.has_edge(EG.graph, args...)
has_vertex(EG::EmbeddedGraph, args...) = has_vertex(EG.graph, args...)
inneighbors(EG::EmbeddedGraph, args...) = inneighbors(EG.graph, args...)
ne(EG::EmbeddedGraph, args...) = ne(EG.graph, args...)
nv(EG::EmbeddedGraph, args...) = nv(EG.graph, args...)
outneighbors(EG::EmbeddedGraph, args...) = outneighbors(EG.graph, args...)
vertices(EG::EmbeddedGraph, args...) = vertices(EG.graph, args...)
is_directed(EG::EmbeddedGraph, args...) = false
is_directed(::Type{EmbeddedGraph}) = false
add_edge!(EG::EmbeddedGraph, args...) = add_edge!(EG.graph,args...)
rem_edge!(EG::EmbeddedGraph, args...) = rem_edge!(EG.graph,args...)

# The following four are not in the Developer Documentation
is_directed(::Type{EmbeddedGraph{T}}) where T <: Integer = false
zero(EG::EmbeddedGraph) = EmbeddedGraph()
#edgetype(EG::EmbeddedGraph) = edgetype(EG.graph)
# The following is not in LightGraphs Interface jl
edgetype(::EmbeddedGraph{T}) where T <: Integer = LightGraphs.SimpleEdge{T}
