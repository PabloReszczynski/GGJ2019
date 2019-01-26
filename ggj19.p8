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

function player()
 local player = {
  x = 64,
  y = 64,
  vx = 2,
  vy = 2,
  sprite = 38
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

function inventory()
 local inventory = {
  x = 40,
  x_end = 88,
  y = 104,
  y_end = 128,
  visible = false,
  slots = {
    inventoryslot(6, 14),
    inventoryslot(7, 14),
    inventoryslot(8, 14),
    inventoryslot(9, 14),
  },
 }

 function inventory:update(cursor)
  if is_between(cursor,self, 48) then
   self.visible = true
   foreach(self.slots, function(slot) slot:update(cursor.dragging) end)
  else
   self.visible = false
  end
 end

 function inventory:draw()
  if self.visible then
   rectfill(self.x,self.y,self.x_end,self.y_end, cl_yellow)
   foreach(self.slots, function(slot) slot:draw() end)
  end
 end

 return inventory
end

function inventoryslot(x, y)
 local slot = {
  object = nil,
  x = x * 8,
  y = y * 8,
 }

 function slot:update(object)
  if object then
    if is_between(self, object, 8) then
     self.object = object
     self.object.inventory = true
    elseif self.object == object then
      self.object = nil
      object.inventory = false
    end
  end
 end

 function slot:draw()
  spr(4, self.x, self.y)
  if self.object then
    self.object:draw()
  end
 end

 return slot
end

function dummyobject(x, y)
 local dummy_object = {
  x = snap(x),
  y = snap(y),
  sprite = 3,
  draggable = false,
  dragged = false,
  inventory = false
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

function cursor()
 local cursor = {
  x = 0,
  y = 0,
  color = cl_blue,
  dragging = nil,
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
  print("press z + x", 32, 64)
 end

 return state
end

function main_screen()
 local state = {
  player = player(),
  cursor = cursor(),
  inventory = inventory(),
  dummy = dummyobject(10 * 8, 10 * 8)
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
  map(0,0,0,0,16,16)
  --draw_grid()
  self.inventory:draw()
  self.cursor:draw()
  self.player:draw()
  if not(self.dummy.inventory) then
    self.dummy:draw()
  end
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
0040000000000000044444444444440011111111a9aaaaa9000000001111111100dddd0000000000000000000000000000000000000000000000000000000000
0044444402222220042555552425240055555555966666660055550011111111dd33335d00000000000000000000000000000000000000000000000000000000
00444677044444400425555524111400dddddddda666666605d66d50111111113663366300000000000000000000000000000000000000000000000000000000
0047767704566540042555552444440055555555a66666660dda9dd0111111113a933a9300000000000000000000000000000000000000000000000000000000
06777766044444400425555524252400dddddddda66666660dd55dd0111111113663366300000000000000000000000000000000000000000000000000000000
0677777704200240042555552411140055555555a666666606666660111111113333333300000000000000000000000000000000000000000000000000000000
06766677042002400425555524444400dddddddda66666660aa99aa0111111113439aa9300000000000000000000000000000000000000000000000000000000
06777777042002400425555524252400555555559666666605555550111111113436666300000000000000000000000000000000000000000000000000000000
06767777007777700421111124111400dddddddd96666666dddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
0677776607777776044444444444440055555555a6666666d666666dd666666d0000000000000000000000000000000000000000000000000000000000000000
06777677477777760455545554252400dddddddda6666666daa99aaddaa99aaddddddddd00000000000000000000000000000000000000000000000000000000
067777774666666d045d545d5411140055555555a6666666d555555dd555555d5555555500000000000000000000000000000000000000000000000000000000
06766666444444440456545654444400dddddddda6666666dddddddddddddddd5555555500000000000000000000000000000000000000000000000000000000
0444444444444444045554555456540055555555a6666666d666666dd666666d5d555dd500000000000000000000000000000000000000000000000000000000
04200000420000000444444444444400dddddddda6666666d9a22a9ddaa99aad51515a9500000000000000000000000000000000000000000000000000000000
042000004200000004200000000024005555555596666666d552255dd555555d5551555500000000000000000000000000000000000000000000000000000000
000dd000dddddddddddddddd66666666666666667777777700777000111111110000000000000000000000000000000000000000000000000000000000000000
000dd000d66667d6666d667666667776676667767777777707777700555555550000000000000000000000000000000000000000000000000000000000000000
000dd0006d6d66676dd66d666677677777767777777777770777777055555555dddddddd00000000000000000000000000000000000000000000000000000000
000660006666dd66766d766666777777777777777777777707777770565656565555555500000000000000000000000000000000000000000000000000000000
00d66d0067d676666d66dd6d67777777777777777777777707777757555555555555555500000000000000000000000000000000000000000000000000000000
0d6666d0d66d6d6766d66676677777777777777777777777075757075555555555ddd55500000000000000000000000000000000000000000000000000000000
069aa96066d6666666676dd6677777777777777777777777070707001111111155a9a51500000000000000000000000000000000000000000000000000000000
000aa0006766667d7666667d67777777777777777777777707070700dddddddd5555551500000000000000000000000000000000000000000000000000000000
04444444d766766dd666666766666666666666666666666600777000111111110000000000000000000000000000000000000000000000000000000000000000
02222222666d6d666d76dd6676667676777667666676666707777700555555510000000000000000000000000000000000000000000000000000000000000000
444444447d6666d7666d66767776777777777766677766770777777055555511dddddddd00000000000000000000000000000000000000000000000000000000
45dddd67666d6d667d6666d677777777777776767777677705777770656551115555555500000000000000000000000000000000000000000000000000000000
4444444466d67666d666d66677777777777777667777777775777770555511115a55555500000000000000000000000000000000000000000000000000000000
45dddd67d66d66d666d766d67777777777777776777777777777777055511111595dd5d500000000000000000000000000000000000000000000000000000000
444444446d66d6666d6d666d77777777777777767777777707575700111111115151151500000000000000000000000000000000000000000000000000000000
400000006676667d6666dd7677777777777777767777777700000000dddddddd5155555500000000000000000000000000000000000000000000000000000000
__map__
0707060606070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2708161717282818081818181818180800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2324242424242424242424242424243408000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2525252525252525252525252525252518000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2525252525252525252525252525252528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2525252525252525252525252525252508000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313131313131313131313118000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313131313131313131313128000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313131313131313131313138000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000414243444142434445464748000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000515253545152535455565758000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000616263646162636465666768000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000717273747172737475767778000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002205017050170501305014050170501905010050100501105019050130500e6501e05014050270501f460140701e0701d07023070150701d0701d07020070180701b070240501a0401c0501b0501b050
