extends Node2D

@export var tilemap : TileMapLayer
var cell_h : int = 2
var cell_w : int = 2

const Erase : int = -1
const Metal : int = 0
const Sand : int = 1
const Water : int = 2
const Dirt : int = 3
const Stone : int = 4
const Grass : int = 5

var SelectedMaterial : int = Erase

var randside : Array = [-1,1] 

func _ready() -> void:
	randomize()

func removeCell(cell_pos : Vector2i) -> void:
	tilemap.set_cell(Vector2(cell_pos.x, cell_pos.y), -1, Vector2i(-1, -1), -1)

func addCell(cell_pos : Vector2i, SourceID : int):
	tilemap.set_cell(cell_pos, SourceID, Vector2i(0, 0), 0)

func _materialSelected(index: int) -> void:
	SelectedMaterial = index - 1

func _process(delta : float) -> void:
	if Input.is_action_pressed("LMB"):
		addCell(get_global_mouse_position()/cell_h, SelectedMaterial)

func _1sUpdate() -> void:
	for tile in tilemap.get_used_cells_by_id(Grass, Vector2i(0, 0)):
		var side : int = randside[randi() % randside.size()]
		if tilemap.get_cell_source_id(Vector2i(tile.x, tile.y +1)) != 3 && tilemap.get_cell_source_id(Vector2i(tile.x, tile.y +1)) != -1:
			if side == 0:
				removeCell(Vector2i(tile.x, tile.y))

func _Update() -> void:
	for tile in tilemap.get_used_cells_by_id(Stone, Vector2i(0, 0)):
		var neighbors : int = tilemap.get_surrounding_cells(Vector2i(tile.x, tile.y)).size()
		if neighbors == 4:
			pass
		solidMovement(Vector2i(tile.x, tile.y), Stone)
	for tile in tilemap.get_used_cells_by_id(Sand, Vector2i(0, 0)):
		var neighbors : int = tilemap.get_surrounding_cells(Vector2i(tile.x, tile.y)).size()
		if neighbors == 4:
			pass
		powderMovement(Vector2i(tile.x, tile.y), Sand)
	for tile in tilemap.get_used_cells_by_id(Dirt, Vector2i(0, 0)):
		var neighbors : int = tilemap.get_surrounding_cells(Vector2i(tile.x, tile.y)).size()
		if neighbors == 4:
			pass
		powderMovement(Vector2i(tile.x, tile.y), Dirt)
	for tile in tilemap.get_used_cells_by_id(Grass, Vector2i(0, 0)):
		var neighbors : int = tilemap.get_surrounding_cells(Vector2i(tile.x, tile.y)).size()
		if neighbors == 4:
			pass
		powderMovement(Vector2i(tile.x, tile.y), Grass)
	for tile in tilemap.get_used_cells_by_id(Water, Vector2i(0, 0)):
		var neighbors :int = tilemap.get_surrounding_cells(Vector2i(tile.x, tile.y)).size()
		if neighbors == 4:
			pass
		liquidMovement(Vector2i(tile.x, tile.y), Water)

func powderMovement(tile : Vector2i, material : int) -> void:
	var side : int = randside[randi() % randside.size()]
	if tilemap.get_cell_source_id(Vector2i(tile.x, tile.y + 1)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x + side, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x + 1, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + 1, tile.y)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x + 1, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x - 1, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x - 1, tile.y)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x - 1, tile.y + 1), material)

func liquidMovement(tile : Vector2i, material : int) -> void:
	var side : int = randside[randi() % randside.size()]
	if tilemap.get_cell_source_id(Vector2i(tile.x, tile.y + 1)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x + side, tile.y), material)
	
func solidMovement(tile : Vector2i, material : int) -> void:
	var side : int = randside[randi() % randside.size()]
	if tilemap.get_cell_source_id(Vector2i(tile.x, tile.y + 1)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y + 2)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + side, tile.y + 3)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x + side, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x + 1, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + 1, tile.y + 2)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x + 1, tile.y + 3)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x + 1, tile.y + 1), material)
	elif tilemap.get_cell_source_id(Vector2i(tile.x - 1, tile.y + 1)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x - 1, tile.y + 2)) == -1 && tilemap.get_cell_source_id(Vector2i(tile.x - 1, tile.y + 3)) == -1:
		removeCell(Vector2i(tile.x, tile.y))
		addCell(Vector2i(tile.x - 1, tile.y + 1), material)
