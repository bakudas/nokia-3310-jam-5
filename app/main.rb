# VacaRoxa at NOKIAJAM
# A little game for a nokia game jam
# https://itch.io/jam/nokiajam5
# copyleft @bakudas

# all consts
SCREEN_MULTIPLIER = 10
SCREEN_WIDTH = 84
SCREEN_HEIGHT = 48
PLAYER_WIDTH = 8
PLAYER_HEIGHT = 8

# initial setup
def init args
  args.state.camera.x                ||= 1280/2
  args.state.camera.y                ||= 720/2
  args.state.camera.scale            ||= 1.0
  args.state.camera.show_empty_space ||= :yes

  # set speed
  args.state.speed                   ||= 1
  
  # set colors
  args.state.cor_1                   ||= { r: 43, g: 63, b: 9 }
  args.state.cor_2                   ||= { r: 155, g: 199, b: 0 }

  args.state.back                    ||= { x: 0, 
                                           y: 0, 
                                           w: 1280, 
                                           h: 720, 
                                           r: 10, 
                                           g: 10, 
                                           b: 10 }

  args.state.nokia_bg                ||= { x: (1280-SCREEN_WIDTH)/2-35, 
                                           y: (720-SCREEN_HEIGHT)/2-142, 
                                           w: 640/4,
                                           h: 1177/4.5, 
                                           path: '/sprites/misc/Nokia_3310.png' }
  

  # create background with color 1
  args.state.background              ||= { x: (1280-SCREEN_WIDTH)/2, 
                                           y: (720-SCREEN_HEIGHT)/2, 
                                           w: SCREEN_WIDTH, 
                                           h: SCREEN_HEIGHT, 
                                           r: args.state.cor_1.r, 
                                           g: args.state.cor_1.g, 
                                           b: args.state.cor_1.b }
  
  # create player with color 2
  args.state.player                  ||= { x: 1280/2, 
                                           y: 720/2,
                                           w: PLAYER_WIDTH, 
                                           h: PLAYER_HEIGHT,  
                                           r: args.state.cor_2.r, 
                                           g: args.state.cor_2.g, 
                                           b: args.state.cor_2.b }
end

# all renders goes here
def render args
  # variables you can play around with
  args.state.world.w                 ||= 1280
  args.state.world.h                 ||= 720

  # render scene
  args.outputs[:scene].w             ||= args.state.world.w
  args.outputs[:scene].h             ||= args.state.world.h

  args.outputs[:scene].primitives    << args.state.back.solid! 
  args.outputs[:scene].primitives    << args.state.nokia_bg.sprite! 
  args.outputs[:scene].primitives    << args.state.background.solid!
  args.outputs[:scene].primitives    << args.state.player.solid!
 
  # render camera
  scene_position                    = calc_scene_position args
  args.outputs.sprites              << { x: scene_position.x, 
                                         y: scene_position.y,
                                         w: scene_position.w, 
                                         h: scene_position.h, 
                                         path: :scene }

  # set X boundaries
  if args.state.player[:x] < 220 
    args.state.player[:x] = 960
  elsif args.state.player[:x] > 960
    args.state.player[:x] = 220
  end

  # set Y boundaries
  if args.state.player[:y] < 120
    args.state.player[:y] = 510
  elsif args.state.player[:y] > 520
    args.state.player[:y] = 120
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
end

# manage all inputs
def inputs args
  args.state.player[:x] += args.inputs.left_right * args.state.speed
  args.state.player[:y] += args.inputs.up_down * args.state.speed

  # +/- to zoom in and out
  if args.inputs.keyboard.equal_sign && args.state.tick_count.zmod?(3)
    args.state.camera.scale += 0.25
  elsif args.inputs.keyboard.hyphen && args.state.tick_count.zmod?(3)
    args.state.camera.scale -= 0.25
  elsif args.inputs.keyboard.key_down.tab
    if args.state.camera.show_empty_space == :yes
      args.state.camera.show_empty_space = :no
    else
      args.state.camera.show_empty_space = :yes
    end
  end

  args.state.camera.scale = args.state.camera.scale.greater(0.2)
end

def calc_scene_position args
  result = { x: args.state.camera.x - (args.state.player.x * args.state.camera.scale),
             y: args.state.camera.y - (args.state.player.y * args.state.camera.scale),
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

# update func
def tick args
  init args
  inputs args 
  render args
end

# refresh all variables
$gtk.reset
