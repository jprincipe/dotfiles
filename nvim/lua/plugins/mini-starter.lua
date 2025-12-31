return {
  "nvim-mini/mini.starter",
  lazy = false,
  priority = 100,
  config = function()
    local starter = require("mini.starter")
    starter.setup({
      header = [[
          _____                    _____
         /\    \                  /\    \
        /::\    \                /::\    \
        \:::\    \              /::::\    \
         \:::\    \            /::::::\    \
          \:::\    \          /:::/\:::\    \
           \:::\    \        /:::/__\:::\    \
           /::::\    \      /::::\   \:::\    \
  _____   /::::::\    \    /::::::\   \:::\    \
 /\    \ /:::/\:::\    \  /:::/\:::\   \:::\____\
/::\    /:::/  \:::\____\/:::/  \:::\   \:::|    |
\:::\  /:::/    \::/    /\::/    \:::\  /:::|____|
 \:::\/:::/    / \/____/  \/_____/\:::\/:::/    /
  \::::::/    /                    \::::::/    /
   \::::/    /                      \::::/    /
    \::/    /                        \::/____/
     \/____/                          ~~
]],
      items = {
        starter.sections.builtin_actions(),
        starter.sections.recent_files(5, false),
        starter.sections.recent_files(5, true),
      },
      footer = "",
    })
  end,
}
