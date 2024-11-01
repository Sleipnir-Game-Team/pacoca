extends Control

func _ready() -> void:
	if SleipnirMaestro._current_song_node != null and SleipnirMaestro._current_song_node.is_playing():
		SleipnirMaestro.change_song("main_menu",true,"CUT")
	else:
		SleipnirMaestro.change_song("main_menu")
		SleipnirMaestro.play()
	UI_Controller.stack.screens.append(self)

## Função que roda quando você aperta o botão de "jogar"
func _on_play_button_pressed() -> void:
	AudioManager.play_global("ui.play")
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	get_tree().quit() # Fecha a aplicação
