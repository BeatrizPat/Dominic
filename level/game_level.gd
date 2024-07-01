extends Node2D

@onready var score_label := $CanvasLayer/Control/score as Label
var score := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("global")
	score_label.text = str(int(score))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func pontuacao_update():
	print("update")
	score += 1
	score_label.text = str(int(score))
