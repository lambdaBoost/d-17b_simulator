extends Node2D

@export var register_label: String
@export var register_value: int
var num_registers = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var register_binary = value_to_binary(register_value)
	var register_binary_label = get_node("value_binary")
	register_binary_label.text = register_binary
	
	var dac_value = value_to_voltage(register_value)
	var dac_output_node = get_node("DAC/DAC_Value")
	dac_output_node.text = dac_value

	
	

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
			
		if ret_str.length() > num_registers:
			ret_str = ret_str.right(num_registers)
			

		return ret_str
		
func value_to_voltage(value):
	"""converts the DAC output to 0-20v value"""
	
	var voltage = (40 * float(value)/255) - 20
	voltage = snappedf(voltage, 0.01)
	voltage = str(voltage)
	return voltage
		
		

		

	
