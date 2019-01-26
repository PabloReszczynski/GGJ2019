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


local v_flip_sprites = {
}

function draw_flip_sprite(o)
  spr(o.s, o.x * 8, o.y * 8, 1, 1, o.flip_x, o.flip_y)
end

function draw_flip_sprites()
  foreach(v_flip_sprites, draw_flip_sprite)
end

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

function dummycharacter()
 local dummy_character = {
  x = 16,
  y = 16,
  vx = 3,
  vy = 3,
  sprite = 10,
  description = "un gatito."
 }

 function dummy_character:update(state)
  if is_between(state.cursor, self, 8) then
   state.textbox.text = self.description
  end

  direction = flr(rnd(40))

  if direction == 0 and self.x <= 120 then
   move(self, self.vx, 0)
  end
  if direction == 1 and self.x >= 8 then
   move(self, -self.vx, 0)
  end
  if direction == 2 and self.y <= 112 then
   move(self, 0, self.vy)
  end
  if direction == 3 and self.y >= 0 then
    move(self, 0, -self.vy)
  end
 end

 function dummy_character:draw()
  spr(dummy_character.sprite, dummy_character.x, dummy_character.y)
 end

 return dummy_character
end

function mkmap(cel_x, cel_y, sx, sy, celw, celh, entities)
 local mapa = {entities = entities}

 function mapa:update(state)
  foreach(self.entities, function(e) e:update(state) end)
 end

 function mapa:draw()
  map(cel_x, cel_y, sx, sy, celw, celh)
  foreach(self.entities, function(e) e:draw() end)
 end

 return mapa
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

function textbox()
  local box = {
    x = 0,
    y = 80,
    width = 127,
    height = 16,
    text = ""
  }

  function box:update()
    self.text = ""
  end

  function box:draw()
    rect(self.x, self.y, self.x + self.width, self.y + self.height, cl_red)
    color(cl_darkgreen)
    print(self.text, self.x + 4, self.y + 4)
  end

  return box
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

function dummyobject(x, y, description)
 local dummy_object = {
  x = snap(x),
  y = snap(y),
  sprite = 1,
  draggable = false,
  dragged = false,
  inventory = false,
  description = description
 }

 function dummy_object:update(cursor, textbox)
  if is_between(cursor, self, 8) then
   self.draggable = true
   textbox.text = self.description
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

 function cursor:update(state)
  if btn(a_btn) then
   self.color = cl_red
   state.player.sprite = 54
   enter_zone(state, self.x, self.y)
  else
   self.color = cl_blue
   state.player.sprite = 38
  end
  self.x = snap(state.player.x)
  self.y = snap(state.player.y + 8)

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
  --dummy_character = dummycharacter(),
  cursor = cursor(),
  inventory = inventory(),
  dummy = dummyobject(10, 10, "un mueble."),
  textbox = textbox(),
  map = mkmap(0,0,0,0,16,16, {dummycharacter()}),
 }

 function state:handle_input()
 end

 function state:update()
  self.player:update()
  self.cursor:update(self)
  self.textbox:update()
  --self.dummy_character:update(self.cursor, self.textbox)
  self.map:update(self)
  self.inventory:update(self.cursor)
  self.dummy:update(self.cursor, self.textbox)
 end

 function state:draw()
  cls() -- clears the screen
  self.map:draw()
  draw_flip_sprites()
  self.inventory:draw()
  self.cursor:draw()
  --self.dummy_character:draw()

  if not(self.dummy.inventory) then
    self.dummy:draw()
  end
  self.textbox:draw()
  self.player:draw()
 end

 return state
end

function map_pos(x, y)
  return mget(flr(x / 8), flr((y - 1) / 8))
end

function move(object, dir_x, dir_y)
  local next_x = object.x + dir_x
  local next_y = object.y + dir_y
  local map_tile = map_pos(next_x, next_y)
  if not(fget(map_tile, 0)) then
    object.x = next_x
    object.y = next_y
  end
end

function enter_zone(state, dir_x, dir_y)
 local map_tile = map_pos(dir_x, dir_y)
 if (fget(map_tile, 1)) then
  state.map = bar
 elseif (fget(map_tile, 2)) then
  state.map = bakery
 elseif (fget(map_tile, 3)) then
  state.map = library
 elseif (fget(map_tile, 4)) then
  state.map = main_zone
 end
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
 return obj1.x < (obj2.x + range) and
  obj1.x >= obj2.x and
  obj1.y < (obj2.y + range) and
  obj1.y >= obj2.y
end

