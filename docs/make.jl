using MPT
using Documenter

DocMeta.setdocmeta!(MPT, :DocTestSetup, :(using MPT); recursive=true)

makedocs(;
    modules=[MPT],
    authors="Kiar Fatah",
    repo="https://github.com/Xiar-fatah/MPT.jl/blob/{commit}{path}#{line}",
    sitename="MPT.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Xiar-fatah.github.io/MPT.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Xiar-fatah/MPT.jl",
    devbranch="master",
)
