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
ENTITIES ||= {
  "#": "/sprites/rooms/wall.png",
  "c": "/sprites/rooms/collectable.png",
  "b": "/sprites/rooms/box.png",
  "k": "/sprites/rooms/.png",
  "d": "/sprites/rooms/door.png",
  "x": "/sprites/enemies/enemies.png",
  "s": "/sprites/rooms/start.png",
  "e": "/sprites/rooms/exit.png",
  " ": "/sprites/rooms/empty.png"
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
  "#  d   #            s",
  "########   ##########",
  "#  x                #",
  "#  x                #",
  "#  x                #",
  "#####################"
].reverse

def populate_room(args, room, entities)
  args.state.player = []
  args.state.walls = [] 
  args.state.enemies = []
  args.state.doors = []
  args.state.boxes = []
  args.state.start = []
  args.state.goal = []
  args.state.collectables = []
  args.state.empty = []

  room.each_with_index { |row,i| 
    row.split("").each_with_index { |c,ii| 
      case c 
      # PLAYER
      when "p"
        args.state.player << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      # WALLS
      when "#"
        args.state.walls << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      # BOXES
      when "b"
        args.state.boxes << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      # START POINTS 
      when "s"
        args.state.start << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      # DOOR 
      when "d"
        args.state.doors << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      # GOAL POINT
      when "e"
        args.state.goal << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i , SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite

      when "c"
        args.state.collectables << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i ,SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite
      
      when " "
        args.state.empty << [ SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + "#{ii * TILE_SIZE}".to_i ,SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + "#{i * TILE_SIZE}".to_i , TILE_SIZE , TILE_SIZE, ENTITIES[:"#{c}"] ].sprite


      end
    }
  }

  end

def render_room(args, room, entities)
  args.outputs[:scene].primitives << args.state.walls if args.state.walls != [] 
  args.outputs[:scene].primitives << args.state.boxes if args.state.boxes != [] 
  args.outputs[:scene].primitives << args.state.collectables if args.state.collectables != [] 
  args.outputs[:scene].primitives << args.state.start if args.state.start != [] 
  args.outputs[:scene].primitives << args.state.doors if args.state.doors != [] 
  args.outputs[:scene].primitives << args.state.goal if args.state.goal != [] 
  args.outputs[:scene].primitives << args.state.empty if args.state.empty != []
end

def spawn_particles args
  # timer = 0
  # args.state.particles = {}
  args.outputs[:scene].primitives << { x: 360, y: 640, w: TILE_SIZE, h: TILE_SIZE, path: "/sprites/misc/dragon-0.png" }.sprite!
  puts "PUFT!"
  # timer += (args.state.tick_count / 1000).clamp(0,1); puts timer unless timer >= 1

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

  # args.state.nokia_bg                ||= { x: (1280-VIRTUAL_SCREEN_WIDTH)/2-35, 
  #                                          y: (720-VIRTUAL_SCREEN_HEIGHT)/2-142, 
  #                                          w: 640/4,
  #                                          h: 1177/4.5, 
  #                                          path: '/sprites/misc/Nokia_3310.png' }
  

  # create background with color 1
  args.state.background              ||= { x: (1280-VIRTUAL_SCREEN_WIDTH)/2, 
                                           y: (720-VIRTUAL_SCREEN_HEIGHT)/2, 
                                           w: VIRTUAL_SCREEN_WIDTH, 
                                           h: VIRTUAL_SCREEN_HEIGHT, 
                                           r: args.state.cores.primaria[:r], 
                                           g: args.state.cores.primaria[:g], 
                                           b: args.state.cores.primaria[:b] }


  # create player with color 2
  args.state.player                  ||= { x: 1280/2, 
                                           y: 720/2,
                                           w: TILE_SIZE, 
                                           h: TILE_SIZE,  
                                           path: "/sprites/player/player0.png", 
                                           flip_horizontally: true }
end

# all renders goes here
def render args
  # variables you can play around with
  args.state.world.w                 ||= 1280
  args.state.world.h                 ||= 720

  # render scene
  args.outputs[:scene].w             ||= args.state.world.w
  args.outputs[:scene].h             ||= args.state.world.h

  # render game objects
  # args.outputs[:scene].primitives     << args.state.nokia_bg.sprite! 
  args.outputs[:scene].primitives     << args.state.back.sprite!
  args.outputs[:scene].primitives     << args.state.background.sprite!
  
  # RENDER ROOMS
  populate_room(args, ROOM001, ENTITIES) unless args.state.tick_count != 0

  render_room(args, ROOM001, ENTITIES) unless args.state.tick_count == 0

  
  args.outputs[:scene].primitives     << args.state.player.sprite
  
  args.outputs[:scene].primitives     << [360, 640, 16, 16, 200, 20, 39 ].solid
    
  args.outputs.primitives << [370, 598, "#{args.gtk.current_framerate.to_sf}", 16, 1, args.state.cores.primaria[:r], args.state.cores.primaria[:g], args.state.cores.primaria[:b], 255, 'fonts/dragonruby-gtk-4x4.ttf'].label
  
  # RENDER CAMERA
  render_camera args 

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
  player_temp = args.state.player.shift_rect(args.inputs.left_right, args.inputs.up_down)
  player_box = [ player_temp.x, player_temp.y, player_temp.w, player_temp.h]

  if (args.state[:collectables].any_intersect_rect?(player_box))
    args.state.collectables.pop
    args.state.doors.pop
  end

  # set X boundaries
  if args.state.player.x < SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + TILE_SIZE
    args.state.player.x = SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH/2 + TILE_SIZE
  elsif args.state.player.x > SCREEN_CENTER_H + VIRTUAL_SCREEN_WIDTH/2 - TILE_SIZE * 2
    args.state.player.x = SCREEN_CENTER_H + VIRTUAL_SCREEN_WIDTH/2 - TILE_SIZE * 2
  end

  # set Y boundaries
  if args.state.player.y < SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + TILE_SIZE
    args.state.player.y = SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT/2 + TILE_SIZE
  elsif args.state.player.y > SCREEN_CENTER_V + VIRTUAL_SCREEN_HEIGHT/2 - TILE_SIZE * 2
    args.state.player.y = SCREEN_CENTER_V + VIRTUAL_SCREEN_HEIGHT/2 - TILE_SIZE * 2
  end
end

# manage all inputs
def inputs args, *vector
 
  args.state.player.x += args.inputs.left_right * args.state.speed
  args.state.player.y += args.inputs.up_down * args.state.speed

  # TODO - spawn particles when moving

  # flip sprite
  if args.inputs.left
    args.state.player.flip_horizontally = true
  elsif args.inputs.right
    args.state.player.flip_horizontally = false
  end

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
  # looping_animation args
  render args
  calc_collisions args
  inputs args
end

# refresh all variables
$gtk.reset
