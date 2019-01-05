extends Node
## Object Dict specification:
# {
#   "origin": String,
#   "name": String,
#	"pos": { "x": int, "y": int },
#   "vel": { "x": int, "y": int },
# }
export(bool) var debug_print = true
const PORT = 60607
#const BROADCAST_IP = "192.168.42.255" # home network broadcast
const BROADCAST_IP = "127.0.0.1" # localhost
#const BROADCAST_IP = "255.255.255.255" # broadcast everywhere, doesn't work in Godot 3.0: https://github.com/godotengine/godot/issues/20216
const LISTEN_IP = "0.0.0.0"
var peer
var example =  {
	"origin": "example",
	"name": "object",
	"pos": { "x": 0, "y": 0 },
	"vel": { "x": 0, "y": 0 },
 }

signal object_received

func _ready():
	peer = PacketPeerUDP.new()
	if (peer.set_dest_address(BROADCAST_IP, PORT) != OK):
		if (debug_print):
			print("error setting destination")
	if (peer.listen(PORT, LISTEN_IP) != OK):
		if (debug_print):
			print("error listening")

func _process(delta):
	if peer.get_available_packet_count() > 0:
		receive_packet()

func receive_packet():
	var packet = peer.get_packet()
	var json = packet.get_string_from_utf8()
	var dict = JSON.parse(json).result
	if (debug_print):
		print("packet received: ", dict)
	emit_signal("object_received", dict)

func send_dict(to_send):
	peer.set_dest_address(BROADCAST_IP, PORT)
	var json = JSON.print(to_send)
	var utf8 = json.to_utf8()
	if (peer.put_packet(utf8) != OK):
		if (debug_print):
			print("sending packet failed")
	else:
		if (debug_print):
			print("sending packet: ", json)