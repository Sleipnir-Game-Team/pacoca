extends Node

var json = JSON.new()
var data = {}

func acesse_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	return content
	
func save_on_json_file(file_path,data):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(json.stringify(data))
	file.close()
	file = null
