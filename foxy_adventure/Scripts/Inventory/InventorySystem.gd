extends Node

# tạo một Dictionary lưu trữ các Object 
@export var ListObject = {} 

func AddInventory(data: Object_Data):	
	ListObject[data.IDObject] = data

func RemoveInventoryByData(data: Object_Data) -> bool:
	if data == null:
		return false
		
	if ListObject.has(data.IDObject):
		ListObject.erase(data.IDObject)
		print("InventorySystem: Đã xóa vật phẩm: ", data.ObjectName)
		return true
	else:
		push_warning("InventorySystem: Không tìm thấy vật phẩm này để xóa: ", data.ObjectName)
		return false

func CheckObjectInInventory(id: int) -> bool:
	if ListObject.has(id):
		return true
	else:
		return false
		
		
func GetObject(id: int) -> Object_Data:
	if ListObject.has(id):
		return ListObject[id]
	else:
		return null
		
func get_all_items() -> Array:
	return ListObject.values()
	
