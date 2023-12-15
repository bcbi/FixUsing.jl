@testset "single file" begin
    @testset "good" begin
        filename = readonly_fixture("good_using_1.jl")
        @test FixUsing._check_file_return_bool(filename)
        @test FixUsing.check(filename) == nothing
        @test FixUsing.check_file(filename) == nothing
    end
    @testset "bad" begin
        filename = readonly_fixture("dir_contains_bad_using", "bad_using_1.jl.fixture")
        @test !FixUsing._check_file_return_bool(filename)
        # FixUsing.check(filename) # TODO: delete this line
        # FixUsing.check_file(filename) # TODO: delete this line
        @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check(filename) # TODO: uncomment this line
        @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check_file(filename) # TODO: uncomment this line
    end
end

@testset "directory" begin
    @testset "good" begin
        # TODO: write these tests
    end
    @testset "bad" begin
        dir = writable_fixture("dir_contains_bad_using")
        cd(dir) do
            # FixUsing.check(".") # TODO: delete this line
            # FixUsing.check_directory(".") # TODO: delete this line
            @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check(".") # TODO: uncomment this line
            @test_throws FixUsing.UseOfUsingWithoutColon FixUsing.check_directory(".") # TODO: uncomment this line
    
            result = FixUsing._check_directory_return_bool_countfiles(".")
            @test !result.all_good
            @test result.num_julia_files == 1
        end
    end
end
