extends Sprite

var object_type = "example_object"
var velocity = Vector2(100,100)
var window_size = OS.get_screen_size()

func _process(delta):
	position += velocity * delta
	if position.x >= window_size.x or position.x <= 0:
		velocity.x *= -1
	if position.y >= window_size.y or position.y <= 0:
		velocity.y *= -1