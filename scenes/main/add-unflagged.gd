extends TextureButton

var row_interval = 40
var first_row_y = 1320
var row_x = 170
var current_y = first_row_y
@export var row_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _button_pressed():
	add_unflagged_row()
	
func add_unflagged_row():
	
	var code_row = preload("res://scenes/codesheet/unflagged-code-row.tscn")
	var code_row_instance = code_row.instantiate()
	code_row_instance.name = "row"+str(row_num)
	code_row_instance.position.y = current_y
	code_row_instance.position.x = row_x
	
	#remove headers
	if current_y > first_row_y:
		for child in code_row_instance.get_children():
			for subchild in child.get_children():
				if subchild is Label:
					subchild.text = ""
	
	var root_node = get_node("../../code-sheet")
	root_node.add_child(code_row_instance)
	current_y = current_y + row_interval
	row_num = row_num+1
	
