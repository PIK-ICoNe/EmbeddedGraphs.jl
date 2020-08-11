using Revise
using Documenter
push!(LOAD_PATH, "../")
using EmbeddedGraphs

makedocs(
    sitename = "EmbeddedGraphs",
    format = Documenter.HTML(canonical = "fhell.github.io/EmbeddedGraphs.jl/"),
    modules = [EmbeddedGraphs],
    authors = "Frank Hellmann, Oskar Pfeffer, Paul Schultz and further contributors.",
    sitename = "EmbeddedGraphs.jl",
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/FHell/EmbeddedGraphs.jl.git",
    target = "build"
)

cp("docs_src/build", "docs", force=true)
