extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(128):
		self.add_item(str(i),i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
