# Array of alpha values
alphas=(1 2 4 16)

# Loop through each alpha value
for alpha in "${alphas[@]}"; do
    echo "Running Julia with Alpha = $alpha"
    julia src/main/main.jl $alpha 
done