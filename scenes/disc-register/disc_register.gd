extends Node2D

@export var register_label: String
@export var register_value: int
@export var num_registers: int
@export var num_sectors: int
@export var displayed_value: String
@export var register_type: String #arithmetic or instruction (store in decimal or binary string)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var register_binary_label = get_node("value_binary")
	
	if register_type == 'arithmetic':
		var register_binary = value_to_binary(register_value)
		register_binary_label.text = register_binary
		
	else:
		register_binary_label.text = displayed_value
	
	
	

func value_to_binary(value):
	
	if value == 0:
		return "0".repeat(num_registers)
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
		
		while ret_str.length() < num_registers:
			ret_str = "0" + ret_str
			
		return ret_str
		
		

		

	
