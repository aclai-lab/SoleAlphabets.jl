module SoleAlphabets

using SoleTraits # is_proposition trait

import Base.show
import Base.Iterators

import IterTools

export Letter, LetterAlphabet, is_proposition

export SingleBoundedProposition, DoubleBoundedProposition
export propositions
export equifreq, equispaced

include("alphabets.jl")

end
