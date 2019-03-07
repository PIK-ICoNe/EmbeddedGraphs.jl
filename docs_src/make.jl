using Revise
using Documenter
push!(LOAD_PATH, "../")
using EmbeddedGraphs

makedocs(
    sitename = "EmbeddedGraphs",
    format = Documenter.HTML(),
    modules = [EmbeddedGraphs])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#

cp("docs_src/build", "docs", force=true)
