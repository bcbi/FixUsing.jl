# function overwrite(path::AbstractString, style::Style = get_default_style())
#     if isfile(path)
#         return overwrite_file(path, style::Style)
#     elseif isdir(path)
#         return overwrite_directory(path, style::Style)
#     else
#         msg = """
#             Could not determine whether \"\" is a file or a directory.
#         """
#         throw(Base.ArgumentError(msg))
#     end
#     return nothing
# end

# function overwrite_file(file::AbstractString, style::Style = get_default_style())
#     new_text = _get_fixed_file_text(file, style)
#     return nothing
# end

# function overwrite_directory(directory::AbstractString, style::Style = get_default_style())
#     for (root, dirs, files) in directory
#         for file in files
#             full_file_path = join(root, file)
#             overwrite_file(file, style)
#         end
#     end
#     return nothing
# end

# function _get_fixed_file_text(file::AbstractString, style::Style)
# end
