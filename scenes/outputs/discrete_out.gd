extends Node2D

@export var register_label: String
@export var hi_output: int

var num_registers = 28

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var register_binary = value_to_binary(hi_output)
	var register_binary_label = get_node("displayed_value")
	register_binary_label.text = register_binary
	
	
	

func value_to_binary(value):
	""" set the relevant output high by returning a binary string"""
	
	if value == -1:
		return "0000000000000000000000000000"
		
	else:	
		var ret_str = ""
		
		for i in range(28):
			if i==value:
				ret_str = ret_str + "1"
			else:
				ret_str = ret_str + "0"

		return ret_str
		
		

		

	
