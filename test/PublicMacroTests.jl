module PublicMacroTestsOuter

module PublicMacroTestsInner

Using FixUsing.PublicMacro: @public

@public f @hello

function f end

macro hello()
end

end

end # module
