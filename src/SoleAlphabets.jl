module SoleAlphabets

import IterTools

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

    function BoundedProposition(left_bound,left_operator,value,right_operator,right_bound)

        @assert left_operator(left_bound,value) "Invalid proposition"
        @assert right_operator(value,right_bound) "Invalid proposition"

        return new{DoubleBoundedProposition}(
        value,
        left_bound,
        right_bound,
        left_operator,
        right_operator
        )

    end

    function BoundedProposition(value,operator,bound)

        @assert operator(value,bound) "Invalid proposition"

        if operator(value,bound)
            return new{RightBoundedProposition}(nothing,nothing,value,operator,bound)
        else
            return new{LeftBoundedProposition}(bound,operator,value,nothing,nothing)

    end

end
