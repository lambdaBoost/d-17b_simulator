extends Node2D

@export var register_label: String
@export var register_value: int
@export var num_registers: int
@export var bitnames_label: String
@export var displayed_value: String
@export var register_type: String

#var register_value_binary: String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label
	
	var bitnames = get_node("bitNames")
	bitnames.text = bitnames_label


func value_to_binary(value):
	
	if value == 0:
		return "0"
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
		return ret_str


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var register_binary_label = get_node("value_binary")
	
	if register_type == 'arithmetic':
		var register_binary = value_to_binary(register_value)
		register_binary_label.text = register_binary
		
	else:
		register_binary_label.text = displayed_value
