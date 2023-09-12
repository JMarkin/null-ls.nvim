local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

return helpers.make_builtin({
    name = "bandit",
    meta = {
        url = "https://github.com/PyCQA/bandit",
        description =
        [[Bandit is a tool designed to find common security issues in Python code. To do this Bandit
            processes each file, builds an AST from it, and runs appropriate plugins against the AST nodes. Once Bandit
            has finished scanning all the files it generates a report.]],
    },
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "python" },
    generator_opts = {
        command = "bandit",
        to_stdin = false,
        args = {
            "-q",
            "--msg-template",
            "|{line}| |{col}| |{test_id}| |{severity}| |{msg}|",
            "-f",
            "custom",
            "--exit-zero",
            "$FILENAME",
        },
        format = "line",
        check_exit_code = function(code)
            return code == 0
        end,
        on_output = helpers.diagnostics.from_pattern(
            "|(.*)| |(.*)| |(.*)| |(.*)| |(.*)|",
            { "row", "col", "code", "severity", "message" },
            {
                severities = {
                    UNDEFINED = helpers.diagnostics.severities["hint"],
                    LOW = helpers.diagnostics.severities["information"],
                    MEDIUM = helpers.diagnostics.severities["warning"],
                    HIGH = helpers.diagnostics.severities["error"],
                },
            }
        ),
    },
    factory = helpers.generator_factory,
})
