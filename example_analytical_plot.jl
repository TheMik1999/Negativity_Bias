using DifferentialEquations
using Plots
using NLsolve
using LaTeXStrings

include("function_plot_analitical.jl")
let 

    # Parameter lists
    q_plus_list  = [2]  
    q_minus_list = [1]      
        

    beta_plus_list  = [1] 
    beta_minus_list = [0.5]   
    
    
    # Probability range for independent behavior
    p_list = 0:0.05:0.5
    
    # Span for concentration c
    c_0_span = 0.0:0.001:1.0
    c_0_span = collect(c_0_span)
    
    # Select first values from lists
    q_minus  = q_minus_list[1]
    q_plus   = q_plus_list[1]
    beta_plus  = beta_plus_list[1]
    beta_minus = beta_minus_list[1] 

    dpi_me = 1600
    plot1 = plot(dpi=dpi_me)
    
    # --- Green curve: beta_minus = 0.9 ---
    beta_minus = 0.55
    color = :green
    plot_curve(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    add_if_crite(plot1, color, q_minus, q_plus, beta_minus, beta_plus)

    # --- Red curve: beta_minus = 0.1 ---
    beta_minus = 0.45
    color = :red
    plot_curve(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    add_if_crite(plot1, color, q_minus, q_plus, beta_minus, beta_plus)

    # --- Blue curve: beta_plus = default value from list ---
    beta_minus = beta_minus_list[1]
    color = :blue
    plot_curve(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    add_if_crite(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    
    # --- Add dummy lines for legend (to show color coding) ---
    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:green, label=L"\beta_->0.50")
    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:blue,  label=L"\beta_-=0.50")
    plot1 = plot!([-1, -1], [-1, -1], linewidth=2, linecolor=:red,   label=L"\beta_-<0.50")

    # Set axis limits and labels
    xlims!(0, 0.2)
    ylims!(0, 1)
    xlabel!(L"p")   # independent behavior probability
    ylabel!(L"c")   # concentration of positive opinion
    plot1 = plot!(legend=:topright, ncol=2)

    # --- Plot title showing parameters ---
    title = L"q_- = %$(q_minus) \: q_+ = %$(q_plus)\: \beta_+=%$(beta_plus)"
    title!(title)

    # Display the plot
    display(plot1)

end
