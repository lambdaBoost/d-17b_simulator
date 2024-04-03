extends Node2D

@export var register_label: String
@export var register_value: int
@export var num_registers: int
@export var num_sectors: int
@export var displayed_value: String
@export var register_type: String #arithmetic or instruction (store in decimal or binary string)
@export var accumulator_flag: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var register_binary_label = get_node("value_binary")
	
	if register_value >= 10000000000:
		var value_str = str(register_value)
		value_str = value_str.left(10)
		var new_val = int(value_str)
		register_value = new_val
	
	
	if register_type == 'arithmetic':
		var register_binary = value_to_binary(register_value)
		register_binary_label.text = register_binary
		
	else:
		register_binary_label.text = displayed_value
	
	
	

func value_to_binary(value_in):
	
	var value = abs(value_in)
	
	if value == 0:
		return "0".repeat(num_registers)
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
			
		#this covers the case where instructions are sent to the i-register
		#may cause issues later with arithmetic operations (might not though)	
		if ret_str.length() == num_registers and accumulator_flag == false:
			return ret_str
			
		while ret_str.length() < num_registers-1:
			ret_str = "0" + ret_str
					
		
		if value_in < 0:
			ret_str = "1" + ret_str
		else:
			ret_str = "0" + ret_str
		
		#TODO - set to take left side for registers in case of overflow
		#this ensures magnitude is correct bur precision lost on overflow
		#ie, it is set up for floats not ints - integer overflows will give incorrect results
		if ret_str.length() > num_registers and accumulator_flag == true:
			if value_in < 0:
				ret_str = ret_str.left(num_registers) #TODO - set to take left side for registers			
			else:
				ret_str = ret_str.left(num_registers)#TODO - might not need the -1 here
		return ret_str
		
		

		

	
