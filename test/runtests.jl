using Test
using ImplementingTLS

@testset "des" begin
    @testset "permute" begin
        source = repeat(BitVector([1,0]), 32)
        shouldBeTarget = vcat(falses(32), trues(32))
        target = des.permute(source, des.ipTable)
        @test target == shouldBeTarget
        backToSource = des.permute(target, des.fpTable)
        @test backToSource == source
    end
    @testset "rotateKey" begin
        key = BitVector([0,1,1,0,0,0,0,1,0,1,1,0,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,0,
                        0,1,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1])
        rotated = BitVector([1,1,0,0,0,0,1,0,1,1,0,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,0,0,
                            1,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0])
        rotateLeft = des.rotateKey(key, -1)
        @test rotateLeft == rotated
        rotateBack = des.rotateKey(rotateLeft, 1)
        @test rotateBack == key
    end
    @testset "blockOperate" begin
        plaintext = "hallo du"
        key       = "abcdefgh"
        ciphertext = des.blockOperate(plaintext, key, des.encrypt)
        decrypted = des.blockOperate(ciphertext, key, des.decrypt)
        @test decrypted == plaintext
    end
end
