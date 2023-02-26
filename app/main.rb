# VacaRoxa at NOKIAJAM
#
# A little game for a nokia game jam
# https://itch.io/jam/nokiajam5
# cc0@bakudas

# all consts
TILE_SIZE = 4
SCREEN_CENTER_H = 1280 / 2
SCREEN_CENTER_V = 720 / 2
SCREEN_MULTIPLIER = 10
VIRTUAL_SCREEN_WIDTH = 84
VIRTUAL_SCREEN_HEIGHT = 48
PLAYER_STATES = %i[big small dead]

# level entities
ENTITIES = {
  "#": '/sprites/rooms/wall.png',
  "c": '/sprites/misc/bomb_5x7.png',
  "b": '/sprites/rooms/box.png',
  "k": '/sprites/misc/energia1.png',
  "d": '/sprites/rooms/door.png',
  "l": '/sprites/rooms/locker.png',
  "x": '/sprites/enemies/enemies.png',
  "s": '/sprites/rooms/start.png',
  "e": '/sprites/rooms/exit.png',
  " ": '/sprites/rooms/empty.png',
  "p": '/sprites/player/player0.png'
}

# level design
ROOM001 = [
  '#####################',
  '#####################',
  '#bbbbbbbb     bbbbbb#',
  '#bbbbbbbb     bbbbbb#',
  '#bbbbbbbb  p  bbbbbb#',
  'e             bbbbbb#',
  'e             bbbbbb#',
  '#bbbbbbbb     bbbbbb#',
  '#bbbbbbbb     bbbbbb#',
  '#bbbbbbbb  k  bbbbbb#',
  '#bbbbbbbb     bbbbbb#',
  '#####################'
].reverse

ROOM002 = [
  '#####################',
  '#####################',
  '#bbbb               #',
  '#bbbb               #',
  '#bbbd        c      #',
  'e  l                s',
  'e  l      k       p s',
  'e  l                s',
  '#bbbd        c      #',
  '#bbbb               #',
  '#bbbb               #',
  '#####################'
].reverse

ROOM003 = [
  '#####################',
  '#####################',
  '########     ########',
  '########     ########',
  '########  p  ########',
  '########     ########',
  'e  l         ########',
  'e  l  d c    ########',
  'e  l         ########',
  '########     ########',
  '########     ########',
  '#####################'
].reverse

ROOM004 = [
  '#####################',
  '#####################',
  '# c x               s',
  '#                p  s',
  '#bbbb               s',
  'e   b       bbbbbbbb#',
  'e   b       d    c  #',
  'e   d       d       #',
  '#   d       bbbbbbbb#',
  '#bbbbbb     bbbbbbbb#',
  '#bbbbbb  c  bbbbbbbb#',
  '#####################'
].reverse

ROOMS = [ROOM001, ROOM002, ROOM003, ROOM004]

def populate_room(args, room)
  # BLOCK ANY ROOM INTERACTION TO UPDATE AND RENDER
  args.state.room_is_ready = false

  # MAKE SURE ALL ARRAYS ARE EMPTY
  args.state.player = []
  args.state.walls = []
  args.state.enemies = []
  args.state.puzzle_hole = []
  args.state.boxes = []
  args.state.start = []
  args.state.goal = []
  args.state.collectables = []
  args.state.lockers = []
  args.state.empty = []
  args.state.pick_ups = []

  # EMPTY TEMP_TILE AS WELL
  temp_tile = []

  # LETS ITERATE THE CURRENT ROOM ARRAY
  room.each_with_index do |row, i|
    row.split('').each_with_index do |char, ii|
      temp_tile = [SCREEN_CENTER_H - VIRTUAL_SCREEN_WIDTH / 2 + "#{ii * TILE_SIZE}".to_i,
                   SCREEN_CENTER_V - VIRTUAL_SCREEN_HEIGHT / 2 + "#{i * TILE_SIZE}".to_i, TILE_SIZE, TILE_SIZE, ENTITIES[:"#{char}"]].sprite

      case char

      # PLAYER
      when 'p'
        args.state.player << temp_tile

      # WALLS
      when '#'
        args.state.walls << temp_tile

      # BOXES
      when 'b'
        args.state.boxes << temp_tile

      # START POINTS
      when 's'
        args.state.start << temp_tile

      # DOOR
      when 'd'
        args.state.puzzle_hole << temp_tile

      # GOAL POINT
      when 'e'
        args.state.goal << temp_tile

      when 'c'
        args.state.collectables << temp_tile

      when 'l'
        args.state.lockers << temp_tile

      when ' '
        args.state.empty << temp_tile

      when 'k'
        args.state.pick_ups << temp_tile

      end
    end
  end
