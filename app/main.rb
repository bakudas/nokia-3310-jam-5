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
  "#####################",
  "##########s##########",
  "#bbbbbbbb   bbbbbbbb#",
  "#bbbbbbbb p bbbbbbbb#",
  "#bbbbbbbb   bbbbbbbb#",
  "#           bbbbbbbb#",
  "e           bbbbbbbb#",
  "#           bbbbbbbb#",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#####################"
].reverse

ROOM002 = [
  "#####################",
  "#####################",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#bbb    c     d     #",
  "#                   #",
  "e                 p s",
  "#                   #",
  "#bbb    d     c     #",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#bbbbbbbbbbbbbbbbbbb#",
  "#####################"
].reverse

ROOM003 = [
  "#####################",
  "#####################",
  "#      b        x   #",
  "e      b        c   #",
  "#      b    bbbbbbbb#",
  "#      b            #",
  "#      b          p s",
  "#      b            #",
  "#      b d bbbbbbbbb#",
  "#          bbbbbbbbb#",
  "#          bbbbbbbbb#",
  "#####################"
].reverse

ROOM004 = [
  "#####################",
  "#                   #",
  "# c x             p #",
  "#                   s",
  "#bbbb       bbbbbbbb#",
  "e   b       b       #",
  "#   b            c  #",
  "#   d       d       #",
  "#   d       bbbbbbbb#",
  "#bbbbbb     bbbbbbbb#",
  "#bbbbbb  c  bbbbbbbb#",
  "#####################"
].reverse

ROOMS = [ROOM001, ROOM002, ROOM003, ROOM004]

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
  args.outputs[:scene].primitives << args.state.empty if args.state.empty != []
  args.outputs[:scene].primitives << args.state.walls if args.state.walls != [] 
  args.outputs[:scene].primitives << args.state.boxes if args.state.boxes != [] 
  args.outputs[:scene].primitives << args.state.collectables if args.state.collectables != [] 
  args.outputs[:scene].primitives << args.state.start if args.state.start != [] 
  args.outputs[:scene].primitives << args.state.doors if args.state.doors != [] 
  args.outputs[:scene].primitives << args.state.goal if args.state.goal != [] 
  args.outputs[:scene].primitives << args.state.player if args.state.player != []
end

def spawn_particles args
  # TODO spawn particles
end

# initial setup
def init args
  # set camera 
  args.state.camera.x                 ||= -1280 * 4.5
  args.state.camera.y                 ||= -720 * 4.5
  args.state.camera.scale             ||= 10.0
  args.state.camera.show_empty_space  ||= :yes
  
  # PLAYER MECHANICS
  args.state.is_moving                ||= false
  args.state.is_kicking               ||= false
  args.state.can_move                 ||= true
  args.state.can_kick                 ||= false
  args.state.can_put                  ||= false
  args.state.carry_max                ||= 1

  # set speed
  args.state.speed                    ||= 1
  
  # set colors
  # SET 01
  args.state.cor_primaria             ||= { r: 199, g: 240, b: 216 }
  args.state.cor_secundaria           ||= { r: 67, g: 82, b: 61 }

  args.state.back                     ||= { x: 0, 
                                            y: 0, 
                                            w: 1280, 
                                            h: 720, 
                                            r: 35, 
                                            g: 35, 
                                            b: 35 }

  # create background with color 1
  args.state.background               ||= { x: (1280-VIRTUAL_SCREEN_WIDTH)/2, 
                                            y: (720-VIRTUAL_SCREEN_HEIGHT)/2, 
                                            w: VIRTUAL_SCREEN_WIDTH, 
                                            h: VIRTUAL_SCREEN_HEIGHT, 
                                            r: args.state.cor_primaria[:r],
                                            g: args.state.cor_primaria[:g],
                                            b: args.state.cor_primaria[:b] }

  # set collectables
  args.state.score                    ||= 0

  # set current ROOM
  args.state.level                    ||= 0
  args.state.current_room             ||= ROOMS[args.state.level]
  
end

