extends Button

class_name InventorySlot

# lưu trữ dữ liệu
@export var Data: Object_Data



func _click() -> void:
	if (Data):
		#phat tin hieu hien thi UI
		EventSystem.inventory_slot_pressed.emit(Data)
		

func _setup(data: Object_Data) -> void:
	if not is_node_ready():
		await ready
	
	if data:
		self.show()
		print ("Thành công ", data.IDObject)
		Data = data
		icon = Data.ObjectImage
		self.pressed.connect(_on_pressed)
	else:
		self.hide()

	


func _on_pressed() -> void:
	if (Data):
		#phat tin hieu hien thi UI
		print ("Click nút ")
		EventSystem.inventory_slot_pressed.emit(Data)
