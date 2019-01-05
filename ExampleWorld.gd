extends Node2D

var example = preload("res://ExampleObject.tscn")

## example function how to receive an object and add it to your tree
func _on_UDPNetwork_object_received(dict):
	var obj = example.instance()
	obj.object_type = dict["name"]
	obj.position = Vector2(dict["pos"]["x"],dict["pos"]["y"])
	obj.velocity = Vector2(dict["vel"]["x"],dict["vel"]["y"])
	obj.velocity *= -1
	add_child(obj)

## example function how to convert an object
func convert_object(obj):
	var dict = {
		"origin": "sender_name",
		"name": obj.object_type,
		"pos": {"x": obj.position.x, "y": obj.position.y},
		"vel": {"x": obj.velocity.x, "y": obj.velocity.y},
		}
	return dict

## example function how to send an object
func _on_Timer_timeout():
	var dict = convert_object($ExampleObject)
	$UDPNetwork.send_dict(dict)