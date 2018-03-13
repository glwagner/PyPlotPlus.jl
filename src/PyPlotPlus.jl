__precompile__()

using PyPlot

module PyPlotPlus

using PyCall, NullableArrays

export makesquare!, ticksoff!, removespines!, getbasicoutput, axisright!, PyObject

@pyimport numpy.ma as ma                                                                                                
PyObject(a::NullableArray) = pycall(ma.array, Any, a.values, mask=a.isnull) 
                                                                                                                        
makesquare!(ax) = ax[:set_aspect](1, adjustable="box")
makesquare!(axs::AbstractArray) = for ax in axs; makesquare!(ax); end
                                                                                                                        
ticksoff!(ax) = ax[:tick_params](bottom=false, left=false, labelbottom=false, labelleft=false)
ticksoff!(axs::AbstractArray) = for ax in axs; ticksoff!(ax); end
                                                                                                                        
function removespines!(ax)
  for spine in ["top", "bottom", "left", "right"]
    ax[:spines][spine][:set_visible](false)
  end
  nothing
end
                                                                                                                        
function axisright!(ax)
  ax[:tick_params](axis="y", which="both", left=false, labelleft=false, right=true, labelright=true)                                                                                        
  ax[:yaxis][:set_label_position]("right")
end                                                                                                                     
                                                                                                                        
removespines!(axs::AbstractArray) = for ax in axs; removespines!(ax); end

end
