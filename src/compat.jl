@static if Base.VERSION < v"1.4-"
    function only(v::AbstractVector)
        n = length(v)
        if n != 1
            msg = "Collection has $(n) elements, must contain exactly 1 element"
            throw(ArgumentError(msg))
        end
        return v[1]
    end
end
