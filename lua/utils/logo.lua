local R = {
  "██████╗ ",
  "██╔══██╗",
  "██████╔╝",
  "██╔══██╗",
  "██║  ██║",
  "╚═╝  ╚═╝",
}
local F4 = {
  "██╗  ██╗",
  "██║  ██║",
  "███████║",
  "╚════██║",
  "     ██║",
  "     ╚═╝",
}
local P = {
  "██████╗ ",
  "██╔══██╗",
  "██████╔╝",
  "██╔═══╝ ",
  "██║     ",
  "╚═╝     ",
}
local Z = {
  "███████╗",
  "╚══███╔╝",
  "  ███╔╝ ",
  " ███╔╝  ",
  "███████╗",
  "╚══════╝",
}
local spacer = "  "
local logo_lines = {}
for i = 1, 6 do
  logo_lines[i] = R[i] .. spacer .. F4[i] .. spacer .. P[i] .. spacer .. P[i] .. spacer .. Z[i]
end

return table.concat(logo_lines, "\n")
