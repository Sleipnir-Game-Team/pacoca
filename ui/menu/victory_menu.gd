extends Control


func _on_restart_button_pressed() -> void:
	SfxGlobals.play_global("play")
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)


func _on_main_menu_button_pressed() -> void:
	SfxGlobals.play_global("click")
	UI_Controller.changeScreen("res://ui/menu/main_menu.tscn", get_tree().root) 


func _on_quit_button_pressed() -> void:
	SfxGlobals.play_global("click")
	get_tree().quit()
