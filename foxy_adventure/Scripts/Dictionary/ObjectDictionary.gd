extends Node


# Mảng này sẽ hiện ngoài Inspector để bạn kéo thả các file .tres vào
@export var item_resources: Array[Object_Data] = []

# Dictionary dùng để tra cứu bằng ID (chạy ngầm)
var database = {}

func _ready() -> void:
	# Khi game vừa khởi động, tự động nạp mảng kéo thả vào Dictionary
	build_database()

func build_database() -> void:
	database.clear()
	for item in item_resources:
		if item != null:
			# Lấy IDObject trong Resource làm Key, và chính cục Resource làm Value
			database[item.IDObject] = item
			print("Id vật phẩm: ", item.IDObject )
	print("ItemDatabase: Đã nạp thành công ", database.size(), " vật phẩm vào kho!")

# HÀM TRA CỨU: Nhập IDObject trả về Object_Data
func get_item_by_id(id: int) -> Object_Data:
	if database.has(id):
		return database[id]
	else:
		push_warning("ItemDatabase: Không tìm thấy vật phẩm có ID = ", id)
		return null
