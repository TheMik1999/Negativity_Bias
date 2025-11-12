# using Plots
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


#--------- paraniteres of the model ----------------
n = 1*10^4
MCS = 2*10^3

q_plus_list = [8]
q_minus_list = [6]
beta_minus = 1
beta_plus = 0.5

# probability of independent behavior
p = 0.081
#--------------------------------------------------

# Lista of initial conditions
c_0_list=0.0:0.25:1
c_0_list=collect(c_0_list)

c=zeros(MCS+1)
# plot1=Plots.plot(title="n=$(n) q_p=$(q_plus_list) q_m=$(q_minus_list) b_p=$(beta_plus) b_m=$(beta_minus) p=$(p)",xlabel="MCS",ylabel="c")
for c_0 in c_0_list
    for q_plus in q_plus_list
        for q_minus in q_minus_list
            println("c_0 = ",c_0," p = ",p," q_plus = ",q_plus," q_minus = ",q_minus," beta_plus = ",beta_plus," beta_minus = ",beta_minus)
             n_postive = Int(n*c_0)
            for i = 1:MCS
                if i % 250 == 0
                    println("Step $i, c=$(n_postive/n)")
                end
                for j = 1:n
                    n_postive += update_opinions(n,n_postive, q_plus, q_minus,beta_plus,beta_minus,p)
                end
                c[i] = n_postive / n
            end
            # plot1=Plots.plot!(0:MCS, c, label="p = $(p) q_p = $(q_plus) q_m = $(q_minus)")
        end
    end
end
# display(plot1)
end 