module PublicMacroTestsOuter

module PublicMacroTestsInner

using FixUsing.PublicMacro: @public

@public f @hello

function f end

macro hello()
end

end

end # module
