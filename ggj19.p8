pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- buttons
local left_btn = 0
local right_btn = 1
local up_btn = 2
local down_btn = 3
local a_btn = 4
local b_btn = 5

-- colors
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

local global_state

function Player()
  local player = {
    x = 64,
    y = 64,
    vx = 2,
    vy = 2,
    sprite = 2
  }

  function player:update()
    if btn(right_btn) then
      self.x += self.vx
    end
    if btn(left_btn) then
      self.x -= self.vx
    end
    if btn(down_btn) then
      self.y += self.vy
    end
    if btn(up_btn) then
      self.y -= self.vy
    end
  end

  function player:draw()
    spr(player.sprite, player.x, player.y)
  end

  return player
end

function Inventory()
 local inventory = {
  x = 40,
  x_end = 88,
  y = 104,
  y_end = 128,
  visible = false,
  items = {},
 }

 function inventory:update(cursor)
  if is_between(cursor,self, 48) then
    self.visible = true
  else
    self.visible = false
  end
 end

 function inventory:draw()
   if self.visible then
     rectfill(self.x,self.y,self.x_end,self.y_end, cl_yellow)
   end
 end

 return inventory
end


function DummyObject(x, y)
  local dummy_object = {
    x = snap(x),
    y = snap(y),
    sprite = 3,
    draggable = false,
    dragged = false,
  }

  function dummy_object:update(cursor)
    if is_between(cursor, self, 8) then
      self.draggable = true
    end

    if btn(a_btn) and self.draggable then
      if not(cursor.dragging) then
        cursor.dragging = self
      end
    else
      if cursor.dragging == self then
        cursor.dragging = false
      end
    end

    if not(is_between(cursor, self, 8)) then
      self.draggable = false
    end
  end

  function dummy_object:draw()
    spr(self.sprite, self.x, self.y)
  end

  return dummy_object
end

function Cursor()
  local cursor = {
    x = 0,
    y = 0,
    color = cl_blue,
    dragging = false
  }

  function cursor:update(player)
    if btn(a_btn) then
      self.color = cl_red
    else
      self.color = cl_blue
    end
    self.x = snap(player.x)
    self.y = snap(player.y + 8)

    if self.dragging then
      self.dragging.x = self.x
      self.dragging.y = self.y
    end
  end

  function cursor:draw()
    rect(cursor.x, cursor.y, cursor.x + 8, cursor.y + 8, cursor.color)
  end

  return cursor
end

function title_screen()
  local state = {

  }

  function state:update()
  end

  function state:handle_input()
    if btn(a_btn) and btn(b_btn) then
      global_state = main_screen()
    end
  end

  function state:draw()
    cls()
    print("pRESS z + x", 32, 64)
  end

  return state
end

function main_screen()
  local state = {
    player = Player(),
    cursor = Cursor(),
    inventory = Inventory(),
    dummy = DummyObject(10, 10)
  }

  function state:handle_input()
  end

  function state:update()
    self.player:update()
    self.cursor:update(self.player)
    self.inventory:update(self.cursor)
    self.dummy:update(self.cursor)
  end

  function state:draw()
    cls() -- clears the screen
    draw_grid()
    self.inventory:draw()
    self.cursor:draw()
    self.player:draw()
    self.dummy:draw()
  end

  return state
end

function snap(i)
  return flr(i / 8) * 8
end

function draw_grid()

 -- vertical lines
  for i = 0,120,8
  do
    line(i, 0, i, 128, cl_darkgray)
  end

-- horizontal lines
  for i = 0,120,8
  do
    line( 0, i, 128, i, cl_darkgray)
  end
end

function is_between(obj1, obj2, range)
 return obj1.x < (obj2.x + range) and obj1.x >= obj2.x and obj1.y < (obj2.y + range) and obj1.y >= obj2.y
end

function _init()
  global_state = title_screen()
end


function _update()
  global_state:handle_input()
  global_state:update()
end

