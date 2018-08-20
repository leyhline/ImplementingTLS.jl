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
        key = "abcdefgh"
        ciphertext = des.blockOperate(plaintext, key, des.encrypt)
        decrypted = des.blockOperate(ciphertext, key, des.decrypt)
        @test decrypted == plaintext
    end
    @testset "operate" begin
        plaintext = "hallo du wie geht es dir"
        iv = repeat('\0', 8)
        key = "abcdefgh"
        @test_throws AssertionError des.operate("hallo du wie geht es", iv, key, des.encrypt, false)
        ciphertext = des.operate(plaintext, iv, key, des.encrypt, false)
        decrypted = des.operate(ciphertext, iv, key, des.decrypt, false)
        @test decrypted == plaintext
        key3x = "twentyfourcharacterinput"
        ciphertext3x = des.operate(plaintext, iv, key3x, des.encrypt, true)
        decrypted3x = des.operate(ciphertext3x, iv, key3x, des.decrypt, true)
        @test decrypted3x == plaintext
    end
end
