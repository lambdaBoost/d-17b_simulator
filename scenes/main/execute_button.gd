extends TextureButton

@onready var instruction_reg = get_node("../disk-registers/disc-instruction")
@onready var accumulator_reg = get_node("../disk-registers/disc-accumulator")

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
	
	#load channel
	var ch_register = get_node("../flipflops/ff-ch-buffer")
	var channel = instruction.substr(12,5)
	ch_register.displayed_value = channel
	
	print(accumulator_reg.register_value)
	
	#execute instruction. this is an inelegant way of doing it....but cant store functions
	#as dict in godot, and cant use decorators
	if operation == '1001':
		cla()
	elif operation == '1101':
		add()
	
	
	
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

	
	
	
