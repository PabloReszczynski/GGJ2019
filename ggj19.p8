pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- Buttons
local left_btn = 0
local right_btn = 1
local up_btn = 2
local down_btn = 3
local A_btn = 4
local B_btn = 5

-- Colors
local cl_black = 0
local cl_darkblue = 1
local cl_darkpurple = 2
local cl_darkgreen = 3
local cl_brown = 4
local cl_darkgray = 5
local cl_lightgray = 6
local cl_white = 7
local cl_red = 8
local cl_orange = 9
local cl_yellow = 10
local cl_green = 11
local cl_blue = 12
local cl_indigo = 13
local cl_pink = 14
local cl_peach = 15

local player
local dummy_object

function make_player()
  local player = {
    x = 64,
    y = 64,
    vx = 2,
    vy = 2,
    sprite = 2
  }
  return player
end

function make_dummy_object()
  local dummy_object = {
    x = 8,
    y = 8,
    sprite = 3
  }
  return dummy_object
end

function draw_player()
  spr(player.sprite, player.x, player.y)
end

function draw_dummy_object()
  spr(dummy_object.sprite, dummy_object.x, dummy_object.y)
end

function draw_grid()
 -- Vertical lines
  for i = 0,120,8
  do
    line(i, 0, i, 128, 7 )
  end

-- Horizontal lines
  for i = 0,120,8
  do
    line( 0, i, 128, i, 7 )
  end
end

function _init()
  player = make_player()
  dummy_object = make_dummy_object()
end

function _update()
  if btn(right_btn) then
    player.x += player.vx
  end
  if btn(left_btn) then
    player.x -= player.vx
  end
  if btn(down_btn) then
    player.y += player.vy
  end
  if btn(up_btn) then
    player.y -= player.vy
  end
  if btn(A_btn) then
    player.color = cl_blue
  end
  if btn(B_btn) then
    player.color = cl_red
  end
end

function _draw()
  cls() -- Clears the screen
  draw_grid()
  draw_player()
  draw_dummy_object()
end

__gfx__
00000000bbbbbbbb0000eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008bb8b888000eeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007008888888800eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008888884800eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000884888480eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007004844884800ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004444480000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002205017050170501305014050170501905010050100501105019050130500e6501e05014050270501f460140701e0701d07023070150701d0701d07020070180701b070240501a0401c0501b0501b050
