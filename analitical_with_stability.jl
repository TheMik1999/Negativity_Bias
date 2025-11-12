using DifferentialEquations
using Plots
using NLsolve
using LaTeXStrings

include("plot_analitical.jl")
let 

    q_plus_list = [8]
    q_minus_list = [7]

    beta_plus_list = [1]
    beta_minus_list = [0.5]
    
    p_list = 0:0.05:0.5
    c_0_span=0.0:0.001:1.0
    c_0_span=collect(c_0_span)
    


    q_plus  = q_plus_list[1]
    q_minus = q_minus_list[1]
    beta_minus = beta_minus_list[1]
    beta_plus = beta_plus_list[1] 

    dpi_me=1600

    plot1=plot(dpi=dpi_me)
    
    beta_minus = 0.9
    color = :green
    plot_curve(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    add_if_crite(plot1,color,q_plus, q_minus, beta_plus, beta_minus)


    beta_minus = 0.1
    color = :red
    plot_curve(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    add_if_crite(plot1,color,q_plus, q_minus, beta_plus, beta_minus)


    beta_minus= beta_minus_list[1]
    color = :blue
    plot_curve(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    add_if_crite(plot1,color,q_plus, q_minus, beta_plus, beta_minus)


        
    

    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:green, label=L"\beta_->0.50")
    beta_minus= 0.0
    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:blue, label=L"\beta_-=0.50")
    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:red, label=L"\beta_-<0.50")



xlims!(0,0.1)
ylims!(0,1)
xlabel!(L"p")
ylabel!(L"c")
plot1=plot!(legend=:topright, ncol=2)
# q_- = %$(q_minus)
title = L"q_+ = %$(q_plus) \: q_- = %$(q_minus)\: \beta_+=%$(beta_plus)"
title!(title)
# name_of_plot = "plot1.pdf"
# path = ""
# savefig(path * name_of_plot)
display(plot1)

end 
# end
