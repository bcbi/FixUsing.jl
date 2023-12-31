import FixUsing
import Test

import JuliaSyntax
import Logging

# For convenience, bring some names into scope
using Test: @test, @testset, @test_throws

include("testutil/fixtures.jl")

@testset "FixUsing.jl" begin
    @testset "unit/check" begin
        include("unit/check.jl")
    end
    @testset "unit/compat" begin
        include("unit/compat.jl")
    end
    @testset "unit/parsing_errors" begin
        include("unit/parsing_errors.jl")
    end

    @testset "PublicMacro" begin 
        include("PublicMacroTests.jl")
    end
end
