module SoleAlphabets

import Base.show
import Base.Iterators

import IterTools

abstract type AbstractProposition end
abstract type BoundedProposition <: AbstractProposition end

struct DoubleBoundedProposition <: BoundedProposition
    left_bound::Real
    left_operator::Function
    value::Real
    right_operator::Function
    right_bound::Real

    applied_function::Union{Function,Nothing}

    function DoubleBoundedProposition(
        left_bound,
        left_operator,
        value,
        right_operator,
        right_bound,
        applied_function
    )
        @assert left_operator(left_bound, value) "Invalid proposition"
        @assert right_operator(value, right_bound) "Invalid proposition"

        return new(
            left_bound,
            left_operator,
            value,
            right_operator,
            right_bound,
            applied_function
        )
    end
end

struct SingleBoundedProposition <: BoundedProposition
    value::Real
    operator::Function
    bound::Real
    applied_function::Union{Function,Nothing}

    function SingleBoundedProposition(value, operator, bound, applied_function=nothing)
        @assert operator(value, bound) "Invalid proposition"
        return new(value, operator, bound, applied_function)
    end
end

function proposition_print(io::IO, p::DoubleBoundedProposition)
    if p.applied_function === nothing
        println(
            io,
            "$(p.left_bound) $(p.left_operator) $(p.value) "*
            "$(p.right_operator) $(p.right_bound) "
        )
    else
        println(
            io,
            "$(p.left_bound) $(p.left_operator) $(p.applied_function)(A) "*
            "$(p.right_operator) $(p.right_bound) "
        )
    end
end

function proposition_print(io::IO, p::SingleBoundedProposition)
    if p.applied_function === nothing
        println(io, "A $(p.operator) $(p.bound)")
    else
        println(io, "$(p.applied_function)(A) $(p.operator) $(p.bound)")
    end
end

show(io::IO, p::DoubleBoundedProposition) = proposition_print(io, p)
show(io::IO, p::SingleBoundedProposition) = proposition_print(io, p)

# Generate tuples of the form ` val ⋈ b `
function _propositions_gen2(
    sample::Array{<:Real},
    operators::Vector{Function},
    preprocessing::Union{Function, Nothing} = nothing
)
    return Iterators.flatten((
        (
            ( SingleBoundedProposition(x[1], op, x[2], preprocessing) )
            for op in operators
            for x in IterTools.subsets(sample, Val(2))
            if op(x[1], x[2])
        ),
        (
            ( SingleBoundedProposition(x[2], op, x[1], preprocessing) )
            for op in operators
            for x in IterTools.subsets(sample, Val(2))
            if op(x[2], x[1])
        )
    ))
end

# Generate tuples of the form ` a ⋈ val ⋈ b`
function _propositions_gen3(
    sample::Array{<:Real},
    operators::Vector{Function},
    preprocessing::Union{Function, Nothing} = nothing
)
    return Iterators.flatten((
        (
            ( DoubleBoundedProposition(x[1], op[1], x[2], op[2], x[3], preprocessing) )
            for op in IterTools.subsets(operators, Val(2))
            for x in IterTools.subsets(sample, Val(3))
            if op[1](x[1], x[2]) && op[2](x[2], x[3])
        ),
        (
            ( DoubleBoundedProposition(x[3], op[1], x[2], op[2], x[1], preprocessing) )
            for op in IterTools.subsets(operators, Val(2))
            for x in IterTools.subsets(sample, Val(3))
            if op[1](x[3], x[2]) && op[2](x[2], x[1])
        ),
    ))
end


function equispaced(sample::Array{<:Real},space::Real)

    new_sample = LinRange(sample[1],sample[length(sample)],space)

    return new_sample

end


function equifreq(sample::Array{<:Real},cut::Real)
    new_sample = Array{Real,1}()
    n = ceil(length(sample)/(cut+1))
    count = 0

    for i in 1:length(sample)
        count+=1

        if count == n
            append!(new_sample,sample[i])
            count = 0
        end

    end

    if length(sample) % cut != 0
        append!(new_sample,sample[end])
    end

    return unique(new_sample)

end

# Chebishev nodes can be implemented
# 1/2(a+b)+1/2(b-a)*cos(((2k-1)*pi)/(2*n))

# Return a generator to efficiently retrieve all unique propositions in sample
function propositions(
    sample::Array{<:Real},
    preprocessing::Function,
    operators::Vector{Function};
    type::Type = DoubleBoundedProposition,
    sample_modifier::Union{Function, Nothing} = nothing,
    cut :: Union{Integer,Nothing} = nothing
)
    sample = sort(preprocessing.(unique(sample)))

    # Todo: implement something to manipulate sample
    # e.g get 30% of its values, equally distributed
    if sample_modifier !== nothing
        sample = sample_modifier(sample,cut)
    end

    # _propositions_gen2 is used to iterate over single bounded propositions
    if type == SingleBoundedProposition
        return _propositions_gen2(sample, operators, preprocessing)
    else
        return _propositions_gen3(sample, operators, preprocessing)
    end
end

# looking to the future the user could manipulate this
operators = [<, <=, >, >=, ==, !=]

example = [36, 36, 36, 36.5, 38, 38.5, 37, 37.5, 36.75, 36.5, 36.5]
for i in propositions(example, identity, operators, sample_modifier=equifreq, cut=2 ,type=SingleBoundedProposition,)
    print(i)
end

end
