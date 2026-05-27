extends Node2D

class_name UI_MyMap_Controller
static var instance: UI_MyMap_Controller

#Declare 
@export var InventoryPanel: CanvasLayer
@export var ObjectName: Label
@export var ObjectAva: TextureRect
@export var ObjectDes: Label
@export var UseButton: Button
@export var InventoryParent: TextureRect #chua cac nut bam

func _ready() -> void:
	# BẮT TÍN HIỆU: Đăng ký lắng nghe sự kiện (Tương đương EventSystem.inventory_slot_pressed += OpenUI bên Unity)
	EventSystem.inventory_slot_pressed.connect(_on_inventory_slot_pressed)
	
	# test
	InventorySystem.AddInventory(InitializeScene.get_item_by_id(KeyData.Coconut))

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
	if EventSystem.inventory_slot_pressed.is_connected(_on_inventory_slot_pressed):
		EventSystem.inventory_slot_pressed.disconnect(_on_inventory_slot_pressed)
		
		
func _showInventoryPanel(state: bool):
	if state:
		InventoryPanel.show()
	else:
		InventoryPanel.hide()
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenBag"):
		_showInventoryPanel(true)
		reset_object_detail()
		load_inventory_to_ui()
		get_tree().paused = true
	else: if event.is_action_pressed("CloseBag"):
		_showInventoryPanel(false)
		get_tree().paused = false
		

func _on_inventory_slot_pressed(data: Object_Data) -> void:
	#hien thi UI 
	if (data.CanBeUse):
		UseButton.show()
	ObjectName.text = data.ObjectName
	ObjectDes.text = data.ObjectDescription
	ObjectAva.texture = data.ObjectImage
	# truyen nut bam vao day 
	UseButton.pressed.connect(func(): UseButton_Click(data))
	pass
	
	
func reset_object_detail() -> void:
	ObjectName.text = ""
	ObjectAva.texture = null
	ObjectDes.text = ""	
	UseButton.hide()

func load_inventory_to_ui() -> void:
# lay danh sach vat pham
	var all_items = InventorySystem.get_all_items()
	
	print ("Danh sách vật phẩm: " , all_items.size())

	var ui_slots = InventoryParent.get_children()
	
	for i in range(ui_slots.size()):
		var slot_node = ui_slots[i]

		var real_button = slot_node.get_node_or_null("Frame/Button")

		if real_button is InventorySlot:
			print("-> Đã tìm thấy nút thành công tại ô số: ", i) # <--- THÊM DÒNG NÀY ĐỂ KIỂM TRA
			if i < all_items.size():
				var item_data = all_items[i] as Object_Data
				real_button._setup(item_data)
				print ("Vật phẩm tại ô này là: ", item_data.IDObject)
			else:
				print("Không có vật phẩm")
				real_button._setup(null)

func UseButton_Click(data: Object_Data) -> void:
	if (data):
		data._use(Game_MyMap_Controller.instance.player_instance)
		# dung xong thi xoa vat the 
		InventorySystem.RemoveInventoryByData(data)
		reset_object_detail()
		load_inventory_to_ui()
		