end

def render_room(args)
  args.outputs[:scene].primitives << args.state.empty.map { |e| e } if args.state.empty != []
  args.outputs[:scene].primitives << args.state.walls.map { |wall| wall } if args.state.walls != []
  args.outputs[:scene].primitives << args.state.boxes.map { |box| box } if args.state.boxes != []
  args.outputs[:scene].primitives << args.state.collectables if args.state.collectables != []
  args.outputs[:scene].primitives << args.state.start if args.state.start != []
  args.outputs[:scene].primitives << args.state.puzzle_hole if args.state.doors != []
  args.outputs[:scene].primitives << args.state.lockers if args.state.lockers != []
  args.outputs[:scene].primitives << args.state.pick_ups if args.state.pick_ups != []
  args.outputs[:scene].primitives << args.state.goal if args.state.goal != []
  args.outputs[:scene].primitives << args.state.player.sprite if args.state.player != []

  # WITH ALL SET UP, LIBERATE THE ROOM
  args.state.room_is_ready = true
end

# initial setup
def init(args)
  # RENDER SETUP
  args.state.room_is_ready            ||= false

  # set camera
  args.state.camera.x                 ||= -1280 * 4.5
  args.state.camera.y                 ||= -720 * 4.5
  args.state.camera.scale             ||= 10.0
  args.state.camera.show_empty_space  ||= :yes

  # PLAYER MECHANICS
  args.state.is_moving                ||= false
  args.state.is_kicking               ||= false
  args.state.has_projectile           ||= nil
  args.state.can_move                 ||= true
  args.state.can_kick                 ||= false
  args.state.can_put                  ||= false
  args.state.carry_max                ||= 1
  args.state.speed_fast               ||= 1
  args.state.speed_slow               ||= 0.3
  args.state.player_state             ||= PLAYER_STATES[0]
  args.state.player_speed             ||= 1
  args.state.can_change_state         ||= false
  args.state.pickable                 ||= true if args.state.tick_count == 0

  case args.state.player_state
  when :big
    args.state.player_speed             = args.state.speed_slow
    args.state.player.w                 = 7
    args.state.player.h                 = 10
  when :small
    args.state.player.w                 = 4
    args.state.player.h                 = 4
    args.state.player_speed             = args.state.speed_fast
  when :dead
    args.state.can_move = false
  end

  # BLOCK BULLET SET UP
  args.state.bullet_speed             ||= 4

  # set colors
  args.state.cor_primaria             ||= { r: 199, g: 240, b: 216 }
  args.state.cor_secundaria           ||= { r: 67, g: 82, b: 61 }

  # SET BG COLOR WORLD
  args.state.back                     ||= { x: 0, y: 0, w: 1280, h: 720, r: 35, g: 35, b: 35 }

  # create background with color 1
  args.state.background               ||= [(1280 - VIRTUAL_SCREEN_WIDTH) / 2,
                                           (720 - VIRTUAL_SCREEN_HEIGHT) / 2,
                                           VIRTUAL_SCREEN_WIDTH,
                                           VIRTUAL_SCREEN_HEIGHT,
                                           args.state.cor_primaria[:r],
                                           args.state.cor_primaria[:g],
                                           args.state.cor_primaria[:b]]

  # set current ROOM
  args.state.level                    ||= 0
  args.state.current_room             ||= ROOMS[args.state.level]

  # PUZZLE SET UP
  args.state.puzzle_count             ||= args.state.puzzle_hole.length
  args.state.level_complete           ||= false
  # PUZZLE TEST TODO-> refactorar
  args.state.level_complete = args.state.puzzle_count <= 0
  open_door args if args.state.level_complete
end

