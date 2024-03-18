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
	

	
	#set global variable for next sector
	load_next_sector()
	
	#execute instruction. this is an inelegant way of doing it....but cant store functions
	#as dict in godot, and cant use decorators
	if operation == '1001':
		#load operand from memory
		load_value_from_mem(operand_channel, operand_sector)
		cla()
	elif operation == '1101':
		load_value_from_mem(operand_channel, operand_sector)
		add()
	elif operation == '0101':
		load_value_from_mem(operand_channel, operand_sector)
		mpy()
	elif operation == '1111':
		load_value_from_mem(operand_channel, operand_sector)
		sub()
	elif operation == '0000' and operand_channel_binary == '01011':
		als()
	elif operation == '0000' and operand_channel_binary == '10000':
		ars()
	elif operation == '1010':
		load_value_from_mem(operand_channel, operand_sector)
		tra()
	elif operation == '0010':
		load_value_from_mem(operand_channel, operand_sector)
		tmi()
	elif operation == '1000' and operand_channel_binary == '10111':
		com()
	elif operation == '1000' and operand_channel_binary == '10110':
		mim()
	elif operation == '1100':
		load_value_from_mem(operand_channel, operand_sector)
		sad()
	elif operation == '1110':
		load_value_from_mem(operand_channel, operand_sector)
		ssu()
	elif operation == '0100':
		load_value_from_mem(operand_channel, operand_sector)
		smp()
	elif operation == '1000' and operand_channel_binary == '10101':
		ana()
	elif operation == '1011':
		load_value_from_mem(operand_channel, operand_sector)
		sto()
	

func load_first_instruction():
	var first_channel = get_node("../code-sheet/row0/current_channel")
	var first_sector = get_node("../code-sheet/row0/current_sector")
	var first_channel_value = first_channel.get_selected_id()
	var first_sector_value = first_sector.get_selected_id()
	
	next_instruction_channel = first_channel_value
	
	load_instruction_from_mem(first_channel_value, first_sector_value)

	
func load_value_from_mem(channel, sector):
	if channel <= 20:
		var channel_number = str(channel)
		var channel_to_load = get_node("../mainMemory/channel" + channel_number)
		var channel_array = channel_to_load.register_values
		var value = channel_array[sector-1]	
		#copy to number register
		number_reg.register_value = value
		
	elif channel == 21:
		load_value_from_loop(sector, 'H', 16, 4)
	elif channel == 22:
		load_value_from_loop(sector, 'E', 8, 3)
	elif channel == 23:
		load_value_from_loop(sector, 'H', 4, 2)
	elif channel == 24:
		load_value_from_loop(sector, 'V', 4, 2)
	elif channel == 25:
		load_value_from_loop(sector, 'F', 4, 2)
	elif channel == 26:
		load_value_from_loop(sector, 'U', 1, 1)
	elif channel == 27:
		number_reg.register_value = lower_accumulator_reg.register_value
	
	
	
	
func load_value_to_mem(value, channel, sector):
	if channel <= 20:
		var channel_number = str(channel)
		var channel_to_load = get_node("../mainMemory/channel" + channel_number)
		var channel_array = channel_to_load.register_values
		channel_array[sector-1] = value
		channel_to_load.register_values = channel_array
	
	elif channel == 21:
		load_value_to_loop(sector, 'H', 16, 4, value)
	elif channel == 22:
		load_value_to_loop(sector, 'E', 8, 3, value)
	elif channel == 23:
		load_value_to_loop(sector, 'H', 4, 2, value)
	elif channel == 24:
		load_value_to_loop(sector, 'V', 4, 2, value)
	elif channel == 25:
		load_value_to_loop(sector, 'F', 4, 2, value)
	elif channel == 26:
		load_value_to_loop(sector, 'U', 1, 1, value)
	elif channel == 27:
		lower_accumulator_reg.register_value = value
	
	
func load_value_from_loop(sector, loop_name, loop_size, bitsize):
		var channel_to_load = get_node("../loops/" + loop_name + "-loop")
		var sector_binary = value_to_binary(sector, 7)
		sector_binary = sector_binary.right(bitsize)
		var sector_number = sector_binary.bin_to_int()
		var channel_array = channel_to_load.register_values
		var value = channel_array[sector-1]	
		number_reg.register_value = value
		
		
func load_value_to_loop(sector, loop_name, loop_size, bitsize, value):
		var channel_to_load = get_node("../loops/" + loop_name + "-loop")
		var sector_binary = value_to_binary(sector, 7)
		sector_binary = sector_binary.right(bitsize)
		var sector_number = sector_binary.bin_to_int()
		var channel_array = channel_to_load.register_values
		channel_array[sector-1] = value	
		channel_to_load.register_values = channel_array
		
		
	
func sto():
	
	var accumulator_value = accumulator_reg.register_value
	load_value_to_mem(accumulator_value, operand_channel, operand_sector)

	
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
	
	
	var new_accumulator_binary = current_accumulator_binary.substr(operand_sector +1 , (24-operand_sector))
	var sign_bit = current_accumulator_binary.substr(0,1)
	var trailing_zeros = "0".repeat(operand_sector)
	new_accumulator_binary = sign_bit + new_accumulator_binary + trailing_zeros
	var new_accumulator = signed_bin_to_int(new_accumulator_binary)
	
	accumulator_reg.register_value = new_accumulator
	
	
