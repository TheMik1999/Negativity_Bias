
# Decision-Making under Negativity Bias: Double Hysteresis in the Opinion-Dependent q-Voter Model

This repository contains the code used to generate results for the publication *"Decision-Making under Negativity Bias: Double Hysteresis in the Opinion-Dependent q-Voter Model"*.

[Arxiv NOT YET](https://arxiv.org/pdf/2502.10172)

## Requirements

The code is written in **Julia** and was tested on **Julia v1.9.2**. To run simulations and analytical calculations, ensure you have the following packages installed:

```julia
using Plots
using LinearAlgebra
using NLsolve
using DifferentialEquations
```

To install missing packages, use:

```julia
using Pkg
Pkg.add(["Plots","LinearAlgebra",  "DifferentialEquations", "NLsolve","LaTeXStrings"])
```

**Note:** The `DataFrames`,`DelimitedFiles` and `CSV` packages are not required to run the code unless you wish to save data to CSV files. The relevant code for saving data is marked with `# save data to csv file` and is commented out by default.

## Parameters

- **N**  - Number of agents
- **q**  - Size of the group of influence
- **$\varepsilon_{\uparrow}$**  - Probability of an unadopted agent switching to adopted a state (if not unanimity in $q$-panel)
- **$\varepsilon_{\downarrow}$**  - Probability of an adopted agent switching to an unadopted state
(if not unanimity in $q$-panel)


## Model Description

The model is implemented on a complete graph, meaning that the network structure is not explicitly stored. Instead, only the number of adopted agents (**N_up**) is tracked.

### Figure

A schematic diagram of the model parameters (**q**,**$\varepsilon_{\uparrow}$**,**$\varepsilon_{\downarrow}$**):

![Figure](model_scheme.png)

**Caption:**
The diagram illustrates possible scenarios where a target agent (inside the circle) may change its state. Examples are provided for **q = 4**. Black (white) agents represent adopted (unadopted) agents, while gray agents indicate agents in an arbitrary state. 
- (a), (b): The target agent's state changes independently of its initial state if the **q-panel** is unanimous.
- (c): If the **q-panel** is not unanimous, an adopted agent switches to an unadopted state with probability **$\varepsilon_{\downarrow}$**.
- (d): If the **q-panel** is not unanimous, an unadopted agent adopts the state with probability **$\varepsilon_{\uparrow}$**.

---

## Files and Functions

### Simulation


#### `trajectory_simulation.jl` [View code](trajectory_simulation.jl)
Generates time trajectories for given **q**, **$\varepsilon_{\uparrow}$** and **$\varepsilon_{\downarrow}$**  values. Modified for multiple initial conditions.

#### `exitprobability_simulation.jl` [View code](exitprobability_simulation.jl)
Calculates exit probabilities from simulations.

### Analytical

#### `trajectory_analytical_plus_stab_point.jl` [View code](trajectory_analytical_plus_stab_point.jl)
Generates analytical time trajectories for given **q**, **$\varepsilon_{\uparrow}$** and **$\varepsilon_{\downarrow}$** values, with stable and unstable points included.



---

## How to Run the Code

1. Clone the repository:
   ```sh
   git clone https://github.com/TheMik1999/Modeling-biases-in-the-generalized-nonlinear-q-voter-model.git
   cd Modeling-biases-in-the-generalized-nonlinear-q-voter-model
   ```
2. Ensure you have **Julia v1.9.2** installed.
3. Install dependencies (if not installed already):
   ```julia
   using Pkg
   Pkg.add(["LinearAlgebra", "Plots", "DifferentialEquations", "NLsolve","LaTeXStrings"])
   ```
4. Run simulations:
   ```julia
   include("trajectory_simulation.jl")
   ```


---

## License

This project is licensed under the MIT License.

## Author

- **TheMik1999** - [GitHub Profile](https://github.com/TheMik1999)


For questions or contributions, feel free to open an issue or submit a pull request!
```

