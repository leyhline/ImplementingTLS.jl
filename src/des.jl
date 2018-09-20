module des

const BLOCKSIZE = 64
const KEYSIZE = 56

@enum Op encrypt decrypt

function operate(input::String, iv::String, key::String, operation::Op, triplicate::Bool)
    inputvector = string_to_bitvector(input)
    @assert length(inputvector) % BLOCKSIZE == 0
    ivvector = string_to_bitvector(iv)
    @assert length(ivvector) == BLOCKSIZE
    keyvector = string_to_bitvector(key)
    @assert length(keyvector) == (triplicate ? 3BLOCKSIZE : BLOCKSIZE)
    output = BitVector(undef, length(inputvector))
    for i in 1:BLOCKSIZE:length(inputvector)
        inputblock = inputvector[i:i+BLOCKSIZE-1]
        if operation == encrypt
            inputblock .⊻= ivvector
            if triplicate
                outputblock = blockoperate(inputblock, keyvector[1:BLOCKSIZE], encrypt)
                outputblock = blockoperate(outputblock, keyvector[BLOCKSIZE+1:2BLOCKSIZE], decrypt)
                outputblock = blockoperate(outputblock, keyvector[2BLOCKSIZE+1:3BLOCKSIZE], encrypt)
            else
                outputblock = blockoperate(inputblock, keyvector, encrypt)
            end
            ivvector = outputblock
            output[i:i+BLOCKSIZE-1] = outputblock
        end
        if operation == decrypt
            if triplicate
                outputblock = blockoperate(inputblock, keyvector[2BLOCKSIZE+1:3BLOCKSIZE], decrypt)
                outputblock = blockoperate(outputblock, keyvector[BLOCKSIZE+1:2BLOCKSIZE], encrypt)
                outputblock = blockoperate(outputblock, keyvector[1:BLOCKSIZE], decrypt)
            else
                outputblock = blockoperate(inputblock, keyvector, decrypt)
            end
            outputblock .⊻= ivvector
            ivvector = inputblock
            output[i:i+BLOCKSIZE-1] = outputblock
        end
    end
    bitvector_to_string(output)
end

function blockoperate(plaintext::String, key::String, operation::Op)
    plaintextvector = string_to_bitvector(plaintext)
    keyvector = string_to_bitvector(key)
    ciphertext = blockoperate(plaintextvector, keyvector, operation)
    bitvector_to_string(ciphertext)
end

string_to_bitvector(input::String) = vcat(map(int_to_bitvector, transcode(UInt8, input), Iterators.cycle(8))...)
bitvector_to_string(bits::BitVector) = transcode(String, map(UInt8, vec(mapslices(des.bitvector_to_int, reshape(bits, 8, length(bits)÷8), dims=1))))

function blockoperate(plaintext::BitVector, key::BitVector, operation::Op)
    @assert length(plaintext) == BLOCKSIZE
    ipblock = permute(plaintext, iptable)
    pc1key = permute(key, pc1table)
    for round in 1:16
        expansionblock = permute(ipblock[BLOCKSIZE÷2+1:end], expansiontable)
        if operation == encrypt
            pc1key = rol(pc1key)
            if !(round in [1, 2, 9, 16])
                pc1key = rol(pc1key)
            end
        end
        subkey = permute(pc1key, pc2table)
        if operation == decrypt
            pc1key = ror(pc1key)
            if !(round in [16, 15, 8, 1])
                pc1key = ror(pc1key)
            end
        end
        expansionblock .⊻= subkey
        substitutionblock = sboxlookup(expansionblock)
        pboxtarget = permute(substitutionblock, ptable)
        ipblock[1:BLOCKSIZE÷2] .⊻= pboxtarget
        ipblock = circshift(ipblock, BLOCKSIZE÷2)
    end
    ipblock = circshift(ipblock, BLOCKSIZE÷2)
    permute(ipblock, fptable)
end

function permute(source::BitVector, permutetable::Vector)
    target = falses(length(permutetable))
    for i in eachindex(permutetable)
        if source[permutetable[i]]
            target[i] = true
        end
    end
    return target
end

rol(key::BitVector) = rotatekey(key, -1)
ror(key::BitVector) = rotatekey(key, 1)
function rotatekey(key::BitVector, shift::Integer)
    @assert length(key) == KEYSIZE
    halfes = reshape(key, KEYSIZE÷2, 2)
    reshape(circshift(halfes, shift), KEYSIZE)
