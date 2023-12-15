@static if Base.VERSION < v"1.4-"
    function only(v::AbstractVector)
        n = length(v)
        if n != 1
            throw(ArgumentError("Collection has $(n) elements, must contain exactly 1 element"))
        end
        return v[1]
    end
end
