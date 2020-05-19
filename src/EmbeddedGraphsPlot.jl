import GraphPlot.gplot

function gplot(g::AbstractEmbeddedGraph, args...)
    loc_x = vertices_loc(g,1)
    loc_y = vertices_loc(g,2)
    gplot(g.graph, loc_x, loc_y, args...)
end


function gplot(g::AbstractEmbeddedGraph, loc_x::Array{<:Real}, loc_y::Array{<:Real}, args...)
    gplot(g.graph, loc_x, loc_y, args...)
end