# all renders goes here
def render(args)
  # set world variable
  args.state.world.w                  ||= 1280
  args.state.world.h                  ||= 720

  # RENDER VIRTUAL SCENE
  args.outputs[:scene].w              ||= args.state.world.w
  args.outputs[:scene].h              ||= args.state.world.h

  # RENDER BG STUFF
  args.outputs[:scene].primitives     << args.state.back.sprite!
  args.outputs[:scene].primitives     << args.state.background.solid

  # RENDER ROOMS
  update_room(args, args.state.level) unless args.state.tick_count != 0
  render_room args                    unless args.state.tick_count == 0

  # RENDER PLAYER to override the render room func
  args.outputs[:scene].primitives << args.state.player.sprite

  # RENDER PROJECTILES
  args.state.projectiles ||= []
  args.outputs[:scene].primitives << args.state.projectiles.sprite if args.state.has_projectile
  bullet_movement args, args.state.projectiles if args.state.has_projectile

  # RENDER PICK UPS
  args.state.pick_ups.path = "sprites/misc/energia#{sprite_animations(2, 6, 5, true)}.png" if args.state.pickable
  args.state[:scene].primitives << args.state.pick_ups.sprite

  # RENDER TEXTS
  if args.state.can_kick
    args.outputs[:scene].labels << [(1280 + VIRTUAL_SCREEN_WIDTH) / 2,
                                    (720 + VIRTUAL_SCREEN_HEIGHT) / 2,
                                    'KICK IT!',
                                    -8,
                                    2,
                                    args.state.cor_primaria[:r],
                                    args.state.cor_primaria[:g],
                                    args.state.cor_primaria[:b],
                                    255,
                                    'fonts/tiny.ttf'].label
  end

  args.outputs[:scene].labels << [(1280 - VIRTUAL_SCREEN_WIDTH) / 2 + 1,
                                  (720 + VIRTUAL_SCREEN_HEIGHT) / 2,
                                  "ROOM_#{args.state.level}",
                                  -8,
                                  0,
                                  args.state.cor_primaria[:r],
                                  args.state.cor_primaria[:g],
                                  args.state.cor_primaria[:b],
                                  255,
                                  'fonts/tiny.ttf']

  # RENDER CAMERA
  render_camera args
end

# UPDATE THE GAME OBJECTS FORM THE ROOMS
def update_room(args, level)
  args.state.pickable = true if args.state.pick_ups != []
  args.state.current_room             = ROOMS[level]
  populate_room(args, args.state.current_room)
  args.state.puzzle_count             = args.state.puzzle_hole.length
  change_player_state args, PLAYER_STATES[0]
end

# RENDER THE VIRTUAL CAMERA
def render_camera(args)
  scene_position                      = calc_scene_position args
  args.outputs.sprites << { x: scene_position.x,
                            y: scene_position.y,
                            w: scene_position.w,
                            h: scene_position.h,
                            path: :scene }
end

# CALCULATE ALL COLLISIONS
def calc_collisions(args)
  # PLAYER BOUNDING BOX
  player_temp                         = args.state.player.shift_rect(args.inputs.left_right, args.inputs.up_down)
  args.state.player_box               = [player_temp.x, player_temp.y, player_temp.w, player_temp.h]

  # WALLS
  if args.state[:boxes].any_intersect_rect?(args.state.player_box) or
     args.state[:walls].any_intersect_rect?(args.state.player_box) or
     # args.state[:doors].any_intersect_rect?(args.state.player_box) or
     args.state[:lockers].any_intersect_rect?(args.state.player_box) or
     args.state[:collectables].any_intersect_rect?(args.state.player_box)

    args.state.can_move               = false
    args.state.is_moving              = false
  else
    args.state.can_move               = true
  end

  # BLOCKS
  args.state.can_kick = if (args.state[:collectables].any_intersect_rect? args.state.player_box) && !args.state.is_kicking && args.state.player_state == :big
                          true
                        else
                          false
                        end

  # BLOCK HITS DOORS
  if args.state.has_projectile && args.state[:puzzle_hole].any_intersect_rect?(args.state.projectiles)
    # create an array to alloc all game objets to remove
    to_remove = []
    to_animate = []

    # populate with collisions check
    to_animate << args.state.puzzle_hole.find { |d| d.intersect_rect?(args.state.projectiles) }
    to_remove << args.state.puzzle_hole.find { |d| d.intersect_rect?(args.state.projectiles) }
    to_remove << args.state.projectiles
    puts to_remove.inspect
    # remove game objects from the original arrays
    # args.state.puzzle_hole.reject! { |r| to_remove.include? r }
    args.state.collectables.reject! { |r| to_remove.include? r }

    # change the puzzle_hole sprite
    args.state.puzzle_hole.find { |e| to_animate.include? e }.path = '/sprites/rooms/door2.png'
    args.state.puzzle_count -= 1

    # turn of the bool from bullet movement
    args.state.has_projectile = false
  end

  
  # PICK UPS
  if args.state[:pick_ups][0] != nil && args.state[:pick_ups].intersect_rect?(args.state.player_box)
    return unless args.state.pickable  #check if player can pick up
    # turn off pickable
    args.state.pickable = false

    # 'animate' the pick up
    args.state.pick_ups.path = "sprites/rooms/vazio.png"
    
    # grant player can change state
    args.state.can_change_state = true

    # call method to change player state
    change_player_state args, PLAYER_STATES
  end

  # GOAL
  return unless args.state[:goal].any_intersect_rect?(args.state.player_box)

  args.state.level += 1
  update_room(args, args.state.level)

  # REMOVE BLOCK OUT OF CANVAS
  # puts args.state. { |p| p.intersect_rect?args.state.background } unless !args.state.has_projectile
