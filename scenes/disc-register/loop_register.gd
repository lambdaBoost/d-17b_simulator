extends Node2D

@export var channel_label: int
@export var register_values: Array
@export var num_registers: int
@export var num_sectors: int
@export var memory_type: String
@export var loop_name_text: String



# Called when the node enters the scene tree for the first time.
func _ready():
	
	#var label = get_node("Label")
	#label.text = register_label
	
	var channel_label_node = get_node("channel_label")
	channel_label_node.text = str(channel_label)
		
	
	if memory_type == "loop":
		add_sectors(num_sectors)
		add_loop_names()
		initialise_values(num_sectors)
		
	else:
		var dropdown_node = get_node("OptionButton")
		remove_child(dropdown_node)
		
		initialise_values(num_sectors)
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if memory_type == 'loop':
		var value = update_loop_displayed_value()
		var register_binary = value_to_binary(value)
		var register_binary_label = get_node("displayed_value")
		register_binary_label.text = register_binary
	else:
		var value = update_mainmem_displayed_value()
		var register_binary = value_to_binary(value)
		var register_binary_label = get_node("displayed_value")
		register_binary_label.text = register_binary
	
	
	

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
		if ret_str.length() == num_registers:
			return ret_str
			
		while ret_str.length() < num_registers-1:
			ret_str = "0" + ret_str
					
		
		if value_in < 0:
			ret_str = "1" + ret_str
		else:
			ret_str = "0" + ret_str
			

		return ret_str
		
	
		
		
func add_sectors(value):
	""" adds an object variable that defines the number of sectors for the register"""
	
	var sector_options = get_node("OptionButton")
	for i in range(value):
		sector_options.add_item(str(i),i+1)
		
		
func update_loop_displayed_value():
	
	var sector_options = get_node("OptionButton")
	var selected_sector = sector_options.get_selected_id()
	
	var decimal_value_to_display = register_values[selected_sector-1]
	return decimal_value_to_display
	
func update_mainmem_displayed_value():
	
	var sector_options = get_node("../sectorSelect")
	var selected_sector = sector_options.get_selected_id()
	
	var decimal_value_to_display = register_values[selected_sector-1]
	return decimal_value_to_display
	
func initialise_values(n_sectors):
	register_values = []
	for i in range(n_sectors):
		register_values.append(0)

func add_loop_names():
	var loop_name = get_node("loop-name")
	loop_name.text = loop_name_text
	
