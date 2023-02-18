# NOKIAJAM
# A little game for a nokia game jam
# https://itch.io/jam/nokiajam5
# copyleft @bakudas

# all consts
SCREEN_WIDTH = 840
SCREEN_HEIGHT = 480
PLAYER_WIDTH = 80
PLAYER_HEIGHT = 80

# initial setup
def init args
  # set speed
  args.state.speed ||= 10
  # set colors
  args.state.cor_1 ||= { r: 43, g: 63, b: 9 }
  args.state.cor_2 ||= { r: 155, g: 199, b: 0 }
  # create background with color 1
  args.state.background ||= { x: (1280-840)/2, y: (720-480)/2, w: SCREEN_WIDTH, h: SCREEN_HEIGHT, r: args.state.cor_1.r, g: args.state.cor_1.g, b: args.state.cor_1.b }
  # create player with color 2
  args.state.player ||={ x: 310, y: 390, w: PLAYER_WIDTH, h: PLAYER_HEIGHT,  r: args.state.cor_2.r, g: args.state.cor_2.g, b: args.state.cor_2.b }
end

# all renders goes here
def render args
  args.outputs.solids << args.state.background 
  args.outputs.solids << args.state.player
  
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
end

# manage all inputs
def inputs args
  args.state.player[:x] += args.inputs.left_right * args.state.speed
  args.state.player[:y] += args.inputs.up_down * args.state.speed
end

# update func
def tick args
  init args
  inputs args 
  render args
end

# refresh all variables
$gtk.reset
