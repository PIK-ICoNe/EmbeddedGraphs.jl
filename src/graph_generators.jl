import LightGraphs: complete_graph

"""
    random_geometric_graph!(eg, radius; dist_func=Nothing)
From an existing embedded complete graph `eg`,
create a [random geometric graph](http://en.wikipedia.org/wiki/Random_geometric_graph)
by removing edges between vertices that are more than `radius` apart.
This in-place graph generator offers more flexibility with respect to
the properties of the resulting EmbeddedGraph instance `eg`.
For instance, the embedding metric determining the values of `weights(eg)`
can be distinct from the distance function `dist_func` that is used to  create
the random geometric graph.

Ref.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.

### Optional Arguments
- `dist_func`: distance function used to construct the random geometric graph. It can differ from the `distance` attribute of `eg` to allow for independent edge weights. Defaults to `eg.distance` when `dist_func=Nothing` is passed.
# Examples
```julia
julia> egh = EmbeddedGraph(complete_graph(n), pos, hamming);

julia> random_geometric_graph!(egh, rad; dist_func=euclidean)

julia> egh.graph
{50, 71} undirected simple Int64 graph
```
"""
function random_geometric_graph!(eg::AbstractEmbeddedGraph, radius::Real; dist_func=Nothing)

    @assert diameter(eg.graph) == 1 # check if eg is a complete graph.

    to_remove = []

    if dist_func == Nothing
        for edge in findall(weights(eg,dense=true) .> radius)
            push!(to_remove, edge)
        end
    else
        for edge in edges(eg)
            if dist_func(eg.vertexpos[src(edge)], eg.vertexpos[dst(edge)]) > radius
                push!(to_remove, edge)
            end
        end
    end

    for edge in to_remove
        rem_edge!(eg, Tuple(edge)...)
    end
end

"""
    random_geometric_graph(n, radius; dim=2, pos=Nothing, embedding_metric=Nothing, dist_func=Nothing)
Create a [random geometric graph](http://en.wikipedia.org/wiki/Random_geometric_graph)
with `n` vertices that are connected when their distance is less than `radius`.
The vertex locations are randomly drawn from a uniform distribution on the unit
interval in each dimension.

Ref.: Penrose, Mathew. Random geometric graphs. Vol. 5. Oxford university press, 2003.

### Optional Arguments
- `dim`: embedding dimension. Defaults to dim=2.
- `pos`: vertex positions can be given as a list of `n` points with `dim` coordinates. Defaults to pos=Nothing.
- `dist_func`: distance function used to construct the random geometric graph. It can differ from the `distance` attribute of `eg` to allow for independent edge weights. Defaults to `eg.distance` when `dist_func=Nothing` is passed.
# Examples
```julia
julia> random_geometric_graph(50, 0.2).graph
{50, 105} undirected simple Int64 graph
```
"""
function random_geometric_graph(n::Int,
                                radius::Real;
                                dim=2,
                                pos=Nothing,
                                dist_func=Nothing
                                )
    @assert radius > 0

    if pos == Nothing
        pos = [rand(dim) for _ in 1:n]
    else
        @assert length(pos) == n
    end

    eg = EmbeddedGraph(complete_graph(n), pos)

    random_geometric_graph!(eg, radius; dist_func=dist_func)

    return eg
end


"""Adds m shortest edges."""
function random_geometric!(eg::AbstractEmbeddedGraph, m::Integer)
    w = copy(weights(eg, dense=true))
    w[CartesianIndex.(1:nv(eg),1:nv(eg))] .= typemax(typeof(w[1]))
    for e in edges(eg)
        w[e.src,e.dst] = w[e.dst,e.src] = typemax(typeof(w[1]))
    end
    for i in 1:m
        index = findmin(w)[2]
        src, dst = index[1], index[2]
        w[src,dst] = w[dst,src] = typemax(typeof(w[1]))
        add_edge!(eg, src, dst)
    end
end

function random_geometric(n::Integer, m::Integer)
    g = EuclideanGraph(n)
    random_geometric!(g, m)
    g
end

"""Adds all edges shorter than r."""
function random_geometric!(eg::AbstractEmbeddedGraph, r::Real)
    for edge in findall(weights(eg, dense=true) .< r)
        edge[1]>=edge[2] && continue
        add_edge!(g, edge[1], edge[2])
    end
end

function random_geometric(n::Integer, r::Real)
    eg = EuclideanGraph(n)
    random_geometric!(eg, r)
    eg
end
