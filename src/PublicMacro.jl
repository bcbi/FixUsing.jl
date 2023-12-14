module PublicMacro

# This code is based on Compat.jl (https://github.com/JuliaLang/Compat.jl)
# License: MIT
#
# Specifically: https://github.com/JuliaLang/Compat.jl/blob/0a507df3d113a83a8824de490fa9bee9d707d166/src/compatmacro.jl#L43-L50

# https://github.com/JuliaLang/julia/pull/50105
# https://github.com/JuliaLang/Compat.jl/pull/805
macro public(expr::Union{Expr,Symbol})
    symbols = _get_symbols(expr)
    @static if Base.VERSION >= v"1.11.0-DEV.469"
        return esc(Expr(:public, symbols...))
    end
    return nothing
end


"""
    _is_valid_macro(expr::Expr)

Check if `expr` is a valid macro call with no arguments, and if it is,
return the name of that macro as a Symbol. Otherwise, return `nothing`.

This would be valid: `@foo`

This would not be valid: `@foo bar`
"""
function _is_valid_macro(expr::Expr)
    if Meta.isexpr(expr, :macrocall)
        if length(expr.args) == 2
            if expr.args[1] isa Symbol
                if expr.args[2] isa LineNumberNode
                    arg1_symbol = expr.args[1]::Symbol
                    arg1_str = string(arg1_symbol)
                    arg1_firstchar = first(arg1_str)
                    if arg1_firstchar == '@'
                        return true
                    end
                end
            end
        end
    end
    return nothing
end

_get_valid_macro_name(expr::Expr) = expr.args[1]::Symbol

function _get_symbols(expr::Union{Expr,Symbol})
    if expr isa Symbol
        return [expr]
    end
    if _valid_macro()
        return [_get_valid_macro_name(expr)]
    end
    if expr.head != :tuple
        throw(
            ArgumentError(
                "cannot mark expression `$(expr)` as public. Try `PublicMacro.@public foo, bar`",
            ),
        )
    end
    symbols = Vector{Symbol}(undef, length(expr.args))
    for (i, arg) in enumerate(expr.args)
        if arg isa Symbol
            symbols[i] = arg
        elseif _valid_macro(arg)
            symbols[i] = _get_valid_macro_name(arg)
        else
            throw(
                ArgumentError(
                    "cannot mark expression `$(expr)` as public due to argument $(arg). Try `PublicMacro.@public foo, bar`",
                ),
            )
        end
    end
    return symbols
end

end # module
