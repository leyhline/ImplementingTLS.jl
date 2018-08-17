using Test
using ImplementingTLS

@testset "des" begin
    @testset "getBit" begin
        testbyte = ByteVector([0b10101010, 0b00000000])
        @test des.getBit(testbyte, UInt(0)) > 0
        @test des.getBit(testbyte, UInt(1)) == 0
        @test des.getBit(testbyte, UInt(2)) > 0
        @test des.getBit(testbyte, UInt(3)) == 0
        @test des.getBit(testbyte, UInt(4)) > 0
        @test des.getBit(testbyte, UInt(5)) == 0
        @test des.getBit(testbyte, UInt(6)) > 0
        @test des.getBit(testbyte, UInt(7)) == 0
        @test des.getBit(testbyte, UInt(8)) == 0
        @test des.getBit(testbyte, UInt(9)) == 0
        @test_throws BoundsError des.getBit(testbyte, UInt(16))
    end
    @testset "setBit!" begin
        testbyte = ByteVector([0b10101010])
        des.setBit!(testbyte, UInt(1))
        @test testbyte[1] == 0b11101010
    end
    @testset "clearBit!" begin
        testbyte = ByteVector([0b10101010])
        des.clearBit!(testbyte, UInt(0))
        @test testbyte[1] == 0b00101010
    end
end
