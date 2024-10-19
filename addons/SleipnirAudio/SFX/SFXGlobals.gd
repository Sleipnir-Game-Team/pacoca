@tool
extends Node
## (singleton) Sound Effects que podem levar trigger de qualquer lugar do projeto
##
## Utilize esta cena para sons que irão se repetir em multiplos lugares pelo jogo
## como botões de UI, ataques em comum de inimigos, e etc.

var child_nodes : Array[Variant] = []  ## Lista de AudioStreamPlayer's Globais
var child_search: Array[String]  = []  ## Lista dos nomes de cada AudioStreamPlayer, para busca mais facil

func _ready() -> void:
	child_nodes.clear()
	child_search.clear()
	child_nodes = _get_all(self)
	Logger.info("SFX Globais são:"+str(child_search))
## Método para tocar um SFX Global
func play_global(sfx_name: String) -> void: AudioManager.play_sfx(child_nodes[child_search.find(sfx_name)], 4)

## Método para parar um SFX Global
func stop_global(sfx_name: String) -> void: AudioManager.stop_sfx(child_nodes[child_search.find(sfx_name)])

# private
func _get_all(node:Node) -> Array: # pega todos as children e grand children de um node e joga pro child_nodes
	if node.get_child_count() == 0: return []
	var all_child : Array[Variant]
	
	for child in node.get_children():
		if child is SoundQueue or child is AudioStreamPlayer:
			all_child.append(child)
			child_search.append(child.name)
			continue
		for grand_child in _get_all(child):
			if grand_child is SoundQueue or grand_child is AudioStreamPlayer:
				all_child.append(grand_child)
				continue
	return all_child
