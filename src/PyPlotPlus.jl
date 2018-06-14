__precompile__()

module PyPlotPlus

using PyPlot, PyCall

export makesquare, ticksoff, axisright, tightshow,
       removespine, removespines, cornerspines, bottomspine,
       invertaxis

makesquare(ax) = ax[:set_aspect](1, adjustable="box")
makesquare(axs::AbstractArray) = for ax in axs; makesquare(ax); end
                                                                                                                        
ticksoff(ax) = ax[:tick_params](bottom=false, left=false, labelbottom=false, labelleft=false)
ticksoff(axs::AbstractArray) = for ax in axs; ticksoff(ax); end

function ticksoff(ax, side)
  sidekw = Symbol(side)
  labelsidekw = Symbol(:label, side)
  keywords = Dict(sidekw=>false, labelsidekw=>false)
  ax[:tick_params](keywords)
  nothing
end

"Invert the axis specified by keyword `axis`. Defaults to the yaxis."
function invertaxis(ax=gca(); axis="y")
  if axis == "y"
    ax[:invert_yaxis]()
  elseif axis == "x"
    ax[:invert_xaxis]()
  else
    throw("axis must be x or y")
  end
  nothing
end

"Remove `spine` from `ax`."
function removespine(ax, spine) 
  ax[:spines][spine][:set_visible](false)
  nothing
end
                                                                                                                        
"Remove all spines."
function removespines(ax=gca())
  for spine in ["top", "bottom", "left", "right"]
    removespine(ax, spine)
  end
  nothing
end

"Remove all spines except bottom and left spines."
function cornerspines(ax=gca())
  for spine in ["top", "right"]
    removespine(ax, spine)
  end
  ax[:tick_params](right=false, labelright=false, top=false, labeltop=false)
  nothing
end

"Remove all spines except the bottom spine."
function bottomspine(ax=gca())
  for spine in ["top", "right", "left"]
    removespine(ax, spine)
  end
  ax[:tick_params](left=false, labelleft=false, right=false, labelright=false, top=false, labeltop=false)
  nothing
end
                                                                                                                        
"Move axis labels and ticks to the right side."
function axisright(ax)
  ax[:tick_params](axis="y", which="both", left=false, labelleft=false, right=true, labelright=true)
  ax[:yaxis][:set_label_position]("right")
end

"Remove spines from all the axes in the array `axs`."
removespines(axs::AbstractArray) = for ax in axs; removespines(ax); end

"Execute tight_layout() and show plot."
function tightshow(pausetime=0.01)
  pause(pausetime)
  tight_layout()
  pause(pausetime)
  nothing
end

end # module
