extends Node

func start_lists(path):
	var enemies_list = []
	var wave = JsonHandler.acesse_json_file(path)
	var enemies = wave.get("enemies")
	for enemies_instance in enemies:
		var temp_list = [enemies_instance.get("path"), str_to_var(enemies_instance.get("position"))]
		enemies_list.append(temp_list)
	print(enemies_list)
	Waves.add_list(enemies_list)

func read_files(path):
	var waves_list = JsonHandler.acesse_json_file(path)
	for waves in waves_list.get("waves"):
		print(waves)
		start_lists(waves)
