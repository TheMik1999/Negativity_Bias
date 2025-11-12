using NLsolve

# --- Compute analytical probability function p(c) ---
function p_c_fun(c, q_minus, q_plus, beta_minus, beta_plus)
    L = beta_plus .* (1 .- c) .* c .^ q_plus .- beta_minus .* c .* (1 .- c) .^ q_minus
    K = 2 .* c .- 1
    return L ./ (L .+ K)
end

# --- Determine if a given point (c,p) is stable or unstable ---
function stable_or_unstable(c, p, q_minus, q_plus, beta_minus, beta_plus)
    out_put = (1 - p) * (
        beta_plus * (-c^q_plus + q_plus * (1 - c) * (c^(q_plus - 1))) -
        beta_minus * (-q_minus * c * ((1 - c)^(q_minus - 1)) + (1 - c)^q_minus)
    ) - p * 2
    return out_put < 0
end

# --- Check if parameters satisfy the critical condition ---
function crit_val(q_minus, q_plus, beta_minus, beta_plus)
    val = beta_plus / beta_minus - (1 / 2)^(q_minus - q_plus)
    return abs(val) < 10^(-8)
end

# --- Classify indices of stable and unstable points along a curve ---
function seg_i(c_span, p_span, q_minus, q_plus, beta_minus, beta_plus)
    stab_i = []
    unstab_i = []
    for i in 2:length(p_span) - 1
        if stable_or_unstable(c_span[i], p_span[i], q_minus, q_plus, beta_minus, beta_plus)
            push!(stab_i, i)
        else
            push!(unstab_i, i)
        end
    end
    return stab_i, unstab_i
end

# --- Find contiguous sequences of indices in a list ---
function find_sequences(numbers)
    sequences = []
    if length(numbers) > 0
        current_sequence = (numbers[1],)

        for i in 2:length(numbers)
            if numbers[i] == numbers[i - 1] + 1
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

        if length(current_sequence) > 1
            push!(sequences, (current_sequence[1], current_sequence[end]))
        else
            push!(sequences, (current_sequence[1], current_sequence[1]))
        end
    end
    return sequences
end

# --- Add critical points to the plot if parameters satisfy critical condition ---
function add_if_crite(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    if crit_val(q_minus, q_plus, beta_minus, beta_plus)
        c_0_span = 0.0:0.001:1.0
        c_0_span = collect(c_0_span)
        p = c_0_span
        c_0_span = c_0_span .* 0 .+ 1/2

        println("--- Crit ---")
        stab_i, unstab_i = seg_i(c_0_span, p, q_minus, q_plus, beta_minus, beta_plus)
        seq_stab = find_sequences(stab_i)
        seq_unstab = find_sequences(unstab_i)

        for seq in seq_stab
            println(seq[1], " - ", seq[2])
            plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]],
                linewidth = 2, label = "", linecolor = color)
        end

        for seq in seq_unstab
            plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]],
                linewidth = 2, label = "", linecolor = :gray, linestyle = :dash)
        end
    end
end

# --- Plot the analytical curve and classify stable/unstable segments ---
function plot_curve(plot1, color, q_minus, q_plus, beta_minus, beta_plus)
    c_0_span = 0.0:0.001:1.0
    c_0_span = collect(c_0_span)
    p = p_c_fun(c_0_span, q_minus, q_plus, beta_minus, beta_plus)
    println(" qm=$(q_minus) qp=$(q_plus) bm=$(beta_minus) bp=$(beta_plus)")
    stab_i, unstab_i = seg_i(c_0_span, p, q_minus, q_plus, beta_minus, beta_plus)
    seq_stab = find_sequences(stab_i)
    seq_unstab = find_sequences(unstab_i)

    for seq in seq_stab
        plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]],
            linewidth = 2, label = "", linecolor = color)
    end
    for seq in seq_unstab
        plot1 = plot!(p[seq[1]:seq[2]], c_0_span[seq[1]:seq[2]],
            linewidth = 2, label = "", linecolor = :gray, linestyle = :dash)
    end
end
