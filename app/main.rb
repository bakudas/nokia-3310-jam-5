# VacaRoxa at NOKIAJAM
#
# A little game for a nokia game jam
# https://itch.io/jam/nokiajam5
# cc0@bakudas

# all consts
TILE_SIZE = 4
SCREEN_CENTER_H = 1280/2
SCREEN_CENTER_V = 720/2
SCREEN_MULTIPLIER = 10
VIRTUAL_SCREEN_WIDTH = 84
VIRTUAL_SCREEN_HEIGHT = 48

# level entities 
ENTITIES = {
  "#": "/sprites/rooms/wall.png",
  "c": "/sprites/rooms/collectable.png",
  "b": "/sprites/rooms/box.png",
  "k": "/sprites/rooms/.png",
  "d": "/sprites/rooms/door.png",
  "x": "/sprites/enemies/enemies.png",
  "s": "/sprites/rooms/start.png",
  "e": "/sprites/rooms/exit.png",
  " ": "/sprites/rooms/empty.png",
  "p": "/sprites/player/player0.png"
}

# level design
ROOM001 = [
  "##########s##########",
  "#bbbbbbb  p  bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "e      d     bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#bbbbbbb  c  bbbbbbb#",
  "#bbbbbbb     bbbbbbb#",
  "#####################"
].reverse

ROOM002 = [
  "#####################",
  "#c                  #",
  "####   #####    x   #",
  "e  #   #            #",
  "#  #   #   ##########",
  "#  #   #            #",
  "#  d   #           ps",
  "########   ##########",
  "#  x                #",
  "#  x                #",
  "#  x                #",
  "#####################"
].reverse

ROOM003 = [
  "#####################",
  "#                   #",
  "#      bbbb    x    #",
  "#      b           ps",
  "#bbb   b   bbbbbbbbb#",
  "e  b   b            #",
  "#  d   b         c  #",
  "#bbbbbbb            #",
  "#bbbbbbb    bbbbbbbb#",
  "#bbbbbbb    bbbbbbbb#",
  "#bbbbbbb    bbbbbbbb#",
  "#####################"
].reverse

ROOMS = [ROOM001, ROOM002, ROOM003]

