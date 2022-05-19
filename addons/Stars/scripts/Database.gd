# Database
# Handles reading and returning the data of a given CSV file as path_data
# Last edited: 17.05.2022
# Copyright © 2022 Divin Gavran
tool
extends Node

const path_data := "res://addons/Stars/data/Stars.csv"

# Read and returns the data of the CSV file as array
# Skips header by default, can't be changed depening on the CSV file
func get_data(skip_header : bool = true) -> Array:
	var file := File.new()
	var _error = file.open(self.path_data, File.READ)
	var content = file.get_as_text()
	file.close()
	
	content = content.split("\n")
	var data = []
	for item in content:
		var values = item.split(",")
		data.append(values)
	
	if skip_header:
		data = data.slice(1, data.size() - 1)
	
	return data
