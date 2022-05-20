extends Spatial

onready var stars = self.get_node("Stars")

func _on_Button_pressed():
	self.stars.coordinate_system = int(!bool(self.stars.coordinate_system))
