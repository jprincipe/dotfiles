local log = require("smart-splits.log")
local utils = require("smart-splits.utils")

local function herdr(...)
  local cmd = { "herdr" }
  vim.list_extend(cmd, { ... })

  local text, code = utils.system(cmd)
  if code ~= 0 then
    log.debug("herdr exited %s: %s", code, text)
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, text)
  if not ok then
    log.debug("herdr returned unparseable output: %s", text)
    return nil
  end

  return decoded.result
end

---@type SmartSplitsMultiplexer
local M = {} ---@diagnostic disable-line: missing-fields

M.type = "herdr" ---@diagnostic disable-line: assign-type-mismatch

function M.is_in_session()
  local pane_id = vim.env.HERDR_PANE_ID
  return pane_id ~= nil and #pane_id > 0
end

-- Always address this pane explicitly; `--current` is ambiguous between the
-- calling pane and the UI-focused pane depending on the subcommand.
local function this_pane(...)
  if not M.is_in_session() then
    return nil
  end

  local cmd = { ... }
  vim.list_extend(cmd, { "--pane", vim.env.HERDR_PANE_ID })
  return herdr(unpack(cmd))
end

local function pane_edges()
  local result = this_pane("pane", "edges")
  return result and result.edges or nil
end

function M.current_pane_id()
  local result = this_pane("pane", "layout")
  return result and result.layout and result.layout.focused_pane_id or nil
end

function M.current_pane_at_edge(direction)
  local edges = pane_edges()
  return edges ~= nil and edges[direction] == true
end

function M.current_pane_is_zoomed()
  local edges = pane_edges()
  return edges ~= nil and edges.layout ~= nil and edges.layout.zoomed == true
end

function M.next_pane(direction)
  local result = this_pane("pane", "focus", "--direction", direction)
  return result ~= nil and result.focus ~= nil and result.focus.changed == true
end

function M.resize_pane(direction, amount)
  local result = this_pane("pane", "resize", "--direction", direction, "--amount", tostring(amount))
  return result ~= nil and result.resize ~= nil and result.resize.changed == true
end

-- herdr splits only right or down; smart-splits only calls this for `at_edge = "split"`.
function M.split_pane(direction, size)
  if direction ~= "right" and direction ~= "down" then
    return false
  end

  local args = { "pane", "split", "--direction", direction, "--focus" }
  if size then
    vim.list_extend(args, { "--ratio", tostring(size) })
  end

  return this_pane(unpack(args)) ~= nil
end

function M.update_mux_layout_details() end

return M
