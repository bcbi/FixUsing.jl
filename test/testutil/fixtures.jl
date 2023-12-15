function _get_fixtures_dir()
    root_test_testutil = @__DIR__ # ./test/testutil
    root_test = dirname(root_test_testutil) # ./test
    fixtures_dir = joinpath(root_test, "fixtures") # ./test/fixtures
    return fixtures_dir
end

function readonly_fixture(path_components...)
    fixtures_dir = _get_fixtures_dir()
    return joinpath(fixtures_dir, path_components...)
end

function writable_fixture(path_components...)
    fixtures_dir = _get_fixtures_dir()
    @static if Base.VERSION >= v"1.3-"
        tmp_dir = mktempdir(; cleanup = true)
    else
        # The `cleanup` kwarg was only added in Julia 1.3
        tmp_dir = mktempdir()
    end
    dest = joinpath(tmp_dir, "mywritablefixtures")
    cp(fixtures_dir, dest)
    fix_file_extensions(dest)
    return joinpath(dest, path_components...)
end

@static if Base.VERSION >= v"1.0-"
    function _has_jlfixture_suffix(name::AbstractString)
        suffix = r".jl.fixture$"
        return endswith(lowercase(strip(f)), suffix)
    end
else
    function _has_jlfixture_suffix(name::AbstractString)
        suffix = ".jl.fixture"
        return endswith(lowercase(strip(f)), suffix)
    end
end

function fix_file_extensions(dir::AbstractString)
    for (root, dirs, files) in walkdir(dir)
        for f in files
            if _has_jlfixture_suffix(f)
                new_filename = replace(f, suffix => ".jl")
                old_path = joinpath(root, f)
                new_path = joinpath(root, new_filename)
                mv(old_path, new_path)
                @info "Moved" old_path new_path isfile(old_path) isfile(new_path)
            end
        end
    end
    return nothing
end
