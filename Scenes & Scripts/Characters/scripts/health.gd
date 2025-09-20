extends Label

func _process(delta: float) -> void:
	self.text = str(get_tree().get_nodes_in_group("Player")[0].health)
