module utils

export string_to_bitvector, bitvector_to_string, bitvector_to_int, int_to_bitvector

string_to_bitvector(input::String) = vcat(map(int_to_bitvector, transcode(UInt8, input), Iterators.cycle(8))...)

bitvector_to_string(bits::BitVector) = transcode(String, map(UInt8, vec(mapslices(bitvector_to_int, reshape(bits, 8, length(bits)÷8), dims=1))))

bitvector_to_int(bits::BitVector) = sum(map((i,x) -> x ? 2^i : 0, length(bits)-1:-1:0, bits))

function int_to_bitvector(x, padding)
    bits = BitVector(undef, padding)
    for i in padding:-1:1
        bits[i] = x & 0x1
        x >>= 1
    end
    return bits
end

end