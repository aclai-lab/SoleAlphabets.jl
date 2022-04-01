using SoleAlphabets
using Documenter

DocMeta.setdocmeta!(SoleAlphabets, :DocTestSetup, :(using SoleAlphabets); recursive=true)

makedocs(;
    modules=[SoleAlphabets],
    authors="Eduard I. STAN, Giovanni PAGLIARINI",
    repo="https://github.com/aclai-lab/SoleAlphabets.jl/blob/{commit}{path}#{line}",
    sitename="SoleAlphabets.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://aclai-lab.github.io/SoleAlphabets.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aclai-lab/SoleAlphabets.jl",
)
