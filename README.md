**Stalled for now since Julia tooling is still immature. Also, startup time and unit tests are taking too long.**

# ImplementingTLS.jl
Going through "Implementing SSL/TLS" by Joshua Davies

The original source code from the book is in C but I don't want to just simply type down exactly the same.

Therefore, I was looking for a simple, dynamic language for playing around with these crypto algorithms.
I used Python initially but it's hard to do all the bit shifting with arbitrarily large numbers.

Since Julia just recently hit 1.0 it's a nice opportunity to play around with a more modern language. 
I don't know if it will gain acceptance in the long run (statistically I would drift to "no") but it's always
good to take a look at some modern approaches for existing problems.

And the best thing is it does C-like overflow:

```julia
julia> 0xff + 0x01
0x00

julia> UInt8(255) + UInt8(1)
0x00

julia> bitstring(0b11111111 + 0b00000001)
"00000000"
```

## Tests

Simply run: `julia -e "using Pkg; Pkg.activate(\".\"); Pkg.test()"`
