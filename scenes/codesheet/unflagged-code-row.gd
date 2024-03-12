extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_channels()
	add_sectors()
	add_ops()
	add_flag()
	add_next_sector()
	add_operand_channel()
	add_operand_sector()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func add_channels():
	var channel_dropdown = get_node("current_channel")
	for i in range(20):
		channel_dropdown.add_item(str(i),i)
		
func add_sectors():
	var sector_dropdown = get_node("current_sector")
	for i in range(127):
		sector_dropdown.add_item(str(i),i)

func add_ops():
	""" adds all opcodes"""
	var opcodes = ['CLA', 'STO', 'ADD', 'SAD', 'SUB',
	'SSU', 'MPY', 'SMP', 'MMP', 'SMM', 'COM', 'MIM',
	'ALS', 'ARS', 'SAL', 'SAR', 'SLL', 'SLR', 'SRL',
	'SRR', 'TRA', 'TMI', 'HPR', 'SCL', 'ANA', 'LPR',
	'EFC', 'HFC', 'RSD', 'DIA', 'DIB', 'DOA', 'VOA',
	'VOB', 'VOC', 'BOA', 'BOB', 'BOC', 'COA']
	var opcode_dropdown = get_node("opcodes")
	for i in range(len(opcodes)):
		opcode_dropdown.add_item(opcodes[i],i+1)
		
func add_flag():
	var flag = get_node("flag")
	flag.add_item(str(0),0)
	
func add_next_sector():
	var next_sector = get_node("next_sector")
	for i in range(128):
		next_sector.add_item(str(i),i)
	
func add_operand_channel():
	var operand_channel = get_node("operand_channel")
	for i in range(27):
		operand_channel.add_item(str(i),i)
		
func add_operand_sector():
	var operand_sector = get_node("operand_sector")
	for i in range(128):
		operand_sector.add_item(str(i),i)
		
func assemble_to_binary():
	pass
	

	

