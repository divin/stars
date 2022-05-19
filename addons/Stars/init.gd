tool
extends EditorPlugin

func _enter_tree():
	self.add_custom_type("Stars", "Spatial", preload("res://addons/Stars/scripts/Stars.gd"), preload("res://addons/Stars/Stars.png"))

func _exit_tree():
	self.remove_custom_type("Stars")
