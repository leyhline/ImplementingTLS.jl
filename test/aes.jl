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

@testset "sub_word" begin
    word = BitVector([1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1])
    new_word = aes.sub_word(word)
    @test new_word == BitVector([0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0])
end

@testset "compute_key_schedule" begin
    key256bit = BitVector([
        0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0,
        1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1,
        1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0,
        0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0,
        0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0,
        1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0,
        0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0
    ])
    key_schedule = aes.compute_key_schedule(key256bit)
    @test size(key_schedule) == (32, 60)
    @test key_schedule == BitArray([
        0 1 1 0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 0 0 0 0 1 1 0 0 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 1 1 1 1 0 0;
        0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 1 1 1 0 1 1 1 0 0 1 0 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 1 0 1 0 1 1 0 1 0 1;
        0 0 1 0 0 1 1 1 1 1 0 0 0 1 0 1 0 1 1 0 0 1 1 1 1 0 1 0 0 1 0 1 0 0 1 1 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0;
        0 1 1 1 0 1 1 0 0 1 0 1 1 0 1 1 1 0 0 0 1 1 0 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 1 1 1 1 0 1 0 1 1 0 1 0 0 1 1 0 1;
        0 1 0 1 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 1 0 0 1 1 1 0 0 1 1 1 0 0 1 1 1 1 0 1 1 0 1 0 1 0 0 1 0 0 1 1 0 1 1 0 0 0 1 0 0 0;
        0 1 1 0 1 0 0 1 1 0 1 0 1 1 1 1 0 0 1 1 0 1 0 0 0 0 1 1 1 0 0 1 1 1 0 0 1 1 1 1 0 1 1 1 0 1 0 1 1 0 1 1 1 0 0 0 1 1 0 1;
        1 1 0 0 1 0 1 0 1 0 0 0 1 1 0 0 1 1 1 1 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0;
        0 0 0 1 1 0 0 1 1 1 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 1 0;
        1 0 0 0 0 1 0 1 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 1 1 1;
        0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 0 1 1 1 1 0 1 0 0 0 1 0 1 0 1 1 1 0 1 1 0 0 1 0 1 0 1 0 0 0 1 1 0 1;
        1 1 0 1 0 0 1 1 0 1 1 0 0 0 1 0 0 1 0 0 0 0 1 1 1 0 0 0 0 0 1 0 1 1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 1 0 0 1 1 0 1 1 0 0 0 0;
        1 1 0 1 1 0 1 1 0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 0 0 0 1 0 1 1 0 0 1 1 0 0 0 1 1 1 0 1 1 1 0;
        0 1 1 1 0 1 1 0 0 1 0 1 1 0 1 0 0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 1 1 0 0 1 0 0 0 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 1 1 1 1;
        0 0 0 0 0 0 1 1 1 1 1 0 0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 1 0 1 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 1 1 0 1;
        1 0 1 1 1 1 0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 0 1 1 0 1 1 1 0 0 0 1 1 0 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0 0;
        1 0 0 0 1 1 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 1 0 1 1 1 1 1 1 0 0 1 1 0 1 0 0 0 0 1 1 1 0 0 1 1 1 0 0 1 1 1 1;
        1 1 0 1 0 1 0 0 1 0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0 0 1 0 1 1 1 1 1 0 1 1 0 0 1 0 1 0 1 0 0 0 1 1 0 0 1 1 1 1;
        1 1 0 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 1;
        0 0 1 1 1 0 1 0 0 0 1 0 1 1 0 0 0 0 1 0 1 0 0 1 1 1 0 0 1 1 1 1 0 1 1 1 0 1 0 1 1 0 1 1 1 0 0 0 1 1 0 0 1 1 1 0 1 0 0 0;
        1 1 0 1 1 0 1 1 0 1 1 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 1 0 0 0 1 0 0 1 0 1 1 1 0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 1 0 1 1 1 1 1;
        1 1 1 1 0 0 1 0 1 0 1 1 1 1 0 1 0 0 1 1 0 1 1 1 1 1 0 0 0 1 0 1 0 1 1 1 1 0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 0 1 1 0 1 1 0;
        1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 1 1 1 0 0 1 0 1 1 0 1 1 0 1 1 0 0 0 1 0 0 1 0 0 0 0 1 1 0 1 1 1 0 0 1 0 1 0 1 0 1 1 0 0 1;
        0 1 1 1 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0 1 1 0 1 1 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 1 0 1 1 0 1 0 1 0 0 1 0;
        1 0 0 1 1 1 0 0 1 1 1 1 0 1 1 1 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0 1 1 0 1 1 0 0 0 1 0 0 1 0 0 0 0 1 1 1 0 0 0 0 0 0 1 0 0 1;
        0 1 0 1 1 1 1 0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1 1 1 1;
        0 1 0 0 0 1 1 0 0 1 1 1 1 0 1 0 0 1 0 0 1 1 0 0 0 1 1 0 1 0 0 0 0 1 0 1 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
        1 1 0 0 1 0 0 1 0 1 1 0 1 1 1 0 0 1 0 1 0 1 0 1 1 0 0 0 0 1 1 0 1 1 1 0 0 1 0 1 0 1 0 1 1 0 0 1 1 0 0 0 1 1 1 0 1 1 1 1;
        1 1 1 0 0 1 0 0 1 0 1 0 0 1 1 0 1 1 0 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 0 0 1 1 1 1 1 1 1 1 0 1 0 0 1 0 1 0 0 1 1 1 0 0 1 0;
        0 0 1 0 0 1 0 1 1 1 0 0 0 1 1 1 0 1 1 1 1 0 1 1 1 0 1 1 0 0 1 1 0 0 1 1 1 1 0 1 1 1 0 0 1 0 0 1 0 1 1 0 1 1 1 1 1 0 1 1;
        0 0 0 1 0 0 1 0 0 0 0 1 1 1 0 1 1 1 1 1 0 1 1 0 1 0 1 1 1 0 1 1 0 0 1 0 1 1 0 1 1 1 0 1 0 1 1 0 1 0 0 1 1 0 1 0 1 1 1 1;
        0 0 1 1 0 1 0 1 1 1 0 1 1 0 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 1 1 0 1 0 0 1 0 1 1 1 0 0 0 1 1 0 0 1 1 1 1 0 1 1 0 1 0 1 1;
        0 1 0 0 1 0 0 0 0 1 1 0 1 1 1 0 0 1 0 0 1 0 1 0 0 1 1 0 1 1 0 1 1 0 1 1 0 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 0 0 1 1 0 0 0 0
    ])
end

@testset "blockencrypt" begin
    input = "hallo wie gehts?"
    key = "abcdefghijklmnopqrstuvwxyzjuchee"
    aes.blockencrypt(input, key)
end