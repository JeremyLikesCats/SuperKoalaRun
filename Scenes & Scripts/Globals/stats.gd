extends Node


@onready var heath_label: Label = $"Heath Label"

func heath_change():
	heath_label.text = "x" + str(PlayerGlobals.health)
	
