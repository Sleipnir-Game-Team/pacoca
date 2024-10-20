extends Control

func _enter_tree() -> void:
	SleipnirMaestro.change_song("miwa_menu")

func _ready() -> void:
	SleipnirMaestro.play()
	UI_Controller.stack.screens.append(self)

## Função que roda quando você aperta o botão de "jogar"
func _on_play_button_pressed() -> void:
	SfxGlobals.play_global("play")
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	SfxGlobals.play_global("click")
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	SfxGlobals.play_global("click")
	get_tree().quit() # Fecha a aplicação

func _exit_tree() -> void:
	SleipnirMaestro.stop()
