module SoleAlphabets

import IterTools

abstract type AbstractProposition end

# TODO
# manage different propositions than lower_bound <= value <= upper_bound
# e.g lower_bound > value, value != upper_bound, value ⋈ upper_bound
struct SingleBoundedProposition <: AbstractProposition
    value::Real
    bound::Real
    comparison_operator::Function

    function SingleBoundedProposition(value, bound, comparison_operator=≤)
        @assert comparison_operator(value, bound) "Invalid proposition"
        new(value, bound, comparison_operator)
    end
end

struct DoubleBoundedProposition <: AbstractProposition
    lower_bound::Real
    value::Real
    upper_bound::Real

    function DoubleBoundedProposition(lower_bound, value, upper_bound)
        @assert lower_bound <= value <= upper_bound "Invalid proposition"
        new(lower_bound, value, upper_bound)
    end
end

Base.show(io::IO, p::SingleBoundedProposition) =
    print(io, "{$(p.lower_bound) $(p.boutai) $(p.upper_bound)}")

Base.show(io::IO, p::DoubleBoundedProposition) =
    print(io, "{$(p.lower_bound) <= $(p.value) <= $(p.upper_bound)}")

# subsets could be exploited to also generate all kind of SingleBoundedProposition
function propositions(sample::Array{<:Real}, f::Function)
    sample = sort(f.(unique(sample)))
    return IterTools.subsets(sample, 3)
end

# Usage example
"""
example = [36, 36, 36, 36.5, 38, 38.5, 37, 37.5, 36.75, 36.5, 36.5]
for i in propositions(example, maximum)
    println(i[1], " ", i[2], " ", i[3])
end
"""

end
