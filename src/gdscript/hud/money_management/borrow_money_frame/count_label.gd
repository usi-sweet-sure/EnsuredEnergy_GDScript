extends Label


func _ready() -> void:
	MoneyManager.import_count_updated.connect(_on_import_count_updated)
	
	
func _on_import_count_updated(count: int, authorized: int):
	text = str(count) + " / " + str(authorized)
