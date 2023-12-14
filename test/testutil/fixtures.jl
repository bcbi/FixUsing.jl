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
    tmp_dir = mktempdir(; cleanup = true)
    dest = joinpath(tmp_dir, "mywritablefixtures")
    cp(fixtures_dir, dest)
    fix_file_extensions(dest)
    return joinpath(dest, path_components...)
end

function fix_file_extensions(dir::AbstractString)
    for (root, dirs, files) in walkdir(dir)
        for f in files
            suffix = r".jl.fixture$"
            if endswith(lowercase(strip(f)), suffix)
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
