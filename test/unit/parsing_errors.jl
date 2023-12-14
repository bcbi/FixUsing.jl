filename = readonly_fixture("parse_error_1.jl.fixture")
@test_throws JuliaSyntax.ParseError FixUsing.check(filename)
