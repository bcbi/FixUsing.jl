@testset "single file" begin
    filename = readonly_fixture("dir_contains_bad_using", "bad_using_1.jl.fixture")
    @test !FixUsing._check_file_return_bool(filename)
    @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check(filename)
    @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check_file(filename)
end

@testset "directory" begin
    dir = writable_fixture("dir_contains_bad_using")
    @show FixUsing._check_directory_return_bool(dir)
    @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check(dir)

    result = FixUsing._check_directory_return_bool_countfiles(dir)
    @test !result.all_good
    @test result.num_julia_files == 1
end
