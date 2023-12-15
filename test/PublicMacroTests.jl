module PublicMacroTestsOuter

module PublicMacroTestsInner

using FixUsing.PublicMacro: @public

@public f
@public @hello

function f end

macro hello()
end

end

end # module
