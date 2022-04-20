module SoleAlphabets

#TODO:
#   1) add different types of propositions and some Reusability pattern
#       Tom Kwong - Hands on Design Patterns and Best Practices with Julia; pg 165 to 200
#   2) shrink code lines length

abstract type AbstractProposition end

struct DoubleBoundedProposition <: AbstractProposition
    lower::Number
    value::Number
    upper::Number

    #Invalid propositions are ignored
    function DoubleBoundedProposition(l, v, u)
        (l <= v && v <= u) ? new(l,v,u) : error("Invalid proposition")
    end
end

Base.show(io::IO, p::AbstractProposition) =
    print(io, "{$(p.lower) <= $(p.value) <= $(p.upper)}")

"""
Valid propositions are obtained by watching all sample's sub-intervals
"""
function propositions(sample::Array{<:Number}, f::Function, compact=false)
    #TODO: add compatibility to SoleData datatypes.
    #another dispatch for this function could be propositions(sample::TimeSeries, f::Function)
    #which would call propositions(series(sample), f)
    #as sketched here https://github.com/aclai-lab/SoleBase.jl/blob/time-series-type/ferdiu/src/data/types/time-series.jl

    𝒫 = AbstractProposition[]

    #redundant values are removed, f is applied to each value in sample. Result is sorted
    sample = sort(f.(unique(sample)))
    sample_length = length(sample)

    #O(N^3)
    for n = 1:(sample_length-1)
        [push!(𝒫, DoubleBoundedProposition(sample[i], v, sample[i+n]))
        for i in 1:(sample_length-n)
        for v in sample[i:i+n]]
    end

    #Explanation of `compact` argument-
    #If the function is monotonic, O(N^2) can be achieved by keeping a reference to
    #the sorted array and sacrificing values representation
    #---
    #instead of:
    #{..., 36.5 <= 36.5 <= 39,  36.5 <= 37 <= 39, 36.5 <= 37.5 <= 39, ...}
    #a compact notation could be used:
    #{..., (lower_bound_index,upper_bound_index) }
    #meaning that each index between bounds brings to a valid proposition.
    #using this strategy space complexity becomes O(N^2)
    #in fact there are at most N*(N-1)/2 intervals

    return 𝒫
end

"""Usage example
function halves(x)
    return x/2
end

example = [36, 36, 36, 36.5, 38, 38.5, 37, 37.5, 36.75, 36.5, 36.5]
c = propositions(example, halves)
@show c
"""

end


"""
Cose da chiedere ad Eduard
1) Discutere i tipi da manipolare, provenienti da SoleData

2) Quando creo una proposizione, conviene controllare la sua validita' nel costruttore
o nella funzione? Adesso e' direttamente nel costruttore ma potrebbe essere bad practice

3) Il discorso della "notazione compatta" per arrivare a complessita' quadratica
"""
