struct UseOfUsingWithoutColon <: Base.Exception
    msg::String
end

# abstract type Style end

# With this style, we convert `using Foo` to `import Foo`
# struct PreferImportStyle end

# get_default_style() = PreferImportStyle()

# With this style, we convert `using Foo` to `using Foo: Foo`
# struct PreferUsingStyle end
