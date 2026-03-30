function PolynomialSineCosine(x)
    n_inv = 1 / length(x)
    avg_x = n_inv * sum(x)
    x .* cos.(x .- n_inv) .* (sin.(x) .- 1 .- (x .- 1) .^ 2 .- avg_x)
end

function ExponetialI(x)
    exp.(x) .- 1
end

function ExponetialIII(x)
    x_sq = x .^ 2
    indices = collect(1:length(x)) ./ 10
    y = vcat(
        x_sq[1:end-1] .+ exp.(-x_sq[1:end-1]),
        exp(-x_sq[end]),
    )
    indices .* (1 .- y)
end

function PolynomialI(x)
    vcat(
        4 .* x[1:end-1] .+ (x[2:end] .- 2 .* x[1:end-1]) .- (x[2:end] .^ 2) ./ 3,
        4 * x[end] + (x[end-1] - 2 * x[end]) - x[end-1]^2 / 3,
    )
end

function SmoothSine(x)
    2 .* x .- sin.(x)
end

function NonsmoothSine(x)
    2 .* x .- sin.(abs.(x))
end

function ModifiedNonsmoothSine(x)
    x .- sin.(abs.(x .- 1))
end

function ModifiedNonsmoothSine2(x)
    x .- sin.(abs.(x) .- 1)
end

function ExponetialSineCosine(x)
    exp.(2 .* x) .+ 3 .* sin.(x) .* cos.(x) .- 1
end

function ModifiedTrigI(x)
    vcat(
        x[1] + sin(x[1]) - 1,
        -x[1:end-2] .+ 2 .* x[2:end-1] .+ sin.(x[2:end-1]) .- 1,
        x[end] + sin(x[end]) - 1,
    )
end

function Tridiagonal(x)
    indices = collect(1:length(x))
    x_left = vcat(0, x)
    x_right = vcat(x, 0)
    x .- exp.(cos.(indices .* (x_left[1:end-1] .+ x .+ x_right[2:end])))
end

function ModifiedTridiagonal(x)
    n = length(x)
    vcat(
        x[1] - exp(cos((x[1] + x[2]) / (n + 1))),
        -x[2:end-1] .- exp.(cos.((x[1:end-2] .+ x[2:end-1] .+ x[3:end]) ./ (n + 1))),
        x[end] - exp(cos((x[end-1] + x[end]) / (n + 1))),
    )
end

function Logarithmic(x)
    log.(x .+ 1) .- (x / length(x))
end

function NonmoothLogarithmic(x)
    log.(abs.(x) .+ 1) .- (x / length(x))
end

function ding2017FunII(x)
    x .- sin.(abs.(x .- 1))
end

function ding2017Diagonal6Fun(x)
    exp.(x) .- 1
end
