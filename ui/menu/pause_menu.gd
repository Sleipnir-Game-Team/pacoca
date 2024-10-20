extends Control


## OnClick do botão "Continuar" - resume a execução do jogo
func _on_resume_button_pressed():
	localPause()

## OnClick do botão "Reiniciar" - reinicia o jogo do ínicio do tutorial
func _on_restart_button_pressed():
	localPause()
	UI_Controller.changeScreen("res://main.tscn", get_tree().root)

## OnClick do botão "Menu Principal"
func _on_main_menu_button_pressed():
	localPause()
	UI_Controller.changeScreen("res://ui/menu/main_menu.tscn", get_tree().root) 


## OnClick do botão "Opções"
func _on_options_menu_button_pressed():
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)


## OnClick do botão "Sair"
func _on_quit_button_pressed():
	get_tree().quit()


## Função que roda quando você pausa o jogo
func localPause():
	UI_Controller.managePauseMenu()