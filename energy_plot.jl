#using Regex

# Define a regular expression pattern to match the desired file names
pattern = r"(.*?)_(\d+)_(\d+)_energy\.jl"

# Directory containing the files
directory_path = "src/output/"

# Initialize an empty dictionary to store the data
data_dict = Dict{Tuple{Int, Int}, Float64}()

# List all files in the directory
files = readdir(directory_path)

# Loop through the files and extract the information
for file in files
    match_result = match(pattern, file)
    
    # Check if the file name matches the pattern
    if match_result !== nothing
        # Extract L, alpha, and energy from the matched groups
        L = parse(Int, match_result.captures[2])
        alpha = parse(Int, match_result.captures[3])
        energy = parse(Float64, read(joinpath(directory_path, file), String))
        
        # Store the data in the dictionary
        data_dict[(L, alpha)] = energy / (4 * L)
    end
end

# Print the dictionary
println(data_dict)

# Make a plot
function filter_dict_by_alpha(data_dict::Dict{Tuple{Int, Int}, Float64}, target_alpha::Int)
    return Dict(key[1] => value for (key, value) in data_dict if key[2] == target_alpha)
end

using Plots

filtered_alpha_1_dict = filter_dict_by_alpha(data_dict, 1)
filtered_alpha_2_dict = filter_dict_by_alpha(data_dict, 2)
filtered_alpha_4_dict = filter_dict_by_alpha(data_dict, 4)


L_cubed = (1 ./.√keys(filtered_alpha_1_dict)) .^ 3

energy = values(filtered_alpha_1_dict)
scatter(collect(L_cubed), collect(energy), xlabel="1 / L^3", ylabel="Energy",
    legend=false)

# Data for alpha = 2 and alpha = 4
L_cubed_2 = (1 ./.√keys(filtered_alpha_2_dict)) .^ 3
energy_2 = values(filtered_alpha_2_dict)

L_cubed_4 = (1 ./.√keys(filtered_alpha_4_dict)) .^ 3
energy_4 = values(filtered_alpha_4_dict)

# Add data for alpha = 2 and alpha = 4 to the existing plot
scatter!(collect(L_cubed_2), collect(energy_2), label="alpha = 2")
display(scatter!(collect(L_cubed_4), collect(energy_4), label="alpha = 4"))

# Update the title and legend
title!("Energy vs. 1 / L^3 (alpha = 1, 2, 4)")
legend=true