# all renders goes here
def render args
  # set world variable
  args.state.world.w                  ||= 1280
  args.state.world.h                  ||= 720

  # RENDER VIRTUAL SCENE
  args.outputs[:scene].w              ||= args.state.world.w
  args.outputs[:scene].h              ||= args.state.world.h

  # RENDER BG STUFF
  args.outputs[:scene].primitives     << args.state.back.sprite!
  args.outputs[:scene].primitives     << args.state.background.sprite!
  
  # RENDER ROOMS
  update_room(args, args.state.level) unless args.state.tick_count != 0
  render_room args                    unless args.state.tick_count == 0

  # PLAYER STUFF
  args.state.player.w                 = 8
  args.state.player.h                 = 8
  
  # RENDER PLAYER
  args.outputs[:scene].primitives     << args.state.player.sprite
  
  # RENDER TEXTS
  if args.state.can_kick
    args.outputs[:scene].labels       << [ (1280+VIRTUAL_SCREEN_WIDTH)/2+1, 
                                           (720+VIRTUAL_SCREEN_HEIGHT)/2+1, 
                                           "KICK IT!", 
                                           -8, 
                                           2, 
                                           args.state.cor_primaria[:r], 
                                           args.state.cor_primaria[:g], 
                                           args.state.cor_primaria[:b], 
                                           255, 
                                           'fonts/tiny.ttf' ].label
  end

  args.outputs[:scene].labels         << [ (1280-VIRTUAL_SCREEN_WIDTH)/2, 
                                           (720+VIRTUAL_SCREEN_HEIGHT)/2+1, 
                                           "ROOM_#{args.state.level}", 
                                           -8, 
                                           0, 
                                           args.state.cor_primaria[:r], 
                                           args.state.cor_primaria[:g], 
                                           args.state.cor_primaria[:b], 
                                           255, 
                                           'fonts/tiny.ttf' ]
  
  # RENDER CAMERA
  render_camera args 

end

# UPDATE THE GAME OBJECTS FORM THE ROOMS
def update_room(args, level)
  args.state.current_room             = ROOMS[level]
  populate_room(args, args.state.current_room)
end

# RENDER THE VIRTUAL CAMERA
def render_camera args
  scene_position                      = calc_scene_position args
  args.outputs.sprites                << { x: scene_position.x, 
                                           y: scene_position.y,
                                           w: scene_position.w, 
                                           h: scene_position.h, 
                                           path: :scene }
end

def calc_collisions args
  # PLAYER BOUNDING BOX
  player_temp                         = args.state.player.shift_rect(args.inputs.left_right, args.inputs.up_down)
  args.state.player_box               = [ player_temp.x, player_temp.y, player_temp.w, player_temp.h]

  # WALLS
  if (args.state[:boxes].any_intersect_rect?(args.state.player_box) or 
      args.state[:walls].any_intersect_rect?(args.state.player_box) or
      args.state[:doors].any_intersect_rect?(args.state.player_box) or
      args.state[:collectables].any_intersect_rect?(args.state.player_box))
    
    args.state.can_move               = false
  else
    args.state.can_move               = true
  end
  
  # DOORS
  
  # COLLECTABLE 
  if (args.state[:collectables].any_intersect_rect? args.state.player_box) && !args.state.is_kicking
    args.state.can_kick               = true
  else
    args.state.can_kick               = false
  end
  
  # GOAL
  if (args.state[:goal].any_intersect_rect?(args.state.player_box))
    args.state.level                  += 1
    update_room(args, args.state.level)
  end
end

# manage all inputs
def inputs args, *vector
  return unless args.state.can_move
  
  args.state.is_moving              = (args.inputs.left_right != 0 || args.inputs.up_down != 0) ? true : false

  args.state.player.x               += args.inputs.left_right * args.state.speed
  args.state.player.y               += args.inputs.up_down * args.state.speed

  # TODO - spawn particles when moving

  #flip sprite
  if args.inputs.left
    args.state.player.flip_horizontally = true
  elsif args.inputs.right
    args.state.player.flip_horizontally = false
  end

  # animation
  if args.inputs.left_right != 0 or args.inputs.up_down != 0
    looping_animation args 
  else
    args.state.player.path          = "/sprites/player/player0.png"
  end

  # KICK MECHANICS
  if (args.inputs.keyboard.key_held.space) && args.state.can_kick
    kick_block args
    args.state.player.path          = "/sprites/player/player3.png"
  end
  
  args.state.camera.scale           = args.state.camera.scale.greater(0.1)
end

def calc_scene_position args
  result                            = { x: args.state.camera.x,
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
  start_looping_at                  = 1
  number_of_sprites                 = 4

  number_of_frames                  = 4

  does_sprite_loop                  = true

  sprite_index                      = start_looping_at.frame_index number_of_sprites,
                                      number_of_frames, 
                                      does_sprite_loop

  args.state.player.path            = "sprites/player/player#{sprite_index}.png"
end

# update func
def tick args
  init args
  render args
  calc_collisions args              unless args.state.player == []
  inputs args                       unless args.state.player == []
end

# refresh all variables
# $gtk.reset
