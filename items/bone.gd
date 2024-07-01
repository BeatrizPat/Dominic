extends Area2D

signal bone_taken
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("global")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	print("bone") # Replace with function body.
	get_tree().call_group("global", "pontuacao_update")
	queue_free()
	#emit_signal("bone_taken")
