using EmbeddedGraphs, Test

@testset "testing the constructor" begin
    import LightGraphs: barabasi_albert
    import Distances: Haversine, Euclidean
    g = barabasi_albert(20, 3)
    pos = [rand(2) for i in 1:20]
    eg = EmbeddedGraph(g, pos)

    @test eg.graph == g
    @test eg.vertexpos == pos
    @test eg.distance == euclidean

    @test eg.distance(1, 1) == 0
    @test eg.distance(1, 2) == eg.distance(2, 1)

    eg = EmbeddedGraph(g, pos, Euclidean())
    @test eg.distance(1, 1) == 0
    @test eg.distance(1, 2) == eg.distance(2, 1)

    # alternatively, use the great-circle distance
    earth_radius = 6.3781e3 # km
    eg = EmbeddedGraph(g, pos, Haversine(earth_radius))
    @test eg.distance(pos[1], pos[1]) == 0
    @test eg.distance(pos[1], pos[2]) == eg.distance(pos[2], pos[1])

end
