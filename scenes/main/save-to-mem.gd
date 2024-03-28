extends TextureButton

@onready var mainMem = get_node("../../mainMemory")

var opcode_dict = {
	'CLA': '1001',
	'STO': '1011',
	'ADD': '1101',
	'SAD': '1100',
	'SUB': '1111',
	'SSU': '1110',
	'MPY': '0101',
	'SMP': '0100',
	'MMP': '0111',
	'SMM': '0110',
	'COM': '1000',
	'MIM': '1000',
	'ALS': '0000',
	'ARS': '0000',
	'SAL': '0000',
	'SAR': '0000',
	'SLL': '0000',
	'SLR': '0000',
	'SRL': '0000',
	'SRR': '0000',
	'TRA': '1010',
	'TMI': '0010',
	'HPR': '1000',
	'SCL': '0001',
	'ANA': '1000',
	'LPR': '1000',
	'EFC': '1000',
	'HFC': '1000',
	'RSD': '1000',
	'DIA': '1000',
	'DIB': '1000',
	'DOA': '1000',
	'VOA': '1000',
	'VOB': '1000',
	'VOC': '1000',
	'BOA': '1000',
	'BOB': '1000',
	'BOC': '1000',
	'COA': '0000'
}

#binary values for opcodes that are additionally defined in the channel section
#pretty sure these arent the actual values used in the d-17 (manual is unclear)
#but it has no effect on functionality
var opcode_channel_dict = {'COM': '10111',
	'MIM': '10110',
	'ALS': '01011',
	'ARS': '10000',
	'SAL': '01010',
	'SAR': '01111',
	'SLL': '01100',
	'SLR': '10001',
	'SRL': '01101',
	'SRR': '10010',
	'HPR': '01011',
	'ANA': '10101',
	'LPR': '11100',
	'EFC': '11011',
	'HFC': '11000',
	'RSD': '01010',
	'DIA': '11010',
	'DIB': '11001',
	'DOA': '01101',
	'VOA': '01111',
	'VOB': '10000',
	'VOC': '10001',
	'BOA': '00101',
	'BOB': '00110',
	'BOC': '00001',
	'COA': '10100'
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _button_pressed():
	
	var unflagged_control = get_node("../add-unflagged")
	var num_rows = unflagged_control.row_num
	
	for i in range(num_rows):
		var channel = get_channel(i)
		var sector = get_sector(i)

		var channel_node = mainMem.get_child(channel)
		var channel_values = channel_node.register_values
		
		
		var flag = get_flag(i)
		var opcode = get_opcode(i)
		var next_sector = get_next_sector(i)
		var operand_sector = get_operand_sector(i)
		var operand_channel = get_operand_channel(i)
		
		var bstring = opcode + flag + next_sector + operand_channel + operand_sector
		var value_to_write = bstring.bin_to_int()
		
		channel_values[sector-1] = value_to_write
		channel_node.register_values = channel_values
	
	
func get_opcode_text(row):
	var opcode = get_node("../row" + str(row) + "/opcodes")
	#dont know why we cant just return the selected text directly....but this works
	var selected_index = opcode.get_selected_id() - 1
	var selected_opcode = opcode.get_item_text(selected_index)
	return selected_opcode
	
	
func get_channel(row):
	var channel = get_node("../row" + str(row) + "/current_channel")
	var selected_index = channel.get_selected_id()
	var selected_channel = channel.get_item_text(selected_index)
	selected_channel = int(selected_channel)
	return selected_channel
	
func get_sector(row):
	var sector = get_node("../row" + str(row) + "/current_sector")
	var selected_index = sector .get_selected_id()
	var selected_sector  = sector .get_item_text(selected_index)
	selected_sector  = int(selected_sector )
	return selected_sector 
	
func get_flag(row):
	var flag = get_node("../row" + str(row) + "/flag")
	var selected_index = flag.get_selected_id()
	var selected_flag = flag.get_item_text(selected_index)
	return selected_flag
	
func get_opcode(row):
	var opcode = get_node("../row" + str(row) + "/opcodes")
	#dont know why we cant just return the selected text directly....but this works
	var selected_index = opcode.get_selected_id() - 1
	var selected_opcode = opcode.get_item_text(selected_index)
	var binary_opcode = opcode_dict[selected_opcode]
	return binary_opcode
	
func get_next_sector(row):
	
	var next_sector = get_node("../row" + str(row) + "/next_sector")
	var selected_index = next_sector.get_selected_id()
	var selected_next_sector = next_sector.get_item_text(selected_index)
	selected_next_sector = int(selected_next_sector)
	var selected_next_sector_binary = value_to_binary(selected_next_sector, 7)
	return selected_next_sector_binary
	
func get_operand_sector(row):
	var operand_sector = get_node("../row" + str(row) + "/operand_sector")
	var selected_index = operand_sector.get_selected_id()
	var selected_operand_sector = operand_sector.get_item_text(selected_index)
	selected_operand_sector = int(selected_operand_sector)
	var selected_operand_sector_binary = value_to_binary(selected_operand_sector, 7)
	return selected_operand_sector_binary
	
func get_operand_channel(row):
	
	var opcode = get_opcode_text(row)
	print(opcode)
	print(opcode in opcode_channel_dict.keys())
	if opcode in opcode_channel_dict.keys():
		return opcode_channel_dict[opcode]
	
	else:
		var operand_channel = get_node("../row" + str(row) + "/operand_channel")
		var selected_index = operand_channel.get_selected_id()
		var selected_operand_channel = operand_channel.get_item_text(selected_index)
		selected_operand_channel = int(selected_operand_channel)
		var selected_operand_channel_binary = value_to_binary(selected_operand_channel, 5)
		return selected_operand_channel_binary
	

func value_to_binary(value_in, num_registers):
	
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


func signed_bin_to_int(b_string):
	"""
	dedicated function required to return negative cases
	"""
	
	var str_length = b_string.length()
	
	#negative_case
	if b_string[0] == '1':
		var modified_string = b_string.right(str_length-1)
		modified_string = '-0b'+modified_string
		var int_out = modified_string.bin_to_int()
		return int_out
		
	else:
		var int_out = b_string.bin_to_int()
		return int_out