func ars():
	var current_accumulator = accumulator_reg.register_value
	var current_accumulator_binary = value_to_binary(current_accumulator, 24)

	
	var new_accumulator_binary = current_accumulator_binary.substr(1, (24-operand_sector))
	var sign_bit = current_accumulator_binary.substr(0,1)
	var leading_zeros = "0".repeat(operand_sector)
	new_accumulator_binary = sign_bit + leading_zeros + new_accumulator_binary
	
	var new_accumulator = signed_bin_to_int(new_accumulator_binary)
	accumulator_reg.register_value = new_accumulator
	
	
func tra():
	next_instruction_sector = operand_sector
	next_instruction_channel = operand_channel
	
func tmi():
	var accumulator_value = accumulator_reg.register_value
	if accumulator_value < 0:
		tra()

func com():
	var accumulator_value = accumulator_reg.register_value
	var new_accumulator_value = accumulator_value * -1
	accumulator_reg.register_value = new_accumulator_value

	
func mim():
	var accumulator_value = accumulator_reg.register_value
	if accumulator_value > 0:
		var new_accumulator_value = accumulator_value * -1
		accumulator_reg.register_value = new_accumulator_value
		
		
func sad():
	var accumulator_binary = value_to_binary(accumulator_reg.register_value,24)
	var accumulator_left = accumulator_binary.substr(0,10)
	var accumulator_right = accumulator_binary.substr(14,10)

	
	var operand_binary = value_to_binary(number_reg.register_value,24)
	var operand_left = operand_binary.substr(0,10)
	var operand_right = operand_binary.substr(14,10)
	
	var accumulator_left_int = signed_bin_to_int(accumulator_left)
	var accumulator_right_int = signed_bin_to_int(accumulator_right)
	var operand_left_int = signed_bin_to_int(operand_left)
	var operand_right_int = signed_bin_to_int(operand_right)

	
	var left_new = value_to_binary(accumulator_left_int + operand_left_int, 12)
	var right_new = value_to_binary(accumulator_right_int + operand_right_int, 12)
	
	var new_acc_binary = left_new + right_new
	var new_acc = signed_bin_to_int(new_acc_binary)
	accumulator_reg.register_value = new_acc
	
func ssu():
	var accumulator_binary = value_to_binary(accumulator_reg.register_value,24)
	var accumulator_left = accumulator_binary.substr(0,10)
	var accumulator_right = accumulator_binary.substr(14,10)

	
	var operand_binary = value_to_binary(number_reg.register_value,24)
	var operand_left = operand_binary.substr(0,10)
	var operand_right = operand_binary.substr(14,10)
	
	var accumulator_left_int = signed_bin_to_int(accumulator_left)
	var accumulator_right_int = signed_bin_to_int(accumulator_right)
	var operand_left_int = signed_bin_to_int(operand_left)
	var operand_right_int = signed_bin_to_int(operand_right)

	
	var left_new = value_to_binary(accumulator_left_int - operand_left_int, 12)
	var right_new = value_to_binary(accumulator_right_int - operand_right_int, 12)
	
	var new_acc_binary = left_new + right_new
	var new_acc = signed_bin_to_int(new_acc_binary)
	accumulator_reg.register_value = new_acc
	
	
func smp():
	
	var accumulator_binary = value_to_binary(accumulator_reg.register_value,24)
	var accumulator_left = accumulator_binary.substr(0,10)
	var accumulator_right = accumulator_binary.substr(14,10)

	
	var operand_binary = value_to_binary(number_reg.register_value,24)
	var operand_left = operand_binary.substr(0,10)
	var operand_right = operand_binary.substr(14,10)
	
	var accumulator_left_int = signed_bin_to_int(accumulator_left)
	var accumulator_right_int = signed_bin_to_int(accumulator_right)
	var operand_left_int = signed_bin_to_int(operand_left)
	var operand_right_int = signed_bin_to_int(operand_right)
	
	var l_accumulator_binary = accumulator_right + '0000' + accumulator_left
	var l_accumulator_new = signed_bin_to_int(l_accumulator_binary)
	lower_accumulator_reg.register_value = l_accumulator_new
	
	var new_acc_right = accumulator_right_int * operand_right_int
	var new_acc_left = accumulator_left_int * operand_left_int
	
	var new_acc_right_bin = value_to_binary(new_acc_right, 10)
	var new_acc_left_bin = value_to_binary(new_acc_left, 10)
	
	var new_acc_binary = new_acc_right_bin + '0000' + new_acc_left_bin
	var new_acc = signed_bin_to_int(new_acc_binary)
	
	accumulator_reg.register_value = new_acc
	
func ana():
	
	var acc_new = ""
	var acc_current = value_to_binary(accumulator_reg.register_value, 24)
	var l_acc_current = value_to_binary(lower_accumulator_reg.register_value, 24)
	
	for i in range(acc_current.length()):
		if acc_current[i] == '1' and l_acc_current[i] == '1':
			acc_new = acc_new + '1'
		else:
			acc_new = acc_new + '0'
			
	print(acc_new)
	var acc_new_dec = signed_bin_to_int(acc_new)
	print(acc_new_dec)
	accumulator_reg.register_value = acc_new_dec
	
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
			
		if ret_str.length() > num_registers:
			ret_str = ret_str.right(num_registers) #TODO - this is a temp fix

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
	
