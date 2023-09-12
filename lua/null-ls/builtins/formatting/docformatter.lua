local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
    name = "docformatter",
    meta = {
        url = "https://github.com/PyCQA/docformatter",
        description = "Formats Python docstrings to follow PEP 257",
    },
    filetypes = { "python" },
    factory = h.formatter_factory,
    method = { FORMATTING, RANGE_FORMATTING },
    generator_opts = {
        command = "docformatter",
        args = h.range_formatting_args_factory({
            "-",
        }, "--range", nil, { use_rows = true }),
        to_stdin = true,
    },
})