main_zone = mkmap(0, 0, 0, 16, 128, 128, 0, {dummycharacter()})
bar = mkmap(16, 0, 0, 16, 128, 128, 0, {dummycharacter()})
bakery = mkmap(16, 23, 0, 16, 128, 128, 0, {})
library = mkmap(16, 48, 0, 16, 128, 128, 0, {})


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
004000000000000004444444444444001111111111111111dddddddddddddddd11dddd111111188104004000a9aaaaa99aaaaa9a9aaaaaa99666666600000000
004444440222222004255555242524005555555511111111d666666d77777777dd33335d88888ee804444044966666666666666966666666a666666600000000
00444677044444400425555524111400dddddddd11111111daa99aaddfdfdfdf36633663eeeeeeee04949040a66666666666666a66666666a666666600000000
004776770456654004255555244444005555555511111111d555555dfdfdfdfd3a933a93eeeeeeee04444040a66666666666666a66666666a666666600000000
06777766044444400425555524252400dddddddd11111111dddddddd7777777736633663eee8e88e00440040a66666666666666a66666666a666666600000000
067777770420024004255555241114005555555511111111d666666d7777fff733333333e8eaea9e00440040a66666666666666a66666666a666666600000000
06766677042002400425555524444400dddddddd11111111daa99aad77179a973439aa93e1eeeeee00444440a66666666666666a666666669666666600000000
067777770420024004255555242524005555555511111111d555555d7717777734366663e1eeeeee00404000966666666666666966666666a9aaaaa900000000
06767777007777700421111124111400dddddddd11111111dddddddd111111111111111100777000111111119666666666666669dddddddd6666666900000000
067777660777777604444444444444005555555511111111d666666d11111111111111110777770015555555a66666666666666adddddddd6666666a00000000
06777677477777760455545554252400dddddddd11111111daa99aaddddddddddddddddd0777777011555555a66666666666666adddddddd6666666a00000000
067777774666666d045d545d541114005555555511111111d555555dd555555d555555550577777011155656a66666666666666adddddddd6666666a00000000
06766666444444440456545654444400dddddddd11111111dddddddddaa99aad555555557577777011115555a66666666666666adddddddd6666666a00000000
044444444444444404555455545654005555555511111111d666666dd666666d5d555dd57777777011111555a66666666666666adddddddd6666666a00000000
04200000420000000444444444444400dddddddd11111111d9a22a9ddaa99a1d51515a950757570011111111a66666666666666adddddddd6666666900000000
042000004200000004200000000024005555555511111111d552255dd555551d5551555500000000dddddddd9666666666666669dddddddd9aaaaa9a00000000
000dd000dddddddddddddddd66666666666666667777776666666666111111111111111100777000111111119dddddddddddddd9666666660000000000000000
000dd000d66667d6666d6676666677776776666677777776677667766dddddd6111111110777770055555555adddddddddddddda666666660000000000000000
000dd0006d6d66676dd66d666677777777776666777777667777677755555555dddddddd0777777055555555adddddddddddddda666666660000000000000000
000660006666dd66766d76666677777777777766777767667777777755a99a55555555550777777056565656adddddddddddddda666666660000000000000000
00d66d0067d676666d66dd6d6767777777777776777776667777777755511555555555550777775755555555adddddddddddddda666666660000000000000000
0d6666d0d66d6d6766d66676677777777777777677777766777777775551155555ddd5550757570755555555adddddddddddddda666666660000000000000000
069aa96066d6666666676dd667777777777777767777777677777777dddddddd55a9a5150707070011111111adddddddddddddda666666660000000000000000
000aa0006766667d7666667d66777777777777667777776677777777dddddddd5555551507070700dddddddd9dddddddddddddd99aaaaaa90000000000000000
04444444d766766dd666666767777777777777766677777777777777777777771111111166666666111111119dddddddddddddd9dddddddd9aaaaaa900000000
02222222666d6d666d76dd666777777777777776666777777777777777777777111111116766666755555551addddddddddddddadddddddddddddddd00000000
444444447d6666d7666d66766777777777777776666677777777777777777777dddddddd6776767755555511addddddddddddddadddddddddddddddd00000000
45dddd67666d6d667d6666d66677777777777766667777777777777777777777555555557777777765655111addddddddddddddadddddddddddddddd00000000
4444444466d67666d666d66667677777777776766777777777677777777777775a5555557777777755551111addddddddddddddadddddddddddddddd00000000
45dddd67d66d66d666d766d66677777777777766667777777767676777777777595dd5d57777777755511111addddddddddddddadddddddddddddddd00000000
444444446d66d6666d6d666d66766777777667666667777776676677777777775151151577777777111111119dddddddddddddd9dddddddddddddddd00000000
400000006676667d6666dd7666666666666666666777777766666666777777775155555577777777dddddddda9aaaaa99aaaaa9a9aaaaaa9dddddddd00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555111111150000000000000000000000000000000000eeee000050050009333330000000000e6d56e00007007000000000007000700000000751111111
5155555111115111000000000000000000000000000000000eeeeee00050050033888830000000000eeeeee00077777700400400077777700000077751115111
5151551111515111000000000000000000000000000000000deeeed05555555538333383000000000edddde007a777a70444444007a77a70000577a755111111
51515511115151110000000000000000000000000000000006dddd60dddddddd38398383000000000edabde00765576704444444775577700779977755515111
515155111111515100000000000000000000000000000000065005600888888038388383000000000edc8de007777777044a44a4777777700770777755151111
511155111111115177777777777777777777777777777770065005600000000038333983000aa0000edddde00077777009444dd4073777d0077bbbbb55151111
51111511151111517777777777777777777777777777771006500560000000003388883300a99a000eeeeee00c83888ca99434490d33dddd0777b77b51111511
5111151111111111888888888888888888888888888888100600006000000000033933300a9669a00e0000e0cc83388caa933399dd33d77d0077777b51111111
115111555555555575ddd75ddd75ddd775ddd75ddd75dd100888880000500500000330000e65d6e000a666000c7337ccaa4433aadd3377dd00bbbbbb51111111
115511111555555575ddd75ddd75ddd775ddd75ddd75dd100840088000500500083773800eeeeee00aadd990087337c8999344a9dd777ddd0bbbbbbb51111111
115555111151555575ddd75ddd75ddd775ddd75ddd75dd108840008055555555087777800edddde0aadd7d9908888888999999997ddddddd0bbbbbbb51111111
111551111151155175ddd75ddd75ddd775ddd75ddd75dd1084000000dddddddd08a66a800edcade0adda97d90888888809999999755ddd550bbbbbbb51111111
511551151151151175ddd75ddd75ddd775ddd75ddd75dd10840000000eeeeee0087777800ed8bde06dd9add908888880099999400555555500bbbbbb51111111
515151151111111175ddd75ddd75ddd775ddd75ddd75dd108840008000000000087337800edddde06dda9dd6008000800490054400555550000bb77051111111
511151151111115175ddd75ddd75ddd775ddd75ddd75dd000840088000000000083773800eeeeee006da9d607770007704440560007707700000077051111111
5111111511111151700007000070000770000700007000000888880000000000000330000e8008e006da9d600000000006000060007707700007777051111111
55111111111111110077776666666677dddddddddddddddd0eeeee0000500500033333300e6d56e0065a956000070070000000000040040004004000d777777d
55111111111111110777677767667776dddddddddddddddd0e400ee000500500333333330eeeeee0066a96600077777700006060044444400444440072111127
51111111111111117772ddddddddddddddddddddddddddddee4000e055555555399aa9930edddde006d66d6007a777a700066660044a44a40a44a44072111127
51111111111111117722dddddddddddddd3ddd3ddddddddde4000000dddddddd399a89930ed8cde0065dd560076777670d6a66660444dd444444444472551127
55511111111111117722ddddddddddddd333d33d3ddd33dde40000000ffffff0399aa9930edbade0065a95600775577706666666cc44444c44dd444a72555127
55111511111111117622ddddddddddddd333d33d33dd33ddee4000e000000000333333330edddde0066a9660007777700066ffef4ccc44cc044444aa72955527
51111111111111117622dddddddddddd53335335335533550e400ee000000000303333030eeeeee006d66d600c88888c0003feee44ccc3ccaa44aa887255a927
51111111111111117622dddddddddddd76766667677677670eeeee0000000000303003030e8008e0065dd5600c88888c0033feee44cc33ccaaaaa88872555527
51151555222222227622dddddddddddddddddddddddddddd0fffff00000eeeee033333300e65d6e0065a95600c88888c0a66eeaa44cc33c4aaaaaa8872555527
51111551111111116722dddddddddddddddddddddddddddd0f400ff000eeeeee333333330eeeeee0066a96600c88888c0a33aaaa44993444aaaaaa4472a95527
51511551111111117622ddddddddddddddddddddddddddddff4000f006666666399aa9930edddde006d66d6077888877aaaaaaa0999999990aaaa44072555527
51511511111111117622ddddddddd3ddddd3dddddd3dddddf4000000065000003998a9930edb8de0065dd56078888877a6dddd60099999990119944172555527
51551111111111117622ddddd33d33dd33d33d33d333d3d3f400000006500000399aa9930edacde0065a956008888880a6500560065995990111111172dddd27
55551151111111117722ddddd33d33dd33d33d33d333d333ff4000f006500000333333330edddde0665a95660088880006500560065445440110001172dddd27
5555115111111111672555555335335533533533533353330f400ff006500000303333030eeeeee0d666666d0080080006500560065005600440004472111127
5555555511111111677666767767666766676766677666770fffff0006000000303003030e8008e00dddddd00770077006000060060000604440044422111122
__gff__
0101010100000100010000000000000001010101000003010100000000000000000000000000000101000000000000000100000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1606071817160818271606381817090508040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a08040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2326262626262626262626262626262408040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3537373737373737373737373737372518040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3537373737373737373737373737372528040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3537373737373737373737373737372508040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
35373737373737373737373737373725182a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33363636363636363636363636363634282a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2122212221222122212221222122222238000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131323131313131313131313131323248000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0d0d0d0d0d0d0d0d0d0d0d0d0d0d0c58000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e2d2d2d2d2d2d2d2d2d2d2d2d2d2d1e68000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b1d1d1d1d1d1d1d1d1d1d1d1d1d1d2c78000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b1d1d1d1d1d1d1d1d1d1d1d1d1d1d2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b1d1d1d1d1d1d1d1d1d1d1d1d1d1d2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3d3d3d3d3d3d3d3d3d3d3d3d3d3d3c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002205017050170501305014050170501905010050100501105019050130500e6501e05014050270501f460140701e0701d07023070150701d0701d07020070180701b070240501a0401c0501b0501b050
