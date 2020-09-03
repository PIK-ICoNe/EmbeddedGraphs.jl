using Documenter
using EmbeddedGraphs

makedocs(
    format = Documenter.HTML(canonical = "fhell.github.io/EmbeddedGraphs.jl/"),
    modules = [EmbeddedGraphs],
    authors = "Frank Hellmann, Oskar Pfeffer, Paul Schultz and further contributors.",
    sitename = "EmbeddedGraphs.jl",
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/FHell/EmbeddedGraphs.jl.git"
)


