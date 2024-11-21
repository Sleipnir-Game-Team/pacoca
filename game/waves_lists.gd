extends Node

func start_lists(path: String) -> void:
	var enemies_list := []
	var wave : Variant = JsonHandler.acesse_json_file(path)
	var enemies : Variant = wave.get("enemies")
	for enemies_instance : Variant  in enemies:
		var temp_list := [enemies_instance.get("path"), str_to_var(enemies_instance.get("position"))]
		enemies_list.append(temp_list)
	print(enemies_list)
	Waves.add_list(enemies_list)

func read_files(path: String) -> void:
	var waves_list : Variant = JsonHandler.acesse_json_file(path)
	for waves : Variant in waves_list.get("waves"):
		print(waves)
		start_lists(waves)
