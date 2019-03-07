module EmbeddedGraphs

  using LightGraphs
  using Distances

  import LightGraphs.edges, Base.getindex, Base.eltype, LightGraphs.ne, LightGraphs.nv,
          LightGraphs.has_edge, LightGraphs.has_vertex,
          LightGraphs.outneighbors, LightGraphs.vertices,
          LightGraphs.is_directed, LightGraphs.edgetype, LightGraphs.weights,
          LightGraphs.inneighbors

  export euclidean, weights, edges, EmbeddedGraph,
          has_edge, has_vertex, inneighbors, ne, nv, outneighbors,
          vertices, is_directed, add_vertex!, rem_vertex!, edgetype, euclidean

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
  function euclidean(pos1, pos2)
      evaluate(Euclidean(), pos1, pos2)
  end

  function EmbeddedGraph(graph, vertexpos)
      EmbeddedGraph(graph, vertexpos, euclidean)
  end

  # Our first design is to make g indexable to get distances
  weights(g::EmbeddedGraph) = g

  function Base.getindex(eg::EmbeddedGraph, i, j)
      eg.distance(eg.vertexpos[i], eg.vertexpos[j])
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

  # The following four are not in the Developer Documentation
  is_directed(::Type{EmbeddedGraph{T, U}}) where T <: Integer where U = false
  zero(g::EmbeddedGraph) = EmbeddedGraph(SimpleGraph(0), [], distance)
  edgetype(g::EmbeddedGraph) = LightGraphs.SimpleEdge
  # The following is not in LightGraphs Interface jl
  edgetype(::EmbeddedGraph{T,U}) where T <: Integer where U = LightGraphs.SimpleEdge{T}

  function add_vertex!(g::EmbeddedGraph, pos::Array, args...)
      add_vertex!(g.graph, args...)
      push!(g.vertexpos,pos)
  end

  function rem_vertex!(g::EmbeddedGraph, vs::AbstractVector{<:Integer};
  keep_order::Bool=true, args...)
      !keep_order && @warn("keep_order needs to be true!")
      rem_vertex!(g.graph, vs, true, args...)
      deleteat!(g.vertexpos, vs)
  end

end
