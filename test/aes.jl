using ImplementingTLS

@testset "rotate_word" begin
    word = BitVector([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    rotated_word = aes.rotate_word(word)
    @test rotated_word == BitVector([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0])
end

@testset "sub_byte" begin
    byte = BitVector([1, 0, 0, 0, 0, 0, 1, 1])
    substitute = aes.sub_byte(byte)
    @test substitute == BitVector([0, 0, 0, 0, 0, 1, 1, 1])
end

@testset "sub_word!" begin
    word = BitVector([1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1])
    aes.sub_word!(word)
    @test word == BitVector([0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0])
end