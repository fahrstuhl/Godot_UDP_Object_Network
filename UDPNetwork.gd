extends Node
## Object Dict specification:
# {
#   "origin": String,
#   "name": String,
#	"pos": { "x": int, "y": int },
#   "vel": { "x": int, "y": int },
# }
const PORT = 60607
const BROADCAST_IP = "192.168.42.255"
#const BROADCAST_IP = "127.0.0.1"
const LISTEN_IP = "0.0.0.0"
var peer
var example =  {
	"origin": "example",
	"name": "object",
	"pos": { "x": 0, "y": 0 },
	"vel": { "x": 0, "y": 0 },
 }
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal object_received

func _ready():
	peer = PacketPeerUDP.new()
	peer.set_dest_address(BROADCAST_IP, PORT)
	if (peer.listen(PORT, LISTEN_IP) != OK):
		print("error listening")

func _process(delta):
	if peer.get_available_packet_count() > 0:
		receive_packet()

func receive_packet():
	var packet = peer.get_packet()
	var json = packet.get_string_from_utf8()
	var dict = JSON.parse(json).result
	emit_signal("object_received", dict)

func send_dict(to_send):
	peer.set_dest_address(BROADCAST_IP, PORT)
	var json = JSON.print(to_send)
	var utf8 = json.to_utf8()
	peer.put_packet(utf8)
	print("sending packet: ", json)

func _on_UDPNetwork_object_received(dict):
	print(dict)
	print(typeof(dict))
	print(dict["test"])

func _on_Timer_timeout():
	send_dict(example) # replace with function body
