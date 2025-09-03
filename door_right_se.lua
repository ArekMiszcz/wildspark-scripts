local oid = ctx.objectId
if not oid then
  effect_ack("error:missing_objectId")
  return
end

-- GIDs from your tileset: set these to your closed/open tile IDs
local CLOSED_GID = 148
local OPEN_GID   = 146

local function applyState(open)
  local offsetX = 0
  local offsetY = 0

  local x = get_object_prop(oid, "x")
  local y = get_object_prop(oid, "y")

  if not has_object_prop(oid, "org_x") then
    set_object_prop(oid, "org_x", x)
    set_object_prop(oid, "org_y", y)
  else
    x = get_object_prop(oid, "org_x")
    y = get_object_prop(oid, "org_y")
  end

  if open then
    offsetX = 64
    offsetY = 0
    set_object_prop(oid, "open", true)
    set_object_prop(oid, "x", x + offsetX)
    set_object_prop(oid, "y", y + offsetY)
    set_object_gid(oid, OPEN_GID)
  else
    offsetX = 0
    offsetY = 0
    set_object_prop(oid, "open", false)
    set_object_prop(oid, "x", x + offsetX)
    set_object_prop(oid, "y", y + offsetY)
    set_object_gid(oid, CLOSED_GID)
  end

  

  effect_ack("door_state_changed")
end

local event = ctx.event
if event == "interact" then
  if ctx.object.props.open ~= nil then
    applyState(not ctx.object.props.open)
  else
    applyState(true)
  end
  return
end

effect_ack("error:unknown_event")