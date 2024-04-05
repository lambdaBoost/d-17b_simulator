extends Node2D

@export var register_label: String
@export var bitnames_label: String
@export var value1: float
@export var value2: float
@export var value3: float
@export var output_label: int

@onready var phase_reg = get_node('../phase-register')
@onready var voa = get_node('../voltage1')
@onready var vob = get_node('../voltage2')
@onready var voc = get_node('../voltage3')

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var label = get_node("Label")
	label.text = register_label
	
	var bitnames_node = get_node("bitNames")
	bitnames_node.text = bitnames_label
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	this is really inelegant but it's the last addition before the video
	im kind of done with this now
	
	"""
	value1 = (40 * float(voa.register_value)/255) - 20
	value2 = (40 * float(vob.register_value)/255) - 20
	value3 = (40 * float(voc.register_value)/255) - 20
	
	value1 = snappedf(value1, 0.01)
	value2 = snappedf(value2, 0.01)
	value3 = snappedf(value3, 0.01)
	
	var voltage1 = get_node("output1/output_value")
	var voltage2 = get_node("output2/output_value")
	var voltage3 = get_node("output3/output_value")
	
	if output_label == 0:
		if phase_reg.displayed_value == '111' or phase_reg.displayed_value == '010':
			
			voltage1.text = str(value1)
			voltage2.text = str(value2)
			voltage3.text = str(value3)
			
		else:
			voltage1.text = '-20'
			voltage2.text = '-20'
			voltage3.text = '-20'
			
	if output_label == 1:
		if phase_reg.displayed_value == '110' or phase_reg.displayed_value == '010':
			
			voltage1.text = str(value1)
			voltage2.text = str(value2)
			voltage3.text = str(value3)
		
		else:
			voltage1.text = '-20'
			voltage2.text = '-20'
			voltage3.text = '-20'
		
	if output_label == 2:
		if phase_reg.displayed_value == '100' or phase_reg.displayed_value == '000':
			
			voltage1.text = str(value1)
			voltage2.text = str(value2)
			voltage3.text = str(value3)
		
		else:
			voltage1.text = '-20'
			voltage2.text = '-20'
			voltage3.text = '-20'
			
	if output_label == 3:
		if phase_reg.displayed_value == '101' or phase_reg.displayed_value == '001':
			
			voltage1.text = str(value1)
			voltage2.text = str(value2)
			voltage3.text = str(value3)
			
		else:
			voltage1.text = '-20'
			voltage2.text = '-20'
			voltage3.text = '-20'
	

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
		
		

		

	
