module SoleAlphabets

import IterTools
import Base: show

abstract type AbstractProposition end

abstract type BoundedProposition <: AbstractProposition end

struct DoubleBoundedProposition <: BoundedProposition

    left_bound::Real
    left_operator::Function
    value::Real
    right_operator::Function
    right_bound::Real
    desc::Function


    function DoubleBoundedProposition(left_bound,left_operator,value,right_operator,right_bound,desc)

        @assert left_operator(left_bound,value) "Invalid proposition"
        @assert right_operator(value,right_bound) "Invalid proposition"

        return new(
            left_bound,
            left_operator,
            value,
            right_operator,
            right_bound,
            desc
        )

    end

end

struct SingleBoundedProposition <: BoundedProposition

    value::Real
    operator::Function
    bound::Real
    desc::Function

    function SingleBoundedProposition(value,operator,bound,desc)

        @assert operator(value,bound) "Invalid proposition"

        return new(value,operator,bound,desc)

    end

end


show(io::IO,p::DoubleBoundedProposition) = println(io,typeof(a)," : ",p.left_bound," ",
                                                    p.left_operator," ", p.desc,"(A)"," ",
                                                    p.right_operator," ", p.right_bound)

show(io::IO,p::SingleBoundedProposition) = println(io,typeof(p)," : ", p.desc,"(A)"," ",
                                                    p.operator, " ",p.bound)
