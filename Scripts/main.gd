extends Node2D

@onready var Timer_node = $Timer
@onready var Tiles_node = $Tiles
@onready var Bombs_display_node = $Bombs_display
@onready var Timer_display_node = $Timer_display
@onready var Face_node = $Face

var Time_passed = 0


func get_nearby_mines_count(y,x):
	var count = 0
	for j in range(-1,2):
		for i in range(-1,2):
			if(y+i >= 0 and y+i < Global.GRID_HEIGHT and x+j >= 0 and x+j < Global.GRID_WIDTH):
				if(Global.Grid[y+i][x+j] == 9):
					count += 1
	return	count

func build_board():
	for i in range(Global.GRID_HEIGHT):
		var Row = []
		for j in range(Global.GRID_WIDTH):
			Row.append(0)
		Global.Grid.append(Row)

func fill_board(safe_pos):
	randomize()
	for i in range(Global.MineCount):
		while(true):
			var x = randi_range(0, Global.GRID_WIDTH-1)
			var y = randi_range(0, Global.GRID_HEIGHT-1)
			if(Global.Grid[y][x] != 9): 
				Global.Grid[y][x] = 9
				if(get_nearby_mines_count(safe_pos.y,safe_pos.x) == 0): 
					Global.Mines.append(Vector2i(x,y))
					break 
				else: Global.Grid[y][x] = 0
					 
	
	for j in range(Global.Grid.size()):
		for i in range(Global.Grid[0].size()):
			if(Global.Grid[j][i] != 9):
				Global.Grid[j][i] = get_nearby_mines_count(j,i)
	print(Global.Grid)
	

func _on_reset_game():
	Global.Grid = []
	Global.defuses = []
	Global.Mines = []
	Global.GameState = 1
	Time_passed = 0
	Timer_display_node.number_display(0)
	Bombs_display_node.number_display(Global.MineCount)
	Timer_node.stop()
	build_board()
	Tiles_node.reset_tiles()
	print("reset")

func _on_tiles_game_over() -> void:
	Timer_node.stop()
	
func _on_tiles_game_start(pos) -> void:
	Global.GameState = 2
	Timer_node.start()
	fill_board(pos)
	Tiles_node.Render_board()

func _ready() -> void:
	Face_node.reset_game.connect(_on_reset_game)
	
	Bombs_display_node.number_display(Global.MineCount)
	build_board()
	
func _on_timer_timeout() -> void:
	if(Time_passed < 999): Time_passed += 1
	Timer_display_node.number_display(Time_passed)
	
func _on_tiles_defuse() -> void:
	Bombs_display_node.number_display(Global.MineCount-Global.defuses.size())
	
func _on_tiles_game_win() -> void:
	Timer_node.stop()
