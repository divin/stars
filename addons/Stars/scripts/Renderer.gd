# Renderer
# Handles the creation of the stars in a MulitMesh object
# Last edited: 17.05.2022
# Copyright © 2022 Divin Gavran
tool
extends MultiMeshInstance

var shader : Resource

var albedo : Color
var point_size : float
var multiplier : Vector3

func enter_tree(data : Array):
	
	# Preload shader
	self.shader = preload("res://addons/Stars/scripts/Stars.gdshader")
	
	self.multimesh = MultiMesh.new()
	self.multimesh.color_format = MultiMesh.COLOR_FLOAT
	self.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	self.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	
	self.multimesh.instance_count = data.size()
	self.multimesh.visible_instance_count = -1
	
	self.multimesh.mesh = PointMesh.new()
	self.multimesh.mesh.material = ShaderMaterial.new()
	self.multimesh.mesh.material.shader = self.shader
	
	self.multimesh.mesh.material.set_shader_param("albedo", self.albedo)
	self.multimesh.mesh.material.set_shader_param("multiplier", self.multiplier)
	self.multimesh.mesh.material.set_shader_param("point_size", self.point_size)
