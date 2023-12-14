import Revise, FixUsing, JuliaSyntax, CSTParser, Logging

using FixUsing: UseOfUsingWithoutColon
using Logging: LogLevel, @logmsg

# filename = "test/fixtures/parse_error_1.jl"

FixUsing._check_return_bool("src/check.jl")

# FixUsing._check_return_bool("test/fixtures/parse_error_1.jl")
