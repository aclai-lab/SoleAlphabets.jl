module SoleAlphabets

import IterTools

abstract type AbstractProposition end

abstract type BoundedProposition <: AbstractProposition end

struct DoubleBoundedProposition <: BoundedProposition

    left_bound::Real
    left_operator::Function
    value::Real
    right_operator::Function
    right_bound::Real

    function DoubleBoundedProposition(left_bound,left_operator,value,right_operator,right_bound)

        @assert left_operator(left_bound,value) "Invalid proposition"
        @assert right_operator(value,right_bound) "Invalid proposition"

        return new(
            value,
            left_bound,
            right_bound,
            left_operator,
            right_operator
        )

    end

end

struct SingleBoundedProposition <: AbstractBoundedProposition

    value::Real
    operator::Function
    bound::Real

    function SingleBoundedProposition(value,operator,bound)

        @assert operator(value,bound) "Invalid proposition"

        return new(value,operator,bound)

    end

end
