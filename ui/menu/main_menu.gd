extends Control

func _ready() -> void:
	UI_Controller.stack.screens.append(self)

## Função que roda quando você aperta o botão de "jogar"
func _on_play_button_pressed() -> void:
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)

## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	get_tree().quit() # Fecha a aplicação
