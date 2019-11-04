# wha to do next time: figure out how to remove sword from inventory when its used against a monster

require 'io/console'

class Tile
    # if something is there or not
    attr_accessor :solid # true/false based on whether the character can stand there or not
    attr_accessor :score # does this cell have any kind of value?
    attr_accessor :damage # does this cell cause damage, and how much
    attr_accessor :display # what does this look like on the map?
    attr_accessor :message # what it should display when on this tile
    attr_accessor :sword

    def initialize
        @solid = false
        @score = 0
        @damage = 0
        @display = ' • '
        # @message = "Fwffffwwww"
    end
  

    def step player
        # maybe add to score if there is any
        # subtract from health if there is any damage
        player.score += @score
        @score = 0
        player.health -= @damage
    end
end

class Monster < Tile
    def initialize
        super
        @score = -10
        @display = '\|/'
        @message = "MONSTER!!!!#{7.chr}"
        @times_i_got_stepped_on = 0
    end
    def step player
        super
        @display = '\|/'
        if @times_i_got_stepped_on >= 1 
            @message = "There's nothing but a pile of bones here."
        elsif player.sword >= 1
            @times_i_got_stepped_on += 1
            @message = "You used your sword to kill the monster!\nYour sword broke."
            player.score + 10
            player.sword -= 1
            player.inventory.delete([0])
        else
            player.health -= 1
        end
        
    end

end 
class Wall < Tile
    def initialize
        super
        @solid = true
        @display = ' ∆ ' 
        @message = "Oh boy, this is bad"
    end
end

class Sword < Tile
    def initialize
        super
        @sword  = '†'
        @display = '\|/'
        @message = "YOU FOUND A SWORD!"
        @times_i_got_stepped_on = 0
    end

    def step player
        super
        @display = '\|/'
        if @times_i_got_stepped_on >= 1
            @message = "It is now empty"
        else
            player.inventory << @sword
            player.sword += 1
            @times_i_got_stepped_on += 1
        end
        
    end
    
end

class Grass < Tile
    def initialize 
        super
        @display = '\|/'
    end

    # def step player
    #     super
    #     player.x = @new_x
    #     player.y = @new_y
    # end
end

class Treasure < Tile
    def initialize
        super
        @score = 10
        @display = ' § '
        @message = "Oh yay, trea$ure!#{7.chr}"
        @times_i_got_stepped_on = 0
    end

    def step player
        super
        @times_i_got_stepped_on += 1
        @display = ' • '
        if @times_i_got_stepped_on > 1
            @message = "It is now empty"
        end
    end
end

class Potions < Tile
    def initialize
        super
        @display = '\|/'
        @message = "glug glug glug...+1 health!"
        @times_i_got_stepped_on = 0
    end
    
    def step player
        super
        @times_i_got_stepped_on += 1
        display = '\|/'
        if @times_i_got_stepped_on > 1
            @message = "There is nothing here."
        else
            player.health += 1
        end
    end
end



class Player
    attr_accessor :score
    attr_accessor :health
    attr_accessor :x
    attr_accessor :y
    attr_accessor :display
    attr_accessor :sword
    attr_accessor :inventory

    def initialize
        @score = 0
        @health = 3
        @x = 1
        @y = 1
        @display = " @ "
        @sword = 0
        @inventory = []
    end
end

grid = Array.new(10) {Array.new(10) {Tile.new}}
# grid = [
#     [0,0,0,0,0,0,3,0,0,0],
#     [0,0,0,0,0,2,3,0,0,0],
#     [0,0,0,0,0,0,3,0,0,0],
#     [0,0,0,0,1,1,1,0,0,0],
#     [0,0,0,0,1,0,0,0,2,0],
#     [0,0,0,0,1,0,0,0,0,0],
#     [0,0,0,0,0,0,0,0,0,0],
#     [0,0,0,0,0,0,0,0,0,0],
#     [0,0,0,0,0,0,0,0,0,0],
#     [0,0,0,0,0,0,0,0,0,0],
# ]
grid_height = grid.length
grid_width = grid[0].length

grid[2][3] = Wall.new
grid[1][3] = Wall.new
grid[2][4] = Grass.new
grid[2][5] = Grass.new
grid[3][4] = Grass.new
grid[3][5] = Sword.new
grid[5][8] = Treasure.new
grid[6][8] = Monster.new
grid[4][5] = Potions.new
# grid[9][2] = Portal.new 3,2

wall = 1
hidden_wall = 3
treasure = 2
floor = 0

# player_x = 4
# player_y = 6
# player_symbol = "@"
# player_score = 0
player = Player.new
player.x = 4
player.y = 6

keepPlaying = true
while(player.health > 0 && keepPlaying == true) 
    system "cls" #windows
    system "clear" #osx
    puts "Print with grid.each and row.each"
    grid.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
            if row_index == player.y && cell_index == player.x # the row we're on == player_y and the column we're on == player_x
                print player.display
            else
                print cell.display
            end
        end
        puts
    end
    puts "|=========|"
    puts " Score: #{player.score}"
    puts " Health: #{player.health}"
    puts grid[player.y][player.x].message
    puts "|=========|"
    puts " INVENTORY"
    puts player.inventory
#{player.sword}


    
    # Before I move
    input = STDIN.getch
    if input == "a"
        if player.x > 0 && grid[player.y][player.x - 1].solid == false 
            player.x = player.x - 1
        end
    end
    if input == "s"
        if player.y < grid_height - 1 && grid[player.y + 1][player.x].solid == false
            player.y = player.y + 1
        end
    end
    if input == "d"
        if player.x < grid_width - 1 && grid[player.y][player.x + 1].solid == false
            player.x = player.x + 1
        end
    end
    if input == "w"
        if player.y > 0 && grid[player.y - 1][player.x].solid == false
            player.y = player.y - 1
        end
    end
    if input == "q"
        keepPlaying = false
    end
    

    #After I have moved
    #Step on whatever tile I'm on
    grid[player.y][player.x].step player
    # if grid[player.y][player.x] == treasure
    #     # turn treasure back into floor (aka pick up treasure)
    #     # add to my non-existant score?
    #     grid[player.y][player.x] = floor
    #     player.score += 10
    # end
end
    puts "GAME OVER!!"
    