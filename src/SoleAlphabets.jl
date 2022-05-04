module SoleAlphabets

import Base.show
import Base.Iterators

import IterTools

# Todo - add "name/definition" field to proposition struct and its show overload
# Todo - add documentation

abstract type AbstractProposition end

abstract type AbstractBoundedProposition <: AbstractProposition end

abstract type SingleBoundedProposition <: AbstractProposition end
abstract type DoubleBoundedProposition <: AbstractProposition end

abstract type LeftBoundedProposition <: SingleBoundedProposition end
abstract type RightBoundedProposition <: SingleBoundedProposition end

struct BoundedProposition{T} <: AbstractBoundedProposition

    left_bound::Union{Real,Nothing}
    left_operator::Union{Function,Nothing}
    value::Real
    right_operator::Union{Function,Nothing}
    right_bound::Union{Real,Nothing}

    function BoundedProposition(
        left_bound,
        left_operator,
        value,
        right_operator,
        right_bound
    )
        @assert left_operator(left_bound, value) "Invalid proposition"
        @assert right_operator(value, right_bound) "Invalid proposition"

        return new{DoubleBoundedProposition}(
            value,
            left_bound,
            right_bound,
            left_operator,
            right_operator
        )

    end

    function BoundedProposition(value, operator, bound)
        @assert operator(value, bound) "Invalid proposition"

        if operator(value, bound)
            return new{RightBoundedProposition}(nothing, nothing, value, operator, bound)
        else
            return new{LeftBoundedProposition}(bound, operator, value, nothing, nothing)
        end
    end

end

# Generate tuples of the form ` a operator b `
function _propositions_gen2(
    sample::Array{<:Real},
    operators::Vector{Function}
)
    return Iterators.flatten((
        (
            (x[1], op, x[2])
            for op in operators
            for x in IterTools.subsets(sample, Val(2))
            if op(x[1], x[2])
        ),
        (
            (x[2], op, x[1])
            for op in operators
            for x in IterTools.subsets(sample, Val(2))
            if op(x[2], x[1])
        )
    ))
end

# Generate tuples of the form ` a operator1 b operator2 c`
function _propositions_gen3(
    sample::Array{<:Real},
    operators::Vector{Function}
)
    return Iterators.flatten((
        (
            (x[1], op[1], x[2], op[2], x[3])
            for op in IterTools.subsets(operators, Val(2))
            for x in IterTools.subsets(sample, Val(3))
            if op[1](x[1], x[2]) && op[2](x[2], x[3])
        ),
        (
            (x[3], op[1], x[2], op[2], x[1])
            for op in IterTools.subsets(operators, Val(2))
            for x in IterTools.subsets(sample, Val(3))
            if op[1](x[3], x[2]) && op[2](x[2], x[1])
        ),
    ))
end

# Return a generator to efficiently retrieve all unique propositions in sample
function propositions(
    sample::Array{<:Real},
    f::Function,
    operators::Vector{Function}
)
    sample = sort(f.(unique(sample)))

    # todo - add dispatching
    # _propositions_gen2 is used to iterate over single bounded propositions
    if 1==1
        return _propositions_gen2(sample, operators)
    else
        return _propositions_gen3(sample, operators)
    end
end

# looking to the future the user could manipulate this
operators = [<, <=, >, >=, ==, !=]

# usage example
example = [36, 36, 36, 36.5, 38, 38.5, 37, 37.5, 36.75, 36.5, 36.5]
for i in propositions(example, abs, operators )
    @show i
end

end
