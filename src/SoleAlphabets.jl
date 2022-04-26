module SoleAlphabets

import IterTools

abstract type AbstractProposition end

# TODO
# build a system to handle new operators or remove them


# -----------------------------------------------------------------------------
# PROPOSITIONS DEFINITION
# -----------------------------------------------------------------------------

@enum BoundType Lower Upper
struct SingleBoundedProposition <: AbstractProposition
    value::Real
    bound::Real
    bound_type::BoundType
    comparison_operator::Function

    function SingleBoundedProposition(value, bound, bound_type, comparison_operator=≤)
        if bound_type == Lower
            @assert comparison_operator(bound, value) "Invalid proposition"
        else
            @assert comparison_operator(value, bound) "Invalid proposition"
        end
        new(value, bound, bound_type, comparison_operator)
    end
end

struct DoubleBoundedProposition <: AbstractProposition
    lower_bound::Real
    left_comparison_operator::Function
    value::Real
    right_comparison_operator::Function
    upper_bound::Real

    function DoubleBoundedProposition(
        lower_bound,
        left_comparison_operator,
        value,
        right_comparison_operator,
        upper_bound
    )
        @assert left_comparison_operator(lower_bound, value) "Invalid proposition"
        @assert right_comparison_operator(value, upper_bound) "Invalid proposition"
        new(lower_bound, left_comparison_operator, value,
            right_comparison_operator, upper_bound)
    end
end

function single_prop_print(io::IO, p::SingleBoundedProposition)
    if(p.bound_type == Lower)
        print(io, "{$(p.bound) $(p.comparison_operator) $(p.value)}")
    else
        print(io, "{$(p.value) $(p.comparison_operator) $(p.bound)}")
    end
end
Base.show(io::IO, p::SingleBoundedProposition) = single_prop_print(io, p)

Base.show(io::IO, p::DoubleBoundedProposition) =
    print(io,"{$(p.lower_bound) $(p.left_comparison_operator) $(p.value) "*
            "$(p.right_comparison_operator) $(p.upper_bound)}")

# -----------------------------------------------------------------------------
# PROPOSITIONS EXTRACTION
# -----------------------------------------------------------------------------

# Remove duplicates in sample, apply f to each element and sort it
# Then extract *ALL* valid propositions
# (Subsets of size 2 -> SingleBoundedProposition)
# (Subsets of size 3 -> DoubleBoundedProposition)
function propositions(sample::Array{<:Real}, f::Function, operators::Vector{Function})
    #This function could be shrinked up
    sample = sort(f.(unique(sample)))

    𝒫 = AbstractProposition[]

    #SingleBoundedProposition extractions (same elements)
    for s in sample
        for op in operators
            if(op(s, s))
                push!(𝒫, SingleBoundedProposition(s, s, Lower, op))
            end
        end
    end

    #SingleBoundedProposition extractions (different elements)
    for i in IterTools.subsets(sample, 2)
        #IMPORTANT
        #sample is sorted, this is crucial to avoid useless attempts
        #e.g consider the sequence 34, 35, 36. It is useless to check 34 > 35, 34 > 36 ...
        #but if we want to implement a more interactive way to manage operators, we could
        #be obliged to check every case. (eg. 34 bitwiseOperator 35, 42 bitwiseOperator 42)
        for op in operators
            if(op(i[2], i[1]))
                push!(𝒫, SingleBoundedProposition(i[1], i[2], Lower, op))
            end
            if(op(i[1], i[2]))
                push!(𝒫, SingleBoundedProposition(i[1], i[2], Upper, op))
            end
        end
    end

    #DoubleBoundedProposition extractions
    for i in IterTools.subsets(sample, 3)
        for left_operator in operators
            for right_operator in operators
                if(left_operator(i[1], i[2]) && right_operator(i[2], i[3]))
                    push!(𝒫, DoubleBoundedProposition(
                        i[1], left_operator, i[2], right_operator, i[3])
                    )
                end
            end
        end
    end

    return 𝒫
end

# Usage example
operators = [<, <=, >, >=, ==, !=]
example = [36, 36, 36, 36.5, 38, 38.5, 37, 37.5, 36.75, 36.5, 36.5]
P = propositions(example, maximum, operators)
@show P
# This shows there are no duplicates
@show P == unique(P)

end