end

function sboxlookup(expansionblock::BitVector)
    substitutionblock = BitVector(undef, BLOCKSIZE÷2)
    for x in 1:size(sbox, 1)
        y = bitvector_to_int(expansionblock[6(x-1)+1:6x]) + 1
        substitutionblock[4(x-1)+1:4x] = int_to_bitvector(sbox[x,y], 4)
    end
    return substitutionblock
end

bitvector_to_int(bits::BitVector) = sum(map((i,x) -> x ? 2^i : 0, length(bits)-1:-1:0, bits))

function int_to_bitvector(x, padding)
    bits = BitVector(undef, padding)
    for i in padding:-1:1
        bits[i] = x & 0x1
        x >>= 1
    end
    return bits
end

const iptable = [  # Initial permutation
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7
]
const fptable = [  # Final permutation
    40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25
]
const pc1table = [
    57, 49, 41, 33, 25, 17, 9, 1,
    58, 50, 42, 34, 26, 18, 10, 2,
    59, 51, 43, 35, 27, 19, 11, 3,
    60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15, 7,
    62, 54, 46, 38, 30, 22, 14, 6,
    61, 53, 45, 37, 29, 21, 13, 5,
    28, 20, 12, 4
]
const pc2table = [
    14, 17, 11, 24, 1, 5,
    3, 28, 15, 6, 21, 10,
    23, 19, 12, 4, 26, 8,
    16, 7, 27, 20, 13, 2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
]
const expansiontable = [
    32, 1, 2, 3, 4, 5,
    4, 5, 6, 7, 8, 9,
    8, 9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32, 1
]
const sbox = [
    14 0 4 15 13 7 1 4 2 14 15 2 11 13 8 1 3 10 10 6 6 12 12 11 5 9 9 5 0 3 7 8 4 15 1 12 14 8 8 2 13 4 6 9 2 1 11 7 15 5 12 11 9 3 7 14 3 10 10 0 5 6 0 13
    15 3 1 13 8 4 14 7 6 15 11 2 3 8 4 14 9 12 7 0 2 1 13 10 12 6 0 9 5 11 10 5 0 13 14 8 7 10 11 1 10 3 4 15 13 4 1 2 5 11 8 6 12 7 6 12 9 0 3 5 2 14 15 9
    10 13 0 7 9 0 14 9 6 3 3 4 15 6 5 10 1 2 13 8 12 5 7 14 11 12 4 11 2 15 8 1 13 1 6 10 4 13 9 0 8 6 15 9 3 8 0 7 11 4 1 15 2 14 12 3 5 11 10 5 14 2 7 12
    7 13 13 8 14 11 3 5 0 6 6 15 9 0 10 3 1 4 2 7 8 2 5 12 11 1 12 10 4 14 15 9 10 3 6 15 9 0 0 6 12 10 11 1 7 13 13 8 15 9 1 4 3 5 14 11 5 12 2 7 8 2 4 14
    2 14 12 11 4 2 1 12 7 4 10 7 11 13 6 1 8 5 5 0 3 15 15 10 13 3 0 9 14 8 9 6 4 11 2 8 1 12 11 7 10 1 13 14 7 2 8 13 15 6 9 15 12 0 5 9 6 10 3 4 0 5 14 3
    12 10 1 15 10 4 15 2 9 7 2 12 6 9 8 5 0 6 13 1 3 13 4 14 14 0 7 11 5 3 11 8 9 4 14 3 15 2 5 12 2 9 8 5 12 15 3 10 7 11 0 14 4 1 10 7 1 6 13 0 11 8 6 13
    4 13 11 0 2 11 14 7 15 4 0 9 8 1 13 10 3 14 12 3 9 5 7 12 5 2 10 15 6 8 1 6 1 6 4 11 11 13 13 8 12 1 3 4 7 10 14 7 10 9 15 5 6 0 8 15 0 14 5 2 9 3 2 12
    13 1 2 15 8 13 4 8 6 10 15 3 11 7 1 4 10 12 9 5 3 6 14 11 5 0 0 14 12 9 7 2 7 2 11 1 4 14 1 7 9 4 12 10 14 8 2 13 0 15 6 12 10 9 13 0 15 3 3 5 5 6 8 11
]
const ptable = [
    16, 7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2, 8, 24, 14,
    32, 27, 3, 9,
    19, 13, 30, 6,
    22, 11, 4, 25
]

end