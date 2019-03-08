using Revise
using LightGraphs
using Random
using Test

dir = @__DIR__
push!(LOAD_PATH,"$dir/src/")
using EmbeddedGraphs

eg = EmbeddedGraph(barabasi_albert(20, 3), [rand(2) for i in 1:20])
adjacency_matrix(eg)

eg[1,2]

weg = weights(eg)

weg[2,3]

# These don't work though, because contrary to the documentation, it is not
# sufficient for the result of weights to be indexable, these functions expect
# AbstractMatrix
@test_throws MethodError kruskal_mst(eg)
@test_throws MethodError prim_mst(eg)
@test_throws MethodError closeness_centrality(eg)

# Workaround
begin
    import Base.getindex, Base.size

    struct WM{T} <: AbstractMatrix{T}
        eg::EmbeddedGraph
    end

    function Base.getindex(wm::WM, i, j)
        wm.eg.distance(i, j)
    end

    function Base.size(wm::WM)
        size(wm.eg.graph)
    end
end

w = WM{Real}(eg)

# Actually it expects an AbstractMatrix{Real}, with this it works:
kruskal_mst(eg, w)
# But these two don't work because they use typemax
@test_throws MethodError closeness_centrality(eg, w)
@test_throws MethodError prim_mst(eg, w)

# Finally this works:
w = WM{Float32}(eg)
closeness_centrality(eg, w)
prim_mst(eg, w)
