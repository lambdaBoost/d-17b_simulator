extends TextureButton

@onready var instruction_reg = get_node("../disk-registers/disc-instruction")
@onready var accumulator_reg = get_node("../disk-registers/disc-accumulator")
@onready var lower_accumulator_reg = get_node("../disk-registers/disc-lower-accumulator")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	
	#load instruction from 	memory
	
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
	var channel = instruction.substr(12,5)
	ch_register.displayed_value = channel
	
	#load sector
	var operand_sector = instruction.substr(17,7)
	var operand_sector_decimal = operand_sector.bin_to_int()
	
	#execute instruction. this is an inelegant way of doing it....but cant store functions
	#as dict in godot, and cant use decorators
	if operation == '1001':
		cla()
	elif operation == '1101':
		add()
	elif operation == '1100':
		mpy()
	elif operation == '1111':
		sub()
	elif operation == '0000' and channel == '10010':
		als(operand_sector_decimal)
	elif operation == '0000' and channel == '11010':
		ars(operand_sector_decimal)
		
	
	
	
func load_from_instruction_register():
	
	var instruction = instruction_reg.displayed_value
	return instruction
	


func cla():
	var operand = instruction_reg.displayed_value.substr(12,12)
	var accumulator_value = operand.bin_to_int()
	accumulator_reg.register_value = accumulator_value
	
func add():
	var operand = instruction_reg.displayed_value.substr(12,12)
	var operand_value = operand.bin_to_int()
	
	var current_accumulator = accumulator_reg.register_value
	var new_accumulator = current_accumulator + operand_value
	accumulator_reg.register_value = new_accumulator
	
func mpy():
	var operand = instruction_reg.displayed_value.substr(12,12)
	var operand_value = operand.bin_to_int()
	var current_accumulator = accumulator_reg.register_value
	
	lower_accumulator_reg.register_value = current_accumulator
	var new_accumulator = current_accumulator * operand_value
	accumulator_reg.register_value = new_accumulator
	
func sub():
	var operand = instruction_reg.displayed_value.substr(12,12)
	var operand_value = operand.bin_to_int()
	
	var current_accumulator = accumulator_reg.register_value
	var new_accumulator = current_accumulator - operand_value
	accumulator_reg.register_value = new_accumulator
	
func als(operand_s):
	var current_accumulator = accumulator_reg.register_value
	var current_accumulator_binary = value_to_binary(current_accumulator, 24)

	
	var new_accumulator_binary = current_accumulator_binary.substr(operand_s, (24-operand_s))
	var trailing_zeros = "0".repeat(operand_s)
	new_accumulator_binary = new_accumulator_binary + trailing_zeros
	
	var new_accumulator = new_accumulator_binary.bin_to_int()
	accumulator_reg.register_value = new_accumulator
	
	
func ars(operand_s):
	var current_accumulator = accumulator_reg.register_value
	var current_accumulator_binary = value_to_binary(current_accumulator, 24)

	
	var new_accumulator_binary = current_accumulator_binary.substr(0, (24-operand_s))
	var leading_zeros = "0".repeat(operand_s)
	new_accumulator_binary = leading_zeros + new_accumulator_binary
	
	var new_accumulator = new_accumulator_binary.bin_to_int()
	accumulator_reg.register_value = new_accumulator
	
	
	
	
	
	
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

	
	
	
