using Pkg
#pkg"activate ."
pkg"activate .."
push!(LOAD_PATH,"../src/")

using MPT, Documenter

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
        #"Home" => "index.md",
            "index.md",
            "portfolio.md",
            "backtesting.md"
        ]
)

deploydocs(;
    repo="github.com/Xiar-fatah/MPT.jl",
    versions = ["stable" => "master", "dev" => "master"]
    #devbranch="master",
)
