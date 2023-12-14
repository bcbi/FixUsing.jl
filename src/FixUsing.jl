module FixUsing

import CSTParser # TODO: get rid of CSTParser and only use JuliaSyntax
import JuliaSyntax
import Logging

using JuliaSyntax, Logging

# For convenience, bring some names into scope
# using Logging: LogLevel, @logmsg

include("PublicMacro.jl")

PublicMacro.@public overwrite
PublicMacro.@public overwrite_file
PublicMacro.@public overwrite_directory

include("types.jl")

include("check.jl")
include("fix.jl")

end # module
