using Test
using Random
using LightGraphs
using SparseArrays
import Distances: Haversine, Euclidean

using EmbeddedGraphs

Random.seed!(42)

n = 50
g = barabasi_albert(n, 3)
pos = [rand(2) for i in 1:n]
eg = EmbeddedGraph(copy(g), pos)
earth_radius = 6.3781e3 # km

@testset "testing the constructor" begin
    @test eg.graph == g
    @test eg.vertexpos == pos

    @test eg.distance(1, 1) == 0
    @test eg.distance(1, 2) == eg.distance(2, 1)

    eg2 = EmbeddedGraph(g, pos, Euclidean())
    @test eg2.distance(1, 1) == 0
    @test eg2.distance(1, 2) == eg2.distance(2, 1)

    # alternatively, use the great-circle distance
    eg3 = EmbeddedGraph(g, pos, Haversine(earth_radius))
    @test eg3.distance(1, 1) == 0
    @test eg3.distance(1, 2) == eg3.distance(2, 1)
end

@testset "testing method extensions" begin
    @test nv(eg) == nv(g)
    @test ne(eg) == ne(g)
    @test outneighbors(eg, 1) == outneighbors(g, 1)
    @test inneighbors(eg, 1) == inneighbors(g, 1)
    @test has_vertex(eg, 1) == has_vertex(g, 1)
    @test has_edge(eg, 1, 2) == has_edge(g, 1, 2)
    @test is_directed(eg) == is_directed(g)
    # element type should be Int
    @test eltype(eg) == eltype(g)
    @test eltype(eg) <: Int
    @test vertices(eg) == vertices(g)
    @test edges(eg) == edges(g)
end

@testset "testing weights function" begin
    @test typeof(weights(eg)) <: SparseMatrixCSC
    @test all([iszero(eg[i, i]) for i in 1:nv(eg)])
    @test eg[1, 2] == eg[2, 1]
    # test cartesian indexing
    @test eg[CartesianIndex(1, 1)] == 0
end

@testset "testing additional method extensions" begin
    @test typeof(zero(eg)) <: EmbeddedGraph
    @test edgetype(eg) == edgetype(g)
end

@testset "testing the removal/addition of vertices" begin
    add_vertex!(eg, rand(2))
    @test nv(eg) == nv(g) + 1
    rem_vertex!(eg, 2)
    @test nv(eg) == nv(g)

end
@testset "testing the correct location functions" begin
    @test vertices_loc(eg, 1)[1] == pos[1][1]
    @test vertices_loc(eg, 2)[10] == pos[10][2]
end

@testset "testing characteristics" begin
    di = detour_indices(eg, 1)
    @test isnan(di[1])
end

@testset "testing random_geometric_graph" begin
    rad = 0.15 # set threshold radius

    rg = random_geometric_graph(n, rad; pos=pos)

    @test all(weights(rg) .< rad)

    eg_complete = EmbeddedGraph(complete_graph(n), pos)
    random_geometric_graph!(eg_complete, rad)

    @test eg_complete.graph.fadjlist == rg.graph.fadjlist

    rg3d = random_geometric_graph(n, rad; dim=3)

    @test all(weights(rg3d) .< rad)
    @test all(length.(rg3d.vertexpos) .== 3)

    # this graph should be identical to rg with the same weights
    rgm = random_geometric_graph(n, rad; pos=pos, dist_func=Euclidean())

    @test rg.graph.fadjlist == rgm.graph.fadjlist
    @test weights(rg) == weights(rgm)

    # the edge weights and the spatial distance can be distinct
    eg_haver = EmbeddedGraph(complete_graph(n), pos, Haversine(earth_radius))
    random_geometric_graph!(eg_haver, rad; dist_func=Euclidean())

    @test rg.graph.fadjlist == eg_haver.graph.fadjlist
    @test weights(rg) != weights(eg_haver)
end
