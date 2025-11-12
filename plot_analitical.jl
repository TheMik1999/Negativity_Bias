using NLsolve

# Function defining the Jacobian matrix
function jacobian(c, p, q_plus, q_minus, beta_plus, beta_minus)
    k = (1-p) * (beta_minus * (-c^q_minus + q_minus * (1-c) * (c^(q_minus-1))) - 
                 beta_plus * (-q_plus * c * ((1-c)^(q_plus-1)) + (1-c)^q_plus)) - p * 2
    return k
end

# Function defining the system of equations
function myfunc(c, p, q_p, q_m, b_p, b_m)
    return (1-p) * (b_m * (1-c) * c^q_m - b_p * c * (1-c)^q_p) + p * (1-2*c)
end

function clean_p(c_span,p_span)
    # if p is not in [0,1] then delete it and corresponding c
    new_p_span=[]
    new_c_span=[]
    for i in 1:length(p_span)
        if p_span[i]>=0 && p_span[i]<=1
            push!(new_p_span,p_span[i])
            push!(new_c_span,c_span[i])
        end
    end
    return new_c_span,new_p_span
end

    
function p_c_fun(c,q_plus,q_minus,beta_plus,beta_minus)
    L=beta_minus .*(1 .- c) .*c .^q_minus .- beta_plus .*c .*(1 .-c).^q_plus
    K=2 .*c .-1
    return L./(L.+K)
end
# Function to find fixed points
function fix_points(p_val, q_p, q_m, b_p, b_m)
    Rounded_solution = []
    c_span = 0:0.01:1
    max_v = 0.0
    for c_start in c_span
        c = [c_start]
        acuracy = 1e-8
        number_of_iterations = 10^6

        root = nlsolve(c -> [myfunc(c[1], p_val, q_p, q_m, b_p, b_m)], c, 
                       ftol=acuracy, xtol=acuracy, iterations=number_of_iterations)
        rounded_root = round.(root.zero, digits=3)
        rrx = rounded_root[1]
        if root.f_converged
            if rounded_root in Rounded_solution
                continue
            elseif rrx < 0 || rrx > 1
                continue
            else
                push!(Rounded_solution, rounded_root)
                max_v = max(max_v, rrx)
            end
        end
    end
    return Rounded_solution, max_v
end


function stable_or_unstable(c,p,q_plus,q_minus,beta_plus,beta_minus)
    out_put=(1-p)*(beta_minus*(-c^q_minus + q_minus*(1-c)*(c^(q_minus-1)))-beta_plus*( -q_plus*c*((1-c)^(q_plus-1))+(1-c)^q_plus))-p*2 
    return out_put<0 
end



function seg_i(c_span,p_span,q_plus,q_minus,beta_plus,beta_minus)
    stab_i=[]
    unstab_i=[]
    for i in 2:length(p_span)-1
        if stable_or_unstable(c_span[i],p_span[i],q_plus,q_minus,beta_plus,beta_minus)
            push!(stab_i,i)
        else
            push!(unstab_i,i)
        end
    end
    return stab_i,unstab_i
end

function find_sequences(numbers)
    sequences = []  # Lista, w której będą przechowywane sekwencje
    if length(numbers)>0
    current_sequence = (numbers[1],)  
    
    for i in 2:length(numbers)
        if numbers[i] == numbers[i-1] + 1
            current_sequence = (current_sequence..., numbers[i])
        else
            if length(current_sequence) > 1
                push!(sequences, (current_sequence[1], current_sequence[end]))
            else
                push!(sequences, (current_sequence[1], current_sequence[1]))
            end
            current_sequence = (numbers[i],)
        end
    end
    
    # Na końcu dodaj ostatnią sekwencję (jeśli istnieje)
    if length(current_sequence) > 1
        push!(sequences, (current_sequence[1], current_sequence[end]))
    else
        push!(sequences, (current_sequence[1], current_sequence[1]))
    end
end
    return sequences
end

function crit_val(qp,qm,bp,bm)
    val = bm/bp - (1/2)^(qp-qm)
    return abs(val )< 10 ^(-8)
end


function add_if_crite(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    if crit_val(q_plus, q_minus, beta_plus, beta_minus)
        c_0_span = 0.0:0.001:1.0
        c_0_span = collect(c_0_span)
        p = c_0_span 
        c_0_span = c_0_span .* 0 .+ 1/2

        println("--- Crit ---")
        stab_i, unstab_i = seg_i(c_0_span, p, q_plus, q_minus, beta_plus, beta_minus)
        seq_stab = find_sequences(stab_i)
        seq_unstab = find_sequences(unstab_i)
        # println(seq_stab)
        # println(seq_unstab)

        for seq in seq_stab
            println(seq[1]," - ",seq[2])
            # println(p[seq[1]]," - ",p[seq[2]])
            # println(c_0_span[seq[1]]," - ",c_0_span[seq[2]])
            plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]], linewidth=2, label="", linecolor=color)
        end

        for seq in seq_unstab
            plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]], linewidth=2, label="", linecolor=:gray, linestyle=:dash)
        end
    end
end


function add_if_crite_stab_only(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    if crit_val(q_plus, q_minus, beta_plus, beta_minus)
        c_0_span = 0.0:0.001:1.0
        c_0_span = collect(c_0_span)
        p = c_0_span 
        c_0_span = c_0_span .* 0 .+ 1/2

        println("--- Crit ---")
        stab_i, unstab_i = seg_i(c_0_span, p, q_plus, q_minus, beta_plus, beta_minus)
        seq_stab = find_sequences(stab_i)
        seq_unstab = find_sequences(unstab_i)
        # println(seq_stab)
        # println(seq_unstab)

        for seq in seq_stab
            println(seq[1]," - ",seq[2])
            # println(p[seq[1]]," - ",p[seq[2]])
            # println(c_0_span[seq[1]]," - ",c_0_span[seq[2]])
            plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]], linewidth=2, label="", linecolor=color)
        end

        # for seq in seq_unstab
        #     plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]], linewidth=2, label="", linecolor=:gray, linestyle=:dash)
        # end
    end
end

function plot_curve(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
    c_0_span = 0.0:0.001:1.0
    c_0_span = collect(c_0_span)
    p=p_c_fun(c_0_span,q_plus,q_minus,beta_plus,beta_minus)
    println(" qp=$(q_plus) qm=$(q_minus) bp=$(beta_plus) bm=$(beta_minus)")
    # stab_c,stab_p,unstab_c,unstab_p=seg(c_0_span,p,q_plus,q_minus,beta_plus,beta_minus)
    stab_i,unstab_i = seg_i(c_0_span,p,q_plus,q_minus,beta_plus,beta_minus)
    seq_stab=find_sequences(stab_i)
    seq_unstab=find_sequences(unstab_i)

    for seq in seq_stab
        plot1=plot!(p[seq[1]:seq[2]],c_0_span[seq[1]:seq[2]],linewidth=2,label="",linecolor=color)
    end
    for seq in seq_unstab
        plot1=plot!(p[seq[1]:seq[2]],c_0_span[seq[1]:seq[2]],linewidth=2,label="",linecolor=:gray,linestyle=:dash)
    end
    # add_if_crite(plot1,color,q_plus, q_minus, beta_plus, beta_minus)
end