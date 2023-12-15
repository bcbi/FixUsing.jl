@test only([1]) == 1
@test_throws Base.ArgumentError only([])
@test_throws Base.ArgumentError only([1, 2])
@test_throws Base.ArgumentError only([1, 2, 3])