function _draw()
  global_state:draw()
end

__gfx__
00000000bbbbbbcb0000eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008bb8b8c8000eeeee00099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007008c88c8c800eeeeee00988890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008c88c84800eeeeee00199910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008848c8480eeee00000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007004844884800ee000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004444480000e0000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000099900000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000099900099000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000009900000000990000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000990000000000009000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000900000000000009000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000009000000000000000900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000099000009000000000000000090000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000009900990090000000000000000090000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000090000090090000000000000000009000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000900000090900000000000000000000900000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000009000000909ccc00000000000000000090000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000090000000ccc000c0000000000000000090000000000000000000000000000000000000000000000000000000000
00000000000000000cccccccccccc000000009000000c9090000c000000000000000009000000000000000000000000000000000000000000000000000000000
00000000000000000c00000000000cccccccccccc00c090900000c00000000000000009000000000000000000000000000000000000000000000000000000000
00000000000000000c00000000000000000000000ccc009900000c00000999999000009000000000000000000000000000000000000000000000000000000000
00000000000000000c00000000000000000000000c00ccccc0000c00999000009000009000000000000000000000000000000000000000000000000000000000
000000000000000000c000000000000000000000cccc009cccc00c09000000000000009000000000000000000000000000000000000000000000000000000000
000000000000000000c000000000000000000cccc000009000ccccc9999900000000009000000000000000000000000000000000000000000000000000000000
0000000000000000000c000000000000000cc00c00000090000c00ccc09000000000009000000000000000000000000000000000000000000000000000000000
0000000000000000000c00000000000000c0000c000000900000c9c00cc000000000009000000000000000000000000000000000000000000000000000000000
00000000000000000000c00000000000cc0000c0000000900000ccccccccccccc000009000000000000000000000000000000000000000000000000000000000
00000000000000000000c0000000000c000000c000000090cccccc9000000000c000009000000000000000000000000000000000000000000000000000000000
000000000000000000000c00000000c0000000c0000000cc0009cc00000000000000009000000000000000000000000000000000000000000000000000000000
000000000000000000000c0000000c0000000c000000cc090099cc00000000000000009000000000000000000000000000000000000000000000000000000000
0000000000000000000000c0000cc00000000c0000cc0000999c0c00000000000000090000000000000000000000000000000000000000000000000000000000
0000000000000000000000c000c0000000000c00cc000000009cc000000000000000090000000000000000000000000000000000000000000000000000000000
0000000000000000000000c00c0000000000000c0000000000c0c000000000000000090000000000000000000000000000000000000000000000000000000000
00000000000000000000000cc00000000000000c0000000000c0c000000000000000090000000000000000000000000000000000000000000000000000000000
00000000000000000000000cc0000000000000c0000000000c9c0000009000000000900000000000000000000000000000000000000000000000000000000000
00000000000000000000000cc0000000000000c00000000cc09c0000000000000009900000000000000000000000000000000000000000000000000000000000
00000000000000000000000cc0000000000000c000000cc000c90000000000000990000000000000000000000000000000000000000000000000000000000000
0000000000000000000000c00c000000000000ccccccc00000c99000000000999000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000c000c0000000000000000000000c000999999999000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000c00000c000000000000000000000c000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000c000000c0000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000c00000000c0000000000000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000c000000000cc0000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000c00000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000c000000000000000000000cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000c00000000000000000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000c0000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000cccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000005152535455565758000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001020304050607080708060708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0011121314151617181718161718060708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0021222324252627282728262728161718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0031323334353637383738363738262728000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0041424344010203040102030405060708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0051525354111213141112131415161718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0061626364212223242122232425262728000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0071727374313233343132333435363738000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000414243444142434445464748000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000515253545152535455565758000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000616263646162636465666768000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000717273747172737475767778000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002205017050170501305014050170501905010050100501105019050130500e6501e05014050270501f460140701e0701d07023070150701d0701d07020070180701b070240501a0401c0501b0501b050
