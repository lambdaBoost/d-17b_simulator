extends Node2D

@export var register_label: String
@export var bitnames_label: String
@export var value1: float
@export var value2: float
@export var value3: float



# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label
	
	var bitnames_node = get_node("bitNames")
	bitnames_node.text = bitnames_label
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var voltage1 = get_node("output1/output_value")
	voltage1.text = str(value1)
	
	var voltage2 = get_node("output2/output_value")
	voltage2.text = str(value2)
	
	var voltage3 = get_node("output3/output_value")
	voltage3.text = str(value3)
	

	
	

func value_to_binary(value):
	
	if value == 0:
		return "0"
		
	
	else:	
		var ret_str = ""
		while (value > 0):
			ret_str = str(value&1) + ret_str
			value = (value>>1)
		return ret_str
		
func value_to_voltage(value):
	"""converts the DAC output to 0-10v value"""
	
	var voltage = 10 * float(value)/255
	voltage = snappedf(voltage, 0.01)
	voltage = str(voltage)
	return voltage
		
		

		

	
