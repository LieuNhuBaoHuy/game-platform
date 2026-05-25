extends Node2D

class_name UI_MyMap_Controller
static var instance: UI_MyMap_Controller

#Declare 
@export var InventoryPanel: CanvasLayer

func _enter_tree() -> void:
	# Cấp quyền giám đốc UI khi Map được load
	if instance == null:
		instance = self
	else:
		push_warning("Cảnh báo: Phát hiện 2 cái UIController trong cùng một Scene!")

func _exit_tree() -> void:
	# Từ chức khi chuyển Map
	if instance == self:
		instance = null
		
		
func _showInventoryPanel(state: bool):
	if state:
		InventoryPanel.show()
	else:
		InventoryPanel.hide()
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenBag"):
		_showInventoryPanel(true)
		get_tree().paused = true
	else: if event.is_action_pressed("CloseBag"):
		_showInventoryPanel(false)
		get_tree().paused = false
