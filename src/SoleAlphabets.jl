module SoleAlphabets

import Base.show
import Base.Iterators

import IterTools

export Letter, LetterAlphabet

export SingleBoundedProposition, DoubleBoundedProposition
export propositions
export equifreq, equispaced

include("alphabets.jl")

end
