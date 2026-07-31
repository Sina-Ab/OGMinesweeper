extends Node2D

signal game_win
signal game_start
signal game_over
signal pressed
signal released
signal defuse

var tiles_node
var covers_node
var Queue

func Game_over() -> void:
	game_over.emit()
	for j in range(Global.Grid.size()):
		for i in range(Global.Grid[0].size()):
			if(Global.Grid[j][i] == 9 and Vector2i(i,j) not in Global.defuses): 
				covers_node.erase_cell(Vector2i(i,j))
			if(Global.Grid[j][i] != 9 and Vector2i(i,j) in Global.defuses): 
				covers_node.erase_cell(Vector2i(i,j))
				tiles_node.set_cell(Vector2(i,j),0,Vector2(2,3))

	Global.GameState = 0
	print("Game Over")
	
func Flood_fill_neighbors_check(pos):
	for j in range(-1,2):
		for i in range(-1,2):
			var check_pos = Vector2i(pos[0]+i,pos[1]+j)
			if(check_pos.y >= 0 and check_pos.y < Global.GRID_HEIGHT and check_pos.x >= 0 and check_pos.x < Global.GRID_WIDTH and check_pos not in Queue): # Out of boundry and duplication check
				if(Global.Grid[pos[1]+j][pos[0]+i] == 0): 
					Queue.append(check_pos)
					Flood_fill_neighbors_check(check_pos) # Recursion to find connected tiles
				elif(Global.Grid[pos[1]+j][pos[0]+i] != 9): 
					Queue.append(check_pos)
	
	
func Flood_fill(pos):
	Queue = [pos]
	Flood_fill_neighbors_check(pos)
				
	for i in Queue:
		if(i not in Global.defuses): covers_node.erase_cell(i)
			

func check_for_win():
	var count = 0
	for j in range(Global.GRID_HEIGHT):
		for i in range(Global.GRID_WIDTH):
			if(covers_node.get_cell_atlas_coords(Vector2i(i,j)) == Vector2i(0,0)): count += 1		
			
	for i in Global.Mines:
		if(i not in Global.defuses): 
			count = 1 #Here i used the same count var that was for counting remaining covers for flaging that there is a mine that doesnt defused
			
	if(count == 0):
		Global.GameState = 3
		game_win.emit()
		print("Game win")
		

func Render_board():
	for j in range(Global.GRID_HEIGHT):
		for i in range(Global.GRID_WIDTH):
			match Global.Grid[j][i]:
				1:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(0,1))
				2:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(1,1))
				3:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(2,1))
				4:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(3,1))
				5:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(0,2))
				6:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(1,2))
				7:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(2,2))
				8:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(3,2))
				9:
					tiles_node.set_cell(Vector2(i,j),0,Vector2(0,3))
				
func reset_tiles():
	for j in range(Global.GRID_HEIGHT):
		for i in range(Global.GRID_WIDTH):
			covers_node.set_cell(Vector2(i,j),0,Vector2(0,0))
			tiles_node.set_cell(Vector2(i,j),0,Vector2(2,0))
			
func _ready() -> void:
	tiles_node = get_node("Tiles")
	covers_node = get_node("Covers")
	
	reset_tiles()
	
func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and Global.GameState):
		if(event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
			var mouse_pos = to_local(get_global_mouse_position())
			var tile_pos = covers_node.local_to_map(mouse_pos)
			if(tile_pos.x >= 0 and tile_pos.x < Global.GRID_WIDTH and tile_pos.y >= 0 and tile_pos.y < Global.GRID_HEIGHT and tile_pos not in Global.defuses):
				covers_node.erase_cell(tile_pos)
				pressed.emit() #to change the face
			
		if(event.is_released() and event.button_index == MOUSE_BUTTON_LEFT):
			var mouse_pos = to_local(get_global_mouse_position())
			var tile_pos = covers_node.local_to_map(mouse_pos)
			
			if(tile_pos.x >= 0 and tile_pos.x < Global.GRID_WIDTH and tile_pos.y >= 0 and tile_pos.y < Global.GRID_HEIGHT and tile_pos not in Global.defuses):
				if(Global.GameState == 1):
					game_start.emit(tile_pos)
				elif(Global.Grid[tile_pos.y][tile_pos.x] == 9):
					tiles_node.set_cell(tile_pos,0,Vector2(1,3))
					Game_over()
				
				if(Global.Grid[tile_pos.y][tile_pos.x] == 0):
					print("flood fill")
					Flood_fill(tile_pos)
				covers_node.erase_cell(tile_pos)
				check_for_win()
			released.emit() #to change the face back
				
		#Right click
		if(event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
			var mouse_pos = to_local(get_global_mouse_position())
			var tile_pos = covers_node.local_to_map(mouse_pos)
			
			if(tile_pos.x >= 0 and tile_pos.x < Global.GRID_WIDTH and tile_pos.y >= 0 and tile_pos.y < Global.GRID_HEIGHT and covers_node.get_cell_tile_data(tile_pos)):
				if(tile_pos not in Global.defuses):
					covers_node.set_cell(tile_pos,0,Vector2(1,0))
					Global.defuses.append(tile_pos)
					
				else:
					covers_node.set_cell(tile_pos,0,Vector2(0,0))
					Global.defuses.erase(tile_pos)
				defuse.emit()
