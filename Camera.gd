extends Camera

onready var j = get_node("../Player")
onready var dist = j.translation.z - translation.z

func _process(_delta):
	translation.z = j.translation.z - dist
