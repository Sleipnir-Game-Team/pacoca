extends Node

var stack: ScreenStack = ScreenStack.new()
var pause_menu_on = false

class ScreenStack:
	var screens: Array[Node]  = []
	
	func add(scene: PackedScene, parent: Node):
		var screen: Node = scene.instantiate()
		
		screens.append(screen)
		
		parent.add_child(screen)
	
	
	func pop():
		if screens.size() > 0:
			var screen = screens.pop_back()
			screen.queue_free()
			return screen
		else:
			Logger.fatal("Não há cena para liberar")


func openScreen(screen_path: String, parent: Node):
	var newScreen
	
	if screen_path != null:
		newScreen = load(screen_path)
	
	stack.add(newScreen, parent)


func changeScreen(screen_path: String, parent: Node):
	var newScreen
	
	if screen_path != null:
		newScreen = load(screen_path)
	
	while stack.screens != []:
		stack.pop()
	
	stack.add(newScreen, parent)


func freeScreen():
	return stack.pop()


func managePauseMenu():
	if !pause_menu_on:
		pause_menu_on = true
		Game_Manager.pause()
		openScreen("res://ui/menu/pause_menu.tscn", get_tree().root)
	else:
		if(freeScreen().name == "PauseMenu"):
			pause_menu_on = false
			Game_Manager.resume()
			
