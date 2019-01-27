extends Node2D

var example = preload("res://ExampleObject.tscn")
var window_size = OS.get_screen_size()

## example function how to receive an object and add it to your tree
func _on_UDPNetwork_object_received(dict):
	var obj = example.instance()
	obj.object_type = dict["name"]
	obj.global_position = relative_to_absolute(dict["position"])
	obj.velocity = Vector2(dict["velocity"]["x"],dict["velocity"]["y"])
	obj.velocity *= -1
	add_child(obj)

## example function how to convert an object
func convert_object(obj):
	var dict = {
		"origin": "sender_name",
		"name": obj.object_type,
		"position": absolute_to_relative(obj.global_position),
		"velocity": {"x": obj.velocity.x, "y": obj.velocity.y},
		}
	return dict

func relative_to_absolute(position):
	return Vector2(position["x"]*window_size.x, position["y"]*window_size.y)

func absolute_to_relative(position):
	return {"x": position.x/window_size.x, "y": position.y/window_size.y}

## example function how to send an object
func _on_Timer_timeout():
	var dict = convert_object($ExampleObject)
	$UDPNetwork.send_dict(dict)
