a = read(filename, String)

cst, ps = CSTParser.parse(CSTParser.ParseState(a), true)

if ps.errored
    line, offset = ps.lt.endpos
    ex = FileParsingError(; filename, line, offset)
    throw(ex)
end
