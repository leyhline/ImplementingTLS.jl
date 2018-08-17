using Test
using ImplementingTLS

@testset "des" begin
    @testset "permute" begin
        source = repeat(BitArray([1,0]), 32)
        shouldBeTarget = vcat(falses(32), trues(32))
        target = des.permute(source, des.ipTable)
        @test target == shouldBeTarget
        backToSource = des.permute(target, des.fpTable)
        @test backToSource == source
    end
end
