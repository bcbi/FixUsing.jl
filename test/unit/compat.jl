@test FixUsing.only([1]) == 1
@test_throws Base.ArgumentError FixUsing.only([])
@test_throws Base.ArgumentError FixUsing.only([1, 2])
@test_throws Base.ArgumentError FixUsing.only([1, 2, 3])
