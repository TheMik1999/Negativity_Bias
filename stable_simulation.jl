using DifferentialEquations
using Plots
using NLsolve
using DelimitedFiles
include("function_plot_analitical.jl")

let 
function update_opinions(N, N_p, q_p, q_m, beta_plus, beta_minus, p)
    
    opinion = rand() < N_p/N

    if rand() < p #conformity
        if opinion 
            return -1
        else
            return 1
        end
    else #antyconformity
        if opinion
            if rand() < beta_minus
                neighbor = rand(q_m)
                if all(neighbor .< 1 - N_p/N)
                    return -1
                else
                    return 0
                end
            else
                return 0
            end
        else
            if rand() < beta_plus
                neighbor = rand(q_p)
                if all(neighbor .< N_p/N)
                    return 1
                else
                    return 0
                end
            else
                return 0
            end
        end
    end
end

function p_c_fun(c,q_plus,q_minus,beta_plus,beta_minus)
    L=beta_plus .*(1 .- c) .*c .^q_plus .- beta_minus .*c .*(1 .-c).^q_minus
    K=2 .*c .-1
    return L./(L.+K)
    
end

#--------- paraniteres of the model ----------------
n = 1*10^3
MCS = 2*10^3

q_plus  = 2
beta_plus = 1.0
q_minus = 1
beta_minus = 0.5
#--------------------------------------------------

# probability of independent behavior
p_list = 0.0:0.01:0.2
p_list = collect(p_list)
#--------------------------------------------------

# Lista of initial conditions
c_0_list=[1.0,0.0]
#--------------------------------------------------

plot1=Plots.plot()

# analytical curves
color = :blue
plot_curve(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
add_if_crite(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
# 

# sym_stab
c_stab=zeros(length(p_list))
p_trajectory=zeros(length(p_list),MCS)
for c_0 in c_0_list
    p_i=0
    println("c_0 -> $(c_0)")
    for p in p_list
        n_postive =  Int(n*c_0)
        for i = 1:MCS
            for j = 1:n
                n_postive += update_opinions(n,n_postive, q_plus, q_minus,beta_plus,beta_minus,p)
            end
            p_trajectory[p_i+1,i] = n_postive / n
        end
        println("p = ",p," c = ",n_postive / n," p_i = ",p_i)
        c_stab[p_i+1]=n_postive / n
        p_i+=1
    end
plot1=Plots.scatter!(p_list,c_stab, label="c_0 = $(c_0)")
end


plot1=Plots.xlims!(0,p_list[end])
plot1=Plots.ylims!(0,1)
name_of_plot="stable_simulation_analitical_q_p_$(q_plus)_q_m_$(q_minus)_b_p_$(beta_plus)_b_m_$(beta_minus).png"
path=""
savefig(path*name_of_plot)
display(plot1)

end 