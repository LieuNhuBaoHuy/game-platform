extends Node

# tạo một Dictionary lưu trữ các Object 
@export var ListObject = {} 

func AddInventory(data: Object_Data):	
	ListObject[data.IDObject] = data
	

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
		
