class Level
	
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

  attr_accessor :rooms
	
  def initialize
    puts "AAAAAAAAAAAAAAAA"
    rooms = [ROOM001, ROOM002, ROOM003, ROOM004]
  end
end
