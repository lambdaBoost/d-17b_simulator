extends TextureButton

@onready var instruction_reg = get_node("../disk-registers/disc-instruction")
@onready var accumulator_reg = get_node("../disk-registers/disc-accumulator")
@onready var lower_accumulator_reg = get_node("../disk-registers/disc-lower-accumulator")
@onready var number_reg = get_node("../disk-registers/disc-number")

var next_instruction_channel
var next_instruction_sector
var first_instruction = true
var operand_sector
var operand_channel
var operand

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)
	

func _button_pressed():
	
	if first_instruction:
		load_first_instruction()
		first_instruction = false
	
	#load instruction from 	memory
	else:
		load_instruction_from_mem(next_instruction_channel, next_instruction_sector)
	
	
	#load instruction from register
	var instruction = load_from_instruction_register()
	
	
	#load op code
	var op_register = get_node("../flipflops/ff-op-buffer")
	var operation = instruction.substr(0,4)
	op_register.displayed_value = operation
	
	#load flag
	
	#load flag store location
	
	#load operand channel
	var ch_register = get_node("../flipflops/ff-ch-buffer")
	var operand_channel_binary = instruction.substr(12,5)
	operand_channel = operand_channel_binary.bin_to_int()
	ch_register.displayed_value = operand_channel_binary
	
	#load operand sector
	var operand_sector_binary = instruction.substr(17,7)
	operand_sector = operand_sector_binary.bin_to_int()
	
	#load operand to number register
	load_value_from_mem(operand_channel, operand_sector)
	
	#set global variable for next sector
	load_next_sector()
	
	#execute instruction. this is an inelegant way of doing it....but cant store functions
	#as dict in godot, and cant use decorators
	if operation == '1001':
		cla()
	elif operation == '1101':
		add()
	elif operation == '0101':
		mpy()
	elif operation == '1111':
		sub()
	elif operation == '0000' and operand_channel_binary == '10010':
		als()
	elif operation == '0000' and operand_channel_binary == '11010':
		ars()
	elif operation == '1010':
		tra()
		
	

func load_first_instruction():
	var first_channel = get_node("../code-sheet/row0/current_channel")
	var first_sector = get_node("../code-sheet/row0/current_sector")
	
	var first_channel_value = first_channel.get_selected_id()
	var first_sector_value = first_sector.get_selected_id()
	
	next_instruction_channel = first_channel_value
	
	load_instruction_from_mem(first_channel_value, first_sector_value)

	
func load_value_from_mem(channel, sector):
	var channel_number = str(channel)
	var channel_to_load = get_node("../mainMemory/channel" + channel_number)
	var channel_array = channel_to_load.register_values
	var value = channel_array[sector-1]	
	
	#copy to number register
	number_reg.register_value = value
	
	
	
	
func load_instruction_from_mem(channel, sector):
	var channel_number = str(channel)
	var channel_to_load = get_node("../mainMemory/channel" + channel_number)
	var channel_array = channel_to_load.register_values
	var instruction = channel_array[sector-1]
	instruction = value_to_binary(instruction, 24)
	instruction_reg.displayed_value = instruction
	
	
func load_from_instruction_register():
	
	var instruction = instruction_reg.displayed_value
	return instruction
	

func load_next_sector():
	var instruction = load_from_instruction_register()
	var next_instruction_bin = instruction.substr(5,7)
	next_instruction_sector = next_instruction_bin.bin_to_int()


func cla():
	var operand = number_reg.register_value
	accumulator_reg.register_value = operand
	
func add():
	var operand = number_reg.register_value
	
	
	var current_accumulator = accumulator_reg.register_value
	var new_accumulator = current_accumulator + operand
	accumulator_reg.register_value = new_accumulator
	
func mpy():
	var operand = number_reg.register_value
	var current_accumulator = accumulator_reg.register_value
	
	lower_accumulator_reg.register_value = current_accumulator
	var new_accumulator = current_accumulator * operand
	accumulator_reg.register_value = new_accumulator
	
func sub():
	var operand = number_reg.register_value
	
	var current_accumulator = accumulator_reg.register_value
	var new_accumulator = current_accumulator - operand
	accumulator_reg.register_value = new_accumulator
	
func als():
	var current_accumulator = accumulator_reg.register_value
	var current_accumulator_binary = value_to_binary(current_accumulator, 24)

	
	var new_accumulator_binary = current_accumulator_binary.substr(operand_sector, (24-operand_sector))
	var trailing_zeros = "0".repeat(operand_sector)
	new_accumulator_binary = new_accumulator_binary + trailing_zeros
	
	var new_accumulator = new_accumulator_binary.bin_to_int()
	accumulator_reg.register_value = new_accumulator
	
	
func ars():
	var current_accumulator = accumulator_reg.register_value
	var current_accumulator_binary = value_to_binary(current_accumulator, 24)

	
	var new_accumulator_binary = current_accumulator_binary.substr(0, (24-operand_sector))
	var leading_zeros = "0".repeat(operand_sector)
	new_accumulator_binary = leading_zeros + new_accumulator_binary
	
	var new_accumulator = new_accumulator_binary.bin_to_int()
	accumulator_reg.register_value = new_accumulator
	
	
func tra():
	next_instruction_sector = operand_sector
	next_instruction_channel = operand_channel
	
	
	
	
func value_to_binary(value, n_regs):
	
	if value == 0:
		return "0".repeat(n_regs)
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
		
		while ret_str.length() < n_regs:
			ret_str = "0" + ret_str
			
		return ret_str

	
	
	
