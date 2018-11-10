module PyPlotPlus

export 
  usecmbright, 
  scalartickformat, 
  tightshow, 

  ticksoff, 
  tickson,
  tickparams,

  axisright, 
  axistop,
  invertaxis, 

  removespine, 
  removespines, 
  cornerspines, 
  bottomspine, 
  sidespine,

  aspectratio, 
  makesquare 

using 
  PyCall,
  Reexport

@reexport using PyPlot

tickparams(ax=gca(); kwds...) = ax[:tick_params](; kwds...)

function usecmbright()
  rc("text.latex", preamble="\\usepackage{cmbright}")
  rc("font", family="sans-serif")
  nothing
end

function scalartickformat(axis, ax=gca())
  axiscmd = Symbol(:get_, axis, :axis)
  ax[axiscmd]()[:set_major_formatter](matplotlib[:ticker][:ScalarFormatter]())
  ax[axiscmd]()[:set_minor_formatter](matplotlib[:ticker][:NullFormatter]())
  nothing
end

aspectratio(a, ax=gca(); adjustable="box") = ax[:set_aspect](a, adjustable=adjustable)
makesquare(ax=gca()) = aspectratio(1, ax)
makesquare(axs::AbstractArray) = for ax in axs; makesquare(ax); end

function setticks(ax, side, turnon)
  axiskw = side in ["top", "bottom"] ? "x" : "y"
  sidekw = Symbol(side)
  labelsidekw = Symbol(:label, side)
  keywords = Dict(:axis=>axiskw, :which=>"both", sidekw=>turnon, labelsidekw=>turnon)
  ax[:tick_params](keywords)
  nothing
end

function toggleleftticks(ax, toggle)
  ax[:tick_params](left=toggle, labelleft=toggle, right=!toggle, labelright=!toggle)
  nothing
end

function togglebottomticks(ax, toggle)
  ax[:tick_params](bottom=toggle, labelbottomleft=toggle, top=!toggle, labeltop=!toggle)
  nothing
end

tickson(ax, side) = setticks(ax, side, true)
ticksoff(ax, side) = setticks(ax, side, false)
ticksoff(axs::AbstractArray) = for ax in axs; ticksoff(ax); end

function ticksoff(ax::PyCall.PyObject)
  for side in ["top", "bottom", "left", "right"]
    ticksoff(ax, side)
  end
  nothing
end

function ticksoff(side::Union{Symbol,AbstractString})
  ax = gca()
  keywords = Dict(Symbol(side)=>false, Symbol(:label, side)=>false)
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
  ticksoff(ax, spine)
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
function cornerspines(ax=gca(); side="left", horizontal="bottom")
  if !(side == "left" || side == "right")
    throw("side must be left or right")
  end

  sidetoremove = side == "left" ? "right" : "left"
  horztoremove = horizontal == "bottom" ? "top" : "bottom"

  for spine in [horztoremove, sidetoremove]
    removespine(ax, spine)
  end

  horizontal == "bottom" || axistop(ax)
  side == "left" || axisright(ax)

  nothing
end

function sidespine(ax=gca(); side="left")
  sidetoremove = side == "left" ? "right" : "left"
  for spine in ["top", "bottom", sidetoremove]
    removespine(ax, spine)
  end

  togglebottomticks(ax, false)

  removeleft = side == "left" ? false : true
  toggleleftticks(ax, removeleft)

  tickson(ax, side)
  ax[:yaxis][:set_label_position](side)
  nothing
end

"Remove all spines except the bottom spine."
function bottomspine(ax=gca())
  for spine in ["top", "right", "left"]
    removespine(ax, spine)
    ticksoff(ax, spine)
  end
  nothing
end

"Move axis labels and ticks to the right side."
function axisright(ax=gca())
  ax[:tick_params](axis="y", which="both", left=false, labelleft=false, right=true, labelright=true)
  ax[:yaxis][:set_label_position]("right")
  nothing
end

"Move axis labels and ticks to the top."
function axistop(ax=gca())
  ax[:tick_params](axis="x", which="both", bottom=false, labelbottom=false, top=true, labeltop=true)
  try; ax[:xaxis][:set_label_position]("top")
  catch;
  end
  nothing
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
