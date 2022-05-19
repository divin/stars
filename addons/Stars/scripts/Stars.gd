# Stars
# Base class which handles everything
# Last edited: 17.05.2022
# Copyright © 2022 Divin Gavran
tool
extends Spatial

# References to the helper classes
var database : Node
var renderer : MultiMeshInstance

## Sets the radius of the sphere, if the coordinate system is Spherical
export (float) var radius = 100.0 setget set_radius

## Sets the point size of stars
export (float) var point_size = 1.0 setget set_point_size

## Sets the multiplier of the star color
export (Vector3) var multiplier = Vector3.ONE setget set_multiplier

## Sets the base star color
export (Color, RGBA) var albedo = Color(1.0, 1.0, 1.0, 1.0) setget set_albedo

# Coordinate system
export (int, "Spherical", "Cartesian") var coordinate_system = 0 setget set_coordinate_system

func _enter_tree() -> void:
	# Add database
	self.database = preload("res://addons/Stars/scenes/Database.tscn").instance()
	self.add_child(self.database)
	
	# Get data
	var data = self.database.get_data()
	
	# Add renderer
	self.renderer = preload("res://addons/Stars/scenes/Renderer.tscn").instance()
	
	# Set shader parameters
	self.renderer.albedo = self.albedo
	self.renderer.multiplier = self.multiplier
	self.renderer.point_size = self.point_size
	
	self.add_child(self.renderer)
	self.renderer.enter_tree(data)
	
	# Create stars
	self.create_stars(data)

func set_point_size(value : float) -> void:
	point_size = value
	self.update()

func set_radius(value : float) -> void:
	radius = value
	self.update()

func set_multiplier(value : Vector3) -> void:
	multiplier = value
	self.update()

func set_albedo(value : Color) -> void:
	albedo = value
	self.update()

func set_coordinate_system(value : int):
	coordinate_system = value
	self.update()

func update() -> void:
	if not self.is_inside_tree():
		return
	
	# Check database
	if self.database != null:
		self.database.queue_free()
	
	# Check renderer
	if self.renderer != null:
		self.renderer.queue_free()
	
	# Re-enter the tree
	self._enter_tree()

func create_stars(data : Array):
	
	# Update instance count
	self.renderer.multimesh.instance_count = data.size()
	
	var index = 0
	for star in data:
		
		if star.size() < 6:
			continue
		
		# Get data
		#var name = star[0] # name of the star
		var magnitude := float(star[1]) # appareant magnitude
		
		# Generate coordinate 
		var x : float
		var y : float
		var z : float
		
		# Cartesian coordinates
		if self.coordinate_system:
			x = float(star[4]) # x value
			y = float(star[5]) # y value
			z = float(star[6]) # z value
		
		# Spherical Coordinates
		else:
			var longitude := float(star[2]) # longitude
			var latitude := float(star[3]) # latitude
			x = self.radius * sin(latitude) * cos(longitude)
			y = self.radius * sin(latitude) * sin(longitude)
			z = self.radius * cos(latitude)
		
		# Set position
		var position : Vector3 = Vector3(x, y, z)
		
		# Set position
		self.renderer.multimesh.set_instance_transform(index, Transform(Basis(), position))
		
		# Generate color
		var red = float(star[7])
		var green = float(star[8])
		var blue = float(star[9])
		var color = Color(red, green, blue, 1.0)
		
		# Add color
		self.renderer.multimesh.set_instance_custom_data(index, color)
		
		index += 1
