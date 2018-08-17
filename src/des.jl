module des

const DES_BLOCK_SIZE = 8
const DES_KEY_SIZE = 8
const EXPANSION_BLOCK_SIZE = 6
const PC1_KEY_SIZE = 7
const SUBKEY_SIZE = 6

ByteVector = Vector{UInt8}

function getBit(bytes::ByteVector, bit::UInt)
    index, bitpos = fldmod(bit, 8)
    bytes[index + 1] & (0x80 >> bitpos)
end

function setBit!(bytes::ByteVector, bit::UInt)
    index, bitpos = fldmod(bit, 8)
    bytes[index + 1] |= (0x80 >> bitpos)
end

function clearBit!(bytes::ByteVector, bit::UInt)
    index, bitpos = fldmod(bit, 8)
    bytes[index + 1] &= ~(0x80 >> bitpos)
end

end
