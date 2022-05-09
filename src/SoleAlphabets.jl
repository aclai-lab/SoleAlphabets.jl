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
    desc::Union{Function,Nothing}

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
    desc::Union{Function,Nothing}

    function SingleBoundedProposition(value,operator,bound,desc=nothing)

        @assert operator(value,bound) "Invalid proposition"

        return new(value,operator,bound,desc)

    end

end

function PropositionPrint(io::IO,p::DoubleBoundedProposition)

    if p.desc === nothing
        println(io,p.left_bound," ",
        p.left_operator," ","A"," ",p.right_operator," ", p.right_bound)
    else
        println(io,p.left_bound," ",
        p.left_operator," ",p.desc,"(A)"," ",p.right_operator," ", p.right_bound)
    end

end

function PropositionPrint(io::IO,p::SingleBoundedProposition)

    if p.desc === nothing
        println(io,"A"," ",p.operator," ",p.bound)
    else
        println(io,p.desc,"(A)"," ",p.operator, " ",p.bound)
    end

end


show(io::IO,p::DoubleBoundedProposition) = PropositionPrint(io,p)

show(io::IO,p::SingleBoundedProposition) = PropositionPrint(io,p)

end