end

# CHANGE player state
def change_player_state args, state 
  return unless args.state.can_change_state # check if player can change state 

  # change player state
  if args.state.player_state == :big 
    args.state.player_state = state[1]
  elsif args.state.player_state == :small
    args.state.player_state = state[0]
  end
  
  # lock player change state
  args.state.can_change_state = false
end

# PROCESS THE INPUTS
def process_inputs(args)
  # MOVE PLAYER
  if args.state.can_move
    args.state.is_moving = args.inputs.left_right != 0 || args.inputs.up_down != 0 ? true : false

    args.state.player.x               += args.inputs.left_right * args.state.player_speed
    args.state.player.y               += args.inputs.up_down * args.state.player_speed
  end

  # TODO: - spawn particles when moving

  args.state.bullet_speed = args.inputs.left_right unless args.state.has_projectile

  # flip sprite
  if args.inputs.left
    args.state.player.flip_horizontally = true
    # args.state.bullet_speed = -1 unless args.state.has_projectile
  elsif args.inputs.right
    args.state.player.flip_horizontally = false
    # args.state.bullet_speed = 1 unless args.state.has_projectile
  end

  # animation
  if args.state.can_move && args.state.is_moving
    player_animation args
  else
    args.state.player.path            = '/sprites/player/novo/player0.png' if args.state.player_state == :big
    args.state.player.path            = "sprites/player/small/player_small0.png" if args.state.player_state == :small
  end

  # KICK MECHANICS
  if args.inputs.keyboard.key_down.space && args.state.can_kick
    args.state.is_kicking           = true
    args.state.is_moving            = false

    # TODO: args.state.player.path          = "/sprites/player/player2.png"

    args.state.has_projectile       = true

    args.state.projectiles = args.state.collectables.find { |c| c.intersect_rect?(args.state.player_box) }

    bullet_movement(args, args.state.projectiles)
  else
    args.state.is_kicking = false
  end
end

# KICK MECHANICS
def bullet_movement(args, block)
  block.x += args.state.bullet_speed if args.state.has_projectile
end

def open_door(args)
  args.state.lockers = []
end

# CALCULATE VIRTUAL CAMERA POSITION
def calc_scene_position(args)
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
  elsif result.y > 10
    result.merge!(y: 10)
  elsif (result.y + result.h) < args.grid.h
    result.merge!(y: - result.h + (args.grid.h - 10))
  end

  result
end

def player_animation(args)
  start_looping_at                  = 7

  number_of_sprites                 = 8

  number_of_frames                  = 4

  does_sprite_loop                  = true

  sprite_index                      = start_looping_at.frame_index number_of_sprites,
                                                                   number_of_frames,
                                                                   does_sprite_loop

  args.state.player.path            = "sprites/player/novo/player#{sprite_index}.png" if args.state.player_state == :big
  args.state.player.path            = "sprites/player/small/player_small#{sprite_index}.png" if args.state.player_state == :small
end

def sprite_animations(start_frame = 1, num_sprites = 4, num_frames = 4, is_loopable = true)
  sprite_index = start_frame.frame_index(num_sprites, num_frames, is_loopable)
end

# update func
def tick(args)
  init args
  render args
  calc_collisions args              if args.state.room_is_ready
  process_inputs args               if args.state.room_is_ready
end

# refresh all variables
$gtk.reset
