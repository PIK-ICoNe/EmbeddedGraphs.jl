using EmbeddedGraphs, Test

@testset "greet" begin
    @test greet() == println("Hello World!")
end
