function projectOnBoxCheck(x::Vector{<:Real}; bounds::Union{Nothing,Tuple{<:Real,<:Real}}=nothing)
    if isnothing(bounds)
        true
    else
        l, u = bounds
        all(l .<= x .<= u)
    end
end

function projectOnBox(x::Vector{<:Real}; bounds::Union{Nothing,Tuple{<:Real,<:Real}}=nothing)
    if isnothing(bounds)
        x
    else
        l, u = bounds
        clamp.(x, l, u)
    end
end

function projectOnHalfSpaceCheck(x; beta::Union{Nothing,Real}=nothing)
    n = length(x)
    bound = isnothing(beta) ? n : beta
    sum(x) <= bound
end

function projectOnHalfSpace(x; beta::Union{Nothing,Real}=nothing)
    n = length(x)
    bound = isnothing(beta) ? n : beta
    sum(x) <= bound && return x

    found_break = false
    sorted_x = sort(x, rev=true)
    running_sum = zero(eltype(sorted_x))
    threshold = zero(eltype(sorted_x))

    for ii in 1:n-1
        running_sum += sorted_x[ii]
        threshold = (running_sum - bound) / ii
        if threshold >= sorted_x[ii + 1]
            found_break = true
            break
        end
    end

    running_sum += sorted_x[n]
    if !found_break
        threshold = (running_sum - bound) / n
    end

    if running_sum <= bound
        x
    else
        max.(x .- threshold, zero(eltype(x)))
    end
end

function projectOnTriangleCheck(x; beta::Union{Nothing,Real}=nothing, lower=0)
    projectOnBoxCheck(x; bounds=(lower, Inf)) && projectOnHalfSpaceCheck(x; beta=beta)
end

function projectOnTriangle(x; beta::Union{Nothing,Real}=nothing, lower=0)
    projectOnHalfSpace(projectOnBox(x; bounds=(lower, Inf)); beta=beta)
end

function projectOnRn(x)
    x
end
