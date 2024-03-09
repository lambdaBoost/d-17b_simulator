extends Node2D

@export var register_label: String
@export var register_value: int

@export var num_registers:int

# Called when the node enters the scene tree for the first time.
func _ready():
	var register_label_node = get_node("Label")
	register_label_node.text = register_label




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var register_binary = value_to_binary(register_value)
	var register_binary_label = get_node("displayed_value")
	register_binary_label.text = register_binary
	
	
	

func value_to_binary(value):
	""" set the relevant output high by returning a binary string"""
	
	if value == 0:
		return "0".repeat(num_registers)
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
		return ret_str

		return ret_str
		
		

		

	