def populate_room(args, room)
  args.state.player = []
  args.state.walls = [] 
  args.state.enemies = []
  args.state.doors = []
  args.state.boxes = []
  args.state.start = []
  args.state.goal = []
  args.state.collectables = []
  args.state.empty = []

  temp_tile = []

  room.each_with_index { |row,i| 

    row.split("").each_with_index { |char,ii| 
      
      temp_tile = [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{char}"] ].sprite

      case char 

      # PLAYER
      when "p"
        args.state.player << temp_tile

      # WALLS
      when "#"
        args.state.walls << temp_tile

      # BOXES
      when "b"
        args.state.boxes << temp_tile

      # START POINTS 
      when "s"
        args.state.start << temp_tile

      # DOOR 
      when "d"
        args.state.doors << temp_tile

      # GOAL POINT
      when "e"
        args.state.goal << temp_tile

      when "c"
        args.state.collectables << temp_tile      

      when " "
        args.state.empty << temp_tile
      end
    }
  }

  end

def render_room args
  args.outputs[:scene].primitives << args.state.walls if args.state.walls != [] 
  args.outputs[:scene].primitives << args.state.boxes if args.state.boxes != [] 
  args.outputs[:scene].primitives << args.state.collectables if args.state.collectables != [] 
  args.outputs[:scene].primitives << args.state.start if args.state.start != [] 
  args.outputs[:scene].primitives << args.state.doors if args.state.doors != [] 
  args.outputs[:scene].primitives << args.state.goal if args.state.goal != [] 
  args.outputs[:scene].primitives << args.state.empty if args.state.empty != []
  args.outputs[:scene].primitives << args.state.player if args.state.player != []
end

def spawn_particles args
  # TODO spawn particles
end

# initial setup
def init args
  # set camera 
  args.state.camera.x                ||= -1280 * 4.5
  args.state.camera.y                ||= -720 * 4.5
  args.state.camera.scale            ||= 10.0
  args.state.camera.show_empty_space ||= :yes

  # set speed
  args.state.speed                   ||= 1
  
  # set colors
  args.state.cores                   ||= { primaria: { r: 199, g: 240, b: 216 },
                                           secundaria: { r: 67, g: 82, b: 61 } }

  args.state.back                    ||= { x: 0, 
                                           y: 0, 
                                           w: 1280, 
                                           h: 720, 
                                           r: 35, 
                                           g: 35, 
                                           b: 35 }

  # create background with color 1
  args.state.background              ||= { x: (1280-VIRTUAL_SCREEN_WIDTH)/2, 
                                           y: (720-VIRTUAL_SCREEN_HEIGHT)/2, 
                                           w: VIRTUAL_SCREEN_WIDTH, 
                                           h: VIRTUAL_SCREEN_HEIGHT, 
                                           r: args.state.cores.primaria[:r], 
                                           g: args.state.cores.primaria[:g], 
                                           b: args.state.cores.primaria[:b] }

  # set collectables
  args.state.score                   ||= 0

  # set current ROOM
  args.state.level                   ||= 0
  args.state.current_room            ||= ROOMS[args.state.level]
  
end

# all renders goes here
def render args
  # set world variable
  args.state.world.w                 ||= 1280
  args.state.world.h                 ||= 720

  # RENDER VIRTUAL SCENE
  args.outputs[:scene].w             ||= args.state.world.w
  args.outputs[:scene].h             ||= args.state.world.h

  # RENDER BG STUFF
  args.outputs[:scene].primitives     << args.state.back.sprite!
  args.outputs[:scene].primitives     << args.state.background.sprite!
  
  # RENDER ROOMS
  update_room(args, args.state.level) unless args.state.tick_count != 0
  render_room args unless args.state.tick_count == 0

  # RENDER PLAYER
  args.outputs[:scene].primitives     << args.state.player.sprite
  
  # RENDER FPS TEXT
  args.outputs.primitives << [370, 598, "#{args.gtk.current_framerate.to_sf}", 16, 1, args.state.cores.primaria[:r], args.state.cores.primaria[:g], args.state.cores.primaria[:b], 255, 'fonts/dragonruby-gtk-4x4.ttf'].label
  
  args.outputs.primitives << [370, 698, "#{args.state.score}", 16, 0, args.state.cores.primaria[:r], args.state.cores.primaria[:g], args.state.cores.primaria[:b], 255, 'fonts/dragonruby-gtk-4x4.ttf'].label

  # RENDER CAMERA
  render_camera args 

end

def update_room(args, level)
  args.state.current_room = ROOMS[level]
  populate_room(args, args.state.current_room)
end

def render_camera args
  scene_position                    = calc_scene_position args
  args.outputs.sprites              << { x: scene_position.x, 
                                         y: scene_position.y,
                                         w: scene_position.w, 
                                         h: scene_position.h, 
                                         path: :scene }
end

def calc_collisions args
  args.state.can_move ||= true
  
  player_temp = args.state.player.shift_rect(args.inputs.left_right, args.inputs.up_down)
  player_box = [ player_temp.x, player_temp.y, player_temp.w, player_temp.h]

  # WALLS
  if (args.state[:boxes].any_intersect_rect?(player_box) or 
      args.state[:walls].any_intersect_rect?(player_box) or
      args.state[:doors].any_intersect_rect?(player_box))
    args.state.can_move = false
  else
    args.state.can_move = true
  end

  # COLLECTABLES
  if (args.state[:collectables].any_intersect_rect?(player_box))
    args.state.collectables.pop
    args.state.doors.pop
    args.state.score += 1
  end

  # GOAL
  if (args.state[:goal].any_intersect_rect?(player_box))
    args.state.level += 1
    update_room(args, args.state.level)
  end

  # set X boundaries
  # if args.state.player.x < SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + TILE_SIZE
  #   args.state.player.x = SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + TILE_SIZE
  # elsif args.state.player.x > SCREEN_CENTER_H + VIRTUAL_SCREEN_WIDTH/2 - TILE_SIZE * 2
  #   args.state.player.x = SCREEN_CENTER_H + VIRTUAL_SCREEN_WIDTH/2 - TILE_SIZE * 2
  # end

  # set Y boundaries
  # if args.state.player.y < SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + TILE_SIZE
  #   args.state.player.y = SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + TILE_SIZE
  # elsif args.state.player.y > SCREEN_CENTER_V + VIRTUAL_SCREEN_HEIGHT/2 - TILE_SIZE * 2
  #   args.state.player.y = SCREEN_CENTER_V + VIRTUAL_SCREEN_HEIGHT/2 - TILE_SIZE * 2
  # end
end

# manage all inputs
def inputs args, *vector

  return unless args.state.can_move

  args.state.player.x += args.inputs.left_right * args.state.speed
  args.state.player.y += args.inputs.up_down * args.state.speed

  # TODO - spawn particles when moving

  # flip sprite
  # if args.inputs.left
  #   args.state.player.flip_horizontally = true
  # elsif args.inputs.right
  #   args.state.player.flip_horizontally = false
  # end

  # animation
  if args.inputs.left_right != 0 or args.inputs.up_down != 0
    looping_animation args 
  else
    args.state.player.path = "/sprites/player/player0.png"
  end

  args.state.camera.scale = args.state.camera.scale.greater(0.1)
end

def calc_scene_position args
  result = { x: args.state.camera.x,
             y: args.state.camera.y,
             w: args.state.world.w * args.state.camera.scale,
             h: args.state.world.h * args.state.camera.scale,
             scale: args.state.camera.scale }

  return result if args.state.camera.show_empty_space == :yes

  if result.w < args.grid.w
    result.merge!(x: (args.grid.w - result.w).half)
  elsif (args.state.player.x * result.scale) < args.grid.w.half
    result.merge!(x: 10)
  elsif (result.x + result.w) < args.grid.w
    result.merge!(x: - result.w + (args.grid.w - 10))
  end

  if result.h < args.grid.h
    result.merge!(y: (args.grid.h - result.h).half)
  elsif (result.y) > 10
    result.merge!(y: 10)
  elsif (result.y + result.h) < args.grid.h
    result.merge!(y: - result.h + (args.grid.h - 10))
  end

  result
end

def looping_animation args
  # Here we define a few local variables that will be sent
  # into the magic function that gives us the correct sprite image
  # over time. There are four things we need in order to figure
  # out which sprite to show.

  # 1. When to start the animation.
  start_looping_at = 1

  # 2. The number of pngs that represent the full animation.
  number_of_sprites = 4

  # 3. How long to show each png.
  args.state.x_scale ||= 1
  number_of_frames_to_show_each_sprite = 4

  # 4. Whether the animation should loop once, or forever.
  does_sprite_loop = true

  # With the variables defined above, we can get a number
  # which represents the sprite to show by calling the `frame_index` function.
  # In this case the number will be between 0, and 5 (you can see the sprites
  # in the ./sprites directory).
  sprite_index = start_looping_at.frame_index number_of_sprites,
                                              number_of_frames_to_show_each_sprite,
                                              does_sprite_loop

  args.state.player.path = "sprites/player/player#{sprite_index}.png"
end

# update func
def tick args
  init args
  render args
  calc_collisions args unless args.state.player == []
  inputs args unless args.state.player == []
end

# refresh all variables
$gtk.reset
