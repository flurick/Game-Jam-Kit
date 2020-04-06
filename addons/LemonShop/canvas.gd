tool
extends TextureRect

var image = Image.new()
var imagetexture = ImageTexture.new() #for converting to visible textures
var color = Color.pink
export var brush:Texture

var adjective = ["talking", "angry", "shaky", "deep", "sick", "zippy", "sticky", "fluffy", "frozen", "honest", "bonkers", "harsh", "sparkly", "greedy", "crawly", "twisted", "yapping", "magical", "indecent", "awful", "arrogant", "confused", "high-end", "insecure", "cool", "hairless", "metal", "wild", "domesticated", "abnormal", "cocky", "massive", "disrespectful", "impressive", "worthy", "hilarious", "hot", "tactful", "bearded", "duck-like", "violent", "slimy", "insanely", "embarrassed", "self-centere", "cold", "philosophical", "arsty"]
var noun = ["Actor","Gold","Painting","Advertisement","Grass","Parrot","Afternoon","Pencil","Airport","Guitar","Piano","Ambulance","Hair","Pillow","Animal","Hamburger","Pizza","Answer","Helicopter","Planet","Apple","Helmet","Plastic","Army","Holiday","Honey","Potato","Balloon","Horse","Queen","Banana","Hospital","Quill","Battery","House","Rain","Beach","Hydrogen","Rainbow","Beard","Ice","Raincoat","Bed","Insect","Refrigerator","Insurance","Restaurant","Boy","Iron","River","Branch","Island","Rocket","Breakfast","Jackal","Room","Brother","Jelly","Rose","Camera","Jewellery","Candle","Sandwich","Car","Juice","Caravan","Kangaroo","Scooter","Carpet","King","Shampoo","Cartoon","Kitchen","Shoe","Kite","Soccer","Knife","Spoon","Crayon","Lamp","Stone","Crowd","Lawyer","Sugar","Daughter","Leather","Library","Teacher","Lighter","Telephone","Diamond","Lion","Television","Dinner","Lizard","Tent","Lock","Doctor","Tomato","Dog","Lunch","Toothbrush","Dream","Machine","Traffic","Dress","Magazine","Train","Magician","Truck","Egg","Eggplant","Market","Umbrella","Match","Van","Elephant","Microphone","Vase","Energy","Monkey","Vegetable","Engine","Morning","Vulture","Motorcycle","Wall","Evening","Nail","Whale","Eye","Napkin","Window","Family","Needle","Wire","Nest","Xylophone","Fish","Yacht","Flag","Night","Yak","Flower","Notebook","Zebra","Football","Ocean","Zoo","Forest","Oil","Garden","Fountain","Orange","Gas","Oxygen","Girl","Furniture","Oyster","Glass","Garage","Ghost"]

func any(lst): return lst[rand_range(0,lst.size())]

func new(size=Vector2(64,64), mip=false, format=Image.FORMAT_RGBA8):
	$"../../../BottomPanel/HBoxContainer/LineEdit".text = str(any(adjective),any(noun))
	image.create(size.x,size.y, mip, format)
	imagetexture.create_from_image(image)
	texture = imagetexture
	rect_size = size
	get_parent().rect_min_size = size

func _ready():
	randomize()
	new()

var active_tool = "pen"
var eraser_radius = 6
func brush_stroke(pos):
	match active_tool:
		"pen":
			if brush:
				image.blend_rect(
					brush.get_data(), 
					Rect2(Vector2.ZERO, brush.get_size()), 
					pos-brush.get_size()*0.5
				)
		"eraser":
			
			for x in range(-eraser_radius,eraser_radius):
				for y in range(-eraser_radius,eraser_radius):
					if Rect2(Vector2.ZERO, rect_size).has_point(pos+Vector2(x,y)):
						image.set_pixelv(pos+Vector2(x,y), Color.transparent)

var is_using = false
func _gui_input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			is_using = true
		else:
			is_using = false
#			save() #saving on a couple of saves here by using on_mouse_exited instead
		
	if event is InputEventMouseMotion and is_using:
		image.lock()
		brush_stroke(event.position)
		image.unlock()
		imagetexture.create_from_image(image)
		texture = imagetexture

func save():
	var target_filename = str("res://doodles/",$"../../../BottomPanel/HBoxContainer/LineEdit".text,".png")
	var d = Directory.new()
	d.make_dir("res://doodles")
	
#	if d.file_exists(target_filename):
#		d.copy(target_filename, str(".",target_filename))
	
	var err = image.save_png(target_filename)
	if err: 
		print(err)
	else: 
		print("Saved doodle ",target_filename)
	
#	ResourceSaver.save(target_filename, image)

func _on_Button1_pressed():
	new(Vector2.ONE*64)
func _on_Button2_pressed():
	new(Vector2.ONE*256)

func _on_eraser_pressed():
	active_tool = "eraser"
func _on_pen_pressed():
	active_tool = "pen"

func _on_VBoxContainer_mouse_exited():
	save()
