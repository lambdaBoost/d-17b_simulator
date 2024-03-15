extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _button_pressed():
	
	var sector = get_sector()
	var channel = get_channel()
	add_value_to_mem(sector, channel)

func get_sector():
	
	var sector_options = get_node("../../sectorSelect")
	var selected_sector = sector_options.get_selected_id()
	return selected_sector
	
func get_channel():
	var channel_options = get_node("../channelSelect")
	var selected_channel= channel_options.get_selected_id()
	return selected_channel
	
func add_value_to_mem(sector, channel):
	var new_value_node = get_node("../LineEdit")
	var new_value = new_value_node.text
	
	var new_value_decimal = signed_24_bin_to_int(new_value)
	
	var channel_node_name = "../../channel" + str(channel)
	var channel_node = get_node(channel_node_name)
	
	var values_array = channel_node.register_values
	values_array[sector-1] = new_value_decimal #dont know why we need to -1 here
	channel_node.register_values = values_array
	
	

func signed_24_bin_to_int(b_string):
	"""
	dedicated function required to return negative cases
	"""
	
	var str_length = b_string.length()
	
	#negative_case
	if b_string[0] == '1' and b_string.length() == 24:
		var modified_string = b_string.right(str_length-1)
		modified_string = '-0b'+modified_string
		var int_out = modified_string.bin_to_int()
		return int_out
		
	else:
		var int_out = b_string.bin_to_int()
		return int_out
