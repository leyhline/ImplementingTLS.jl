using Test
using ImplementingTLS

@testset "int_to_bitvector" begin
    allfalse = des.int_to_bitvector(0, 8)
    @test falses(8) == allfalse
    alltrue = des.int_to_bitvector(255, 8)
    @test trues(8) == alltrue
end

@testset "permute" begin
    source = repeat(BitVector([1,0]), 32)
    shouldbe_target = vcat(falses(32), trues(32))
    target = des.permute(source, des.iptable)
    @test target == shouldbe_target
    back_to_source = des.permute(target, des.fptable)
    @test back_to_source == source
end

@testset "rotatekey" begin
    key = BitVector([0,1,1,0,0,0,0,1,0,1,1,0,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,0,
                    0,1,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1])
    rotated = BitVector([1,1,0,0,0,0,1,0,1,1,0,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,0,0,
                        1,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0])
    rotateleft = des.rotatekey(key, -1)
    @test rotateleft == rotated
    rotateback = des.rotatekey(rotateleft, 1)
    @test rotateback == key
end

@testset "blockoperate" begin
    plaintext = "hallo du"
    key = "abcdefgh"
    ciphertext = des.blockoperate(plaintext, key, des.encrypt)
    decrypted = des.blockoperate(ciphertext, key, des.decrypt)
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
