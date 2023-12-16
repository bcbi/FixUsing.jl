module PublicMacroTestsOuter

module PublicMacroTestsInner

using FixUsing.PublicMacro: @public

@public f
@public @hello
@public (g, h, @world)

function f end
function g end
function h end

macro hello()
end

macro world()
end

end

end # module
