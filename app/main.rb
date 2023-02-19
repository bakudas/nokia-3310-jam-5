# VacaRoxa at NOKIAJAM
# A little game for a nokia game jam
# https://itch.io/jam/nokiajam5
# copyleft @bakudas

# all consts
TILE_SIZE = 4
SCREEN_CENTER_H = 1280/2
SCREEN_CENTER_V = 720/2
SCREEN_MULTIPLIER = 10
SCREEN_WIDTH = 84
SCREEN_HEIGHT = 48

entities ||= {
  "_": :top,
  "|": :wall,
  "-": :bottom,
  "c": :colectable,
  "b": :box,
  "x": :enemy,
  "s": :start,
  "e": :exit
}

room001 ||= [
  "____s_____",
  "|        |",
  "|        e",
  "|    c   |",
  "| b      |",
  "----------"
]

room002 ||= [
  "__________",
  "|c      x|",
  "|bbb     |",
  "|     bbb|",
  "e  b     |",
  "-----s----"
]

def draw_room(args, room, sprites)
  args.state.entites      ||= {}
  room.each { |row|
    row.chars.each { |char|
      args.state.entities << entities[char]
    }
  }
end

# initial setup
def init args
  # set background color
  args.outputs.background_color      ||= [0, 0, 0]

  args.state.camera.x                ||= -1280 * 4.5
  args.state.camera.y                ||= -720 * 4.5
  args.state.camera.scale            ||= 10.0
  args.state.camera.show_empty_space ||= :yes

  # set speed
  args.state.speed                   ||= 1
  
  # set colors
  args.state.cores                   ||= { primaria: { r: 199, g: 240, b: 216 },
                                           secudaria: { r: 67, g: 82, b: 61 } }

  args.state.back                    ||= { x: 0, 
                                           y: 0, 
                                           w: 1280, 
                                           h: 720, 
                                           r: 10, 
                                           g: 10, 
                                           b: 10 }

  # args.state.nokia_bg                ||= { x: (1280-SCREEN_WIDTH)/2-35, 
  #                                          y: (720-SCREEN_HEIGHT)/2-142, 
  #                                          w: 640/4,
  #                                          h: 1177/4.5, 
  #                                          path: '/sprites/misc/Nokia_3310.png' }
  

  # create background with color 1
  args.state.background              ||= { x: (1280-SCREEN_WIDTH)/2, 
                                           y: (720-SCREEN_HEIGHT)/2, 
                                           w: SCREEN_WIDTH, 
                                           h: SCREEN_HEIGHT, 
                                           path: '/sprites/rooms/room001.png' }


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
  # args.outputs[:scene].primitives    << args.state.nokia_bg.sprite! 
  args.outputs[:scene].primitives    << args.state.background.sprite!
  args.outputs[:scene].primitives    << args.state.player.sprite!
 
  # DRAW TESTE && DEBUG STUFF
  args.state.walls ||= {}
  84.times { |w|
    args.state.walls << { x: SCREEN_CENTER_H - 42 + (w * TILE_SIZE), 
                          y: SCREEN_CENTER_V - 24 + (w * TILE_SIZE), 
                          w: TILE_SIZE, 
                          h: TILE_SIZE, 
                          r: 230, 
                          g: 200, 
                          b: 100 }
  }
  # args.state.walls                  << { x: SCREEN_CENTER_H - 42, 
  #                                        y: SCREEN_CENTER_V - 24, 
  #                                        w: TILE_SIZE, 
  #                                        h: TILE_SIZE, 
  #                                        r: 200, 
  #                                        g: 0, 
  #                                        b: 0 }

  args.outputs[:scene].borders      << args.state.walls


  # render camera
  scene_position                     = calc_scene_position args
  args.outputs.sprites               << { x: scene_position.x, 
                                          y: scene_position.y,
                                          w: scene_position.w, 
                                          h: scene_position.h, 
                                          path: :scene }
  
  # set X boundaries
  if args.state.player[:x] < SCREEN_CENTER_H - SCREEN_WIDTH/2 
    args.state.player[:x] = SCREEN_CENTER_H + SCREEN_WIDTH/2 - TILE_SIZE 
  elsif args.state.player[:x] > SCREEN_CENTER_H + SCREEN_WIDTH/2 - TILE_SIZE
    args.state.player[:x] = SCREEN_CENTER_H - SCREEN_WIDTH/2 + TILE_SIZE
  end

  # set Y boundaries
  if args.state.player[:y] < SCREEN_CENTER_V - SCREEN_HEIGHT/2 
    args.state.player[:y] = SCREEN_CENTER_V + SCREEN_HEIGHT/2 - TILE_SIZE
  elsif args.state.player[:y] > SCREEN_CENTER_V + SCREEN_HEIGHT/2 - TILE_SIZE
    args.state.player[:y] = SCREEN_CENTER_V - SCREEN_HEIGHT/2 + TILE_SIZE
  end

  # DEBUG TEXTS
  args.outputs[:scene].primitives   << { x: 1280/2-42, 
                                         y: 220.from_top, 
                                         text: "NOKIAJAM", 
                                         r: 255, 
                                         g: 255, 
                                         b: 255}.label!
  
  args.outputs[:scene].primitives   << { x: 1280/2-84, 
                                         y: 240.from_top, 
                                         text: "copyleft@VacaRoxa", 
                                         r: 255, 
                                         g: 255, 
                                         b: 255}.label!

  # DEBUB TEXT PLAYER
  args.outputs.labels               << { x: 250, 
                                         y: 310.from_top, 
                                         text: "#{args.state.player.y}, #{args.state.player.x}" }

end

# manage all inputs
def inputs args
  args.state.player[:x] += args.inputs.left_right * args.state.speed
  args.state.player[:y] += args.inputs.up_down * args.state.speed

  # flip sprite
  if args.inputs.left
    args.state.player[:flip_horizontally] = true
  elsif args.inputs.right
    args.state.player[:flip_horizontally] = false
  end

  # animation
  if args.inputs.left_right != 0 or args.inputs.up_down != 0
    looping_animation args 
  else
    args.state.player[:path] = "/sprites/player/player0.png"
  end

  args.state.camera.scale = args.state.camera.scale.greater(0.2)
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

  args.state.player[:path] = "sprites/player/player#{sprite_index}.png"
end

# update func
def tick args
  init args
  inputs args 
  # looping_animation args
  render args
end

# refresh all variables
$gtk.reset
