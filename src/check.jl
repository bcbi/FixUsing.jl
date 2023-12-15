### Public API:

# using FixUsing: check
# check(".")
function check(path::AbstractString)::Nothing
    if isfile(path)
        check_file(path)
    else
        isdir(path) || throw(Base.ArgumentError("Could not figure out if this is a file or directory"))
        check_directory(path)
    end
end

function check_file(filename::AbstractString)::Nothing
    if !_check_file_return_bool(filename::AbstractString)
        msg = "The file includes usage of `using Foo`"
        throw(UseOfUsingWithoutColon(msg))
    end
end

function check_directory(
    directory::AbstractString;
    is_julia_file::F = _file_has_julia_file_extension,
)::Nothing where {F}
    all_good = _check_directory_return_bool(directory; is_julia_file = is_julia_file)
    if !all_good
        msg = "At least one file includes usage of `using Foo`"
        throw(UseOfUsingWithoutColon(msg))
    end
end

### Internals:

@inline function _file_has_julia_file_extension(name::AbstractString)
    name_cleaned = lowercase(strip(name))
    return endswith(name_cleaned, ".jl")
end

function _check_directory_return_bool(
    directory::AbstractString;
    is_julia_file::F = _file_has_julia_file_extension,
) where {F}
    result = _check_directory_return_bool_countfiles(directory; is_julia_file = is_julia_file)
    return result.all_good
end

function _check_directory_return_bool_countfiles(
    directory::AbstractString;
    is_julia_file::F = _file_has_julia_file_extension,
) where {F}
    all_good = true
    num_julia_files = 0
    for (root, dirs, files) in walkdir(directory)
        for file in files
            if is_julia_file(file)
                num_julia_files += 1
                full_path_to_file = joinpath(root, file)
                all_good *= _check_file_return_bool(full_path_to_file)
            else
                # @logmsg LogLevel(-10) "Not a Julia file: $(file)" # TODO: uncomment this line
            end
        end
    end
    return (; all_good = all_good, num_julia_files = num_julia_files)
end

@inline _is_import_node(node) = JuliaSyntax.kind(node) == JuliaSyntax.K"import"
@inline _is_using_node(node) = JuliaSyntax.kind(node) == JuliaSyntax.K"using"
@inline _is_colon_node(node) = JuliaSyntax.kind(node) == JuliaSyntax.K":"

function _check_file_return_bool(filename::AbstractString)
    filecontents = read(filename, String)
    syntax_node = JuliaSyntax.parseall(JuliaSyntax.SyntaxNode, filecontents; filename = filename)
    return _recurse_check_return_bool(syntax_node)
end

function _recurse_check_return_bool(node::JuliaSyntax.SyntaxNode)
    head = JuliaSyntax.head(node)

    overall_goodness = true

    if _is_import_node(node)
        # @logmsg LogLevel(-100) "Found node of the form `import Foo`" node # TODO: uncomment this line
    end

    if _is_using_node(node)
        overall_goodness *= _is_this_using_node_good(node)
    end

    children = JuliaSyntax.children(node)

    for child in children
        overall_goodness *= _recurse_check_return_bool(child)
    end

    return overall_goodness
end

function _is_this_using_node_good(node)
    @assert _is_using_node(node)

    children = JuliaSyntax.children(node)
    if (length(children) == 1) && (_is_colon_node(only(children)))
        # @logmsg LogLevel(-100) "Found node of the form `using Foo: f`" node # TODO: uncomment this line
        good = true
    else
        msg = @error "Found node of the form `using Foo`" node
        good = false
    end

    return good
end
