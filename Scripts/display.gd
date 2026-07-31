extends Node2D
var digit3
var digit2
var digit1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	digit3 = get_node("Digit3")
	digit2 = get_node("Digit2")
	digit1 = get_node("Digit1")
	

func number_display(input: int):
	#print("your number is {number}".format({"number":input}))
	digit3.frame = 0
	digit2.frame = 0
	digit1.frame = 0
	var input_str = str(input)
	if(input >= 0 and input < 1000):
		digit3.frame = int(input_str[-1])
		if(input > 9):
			digit2.frame = int(input_str[-2])
		if(input > 99):
			digit1.frame = int(input_str[-3])
			
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
