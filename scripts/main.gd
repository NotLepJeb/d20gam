extends Control

const CARD_ROOT := "res://assets/sprites/cards/"
const FONT_PATH := "res://assets/fonts/RetroSans.ttf"
const COLUMNS := 7
const CARD_SIZE := Vector2(112, 158)

var page: VBoxContainer
var status_label: Label

func _ready() -> void:
	_build_gallery()
	_load_gallery()

func _build_gallery() -> void:
	var background := ColorRect.new()
	background.color = Color("#102d27")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 10)
	margin.add_child(layout)

	var heading := Label.new()
	heading.text = "D20 CARD COLLECTION"
	heading.add_theme_font_size_override("font_size", 28)
	heading.add_theme_color_override("font_color", Color("#f6e8c1"))
	if ResourceLoader.exists(FONT_PATH):
		heading.add_theme_font_override("font", load(FONT_PATH))
	layout.add_child(heading)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 14)
	status_label.add_theme_color_override("font_color", Color("#d6e5dc"))
	layout.add_child(status_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	page = VBoxContainer.new()
	page.add_theme_constant_override("separation", 18)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(page)

func _load_gallery() -> void:
	var sections: Array[Dictionary] = [
		{"title": "CARD BACKS", "paths": _numbered_paths("Backs", "back_", 0, 8)},
		{"title": "CLUBS", "paths": _numbered_paths("Clubs", "Clubs_card_", 1, 13)},
		{"title": "DIAMONDS", "paths": _numbered_paths("Diamonds", "Diamonds_card_", 1, 13)},
		{"title": "HEARTS", "paths": _numbered_paths("Hearts", "Hearts_card_", 1, 13)},
		{"title": "SPADES", "paths": _numbered_paths("Spades", "Spades_card_", 1, 13)},
		{"title": "JOKERS", "paths": ["Joker/joker_black.png", "Joker/joker_red.png"]}
	]
	var total := 0
	var loaded := 0
	for section in sections:
		var title := Label.new()
		title.text = section["title"]
		title.add_theme_font_size_override("font_size", 18)
		title.add_theme_color_override("font_color", Color("#f2d58a"))
		page.add_child(title)

		var grid := GridContainer.new()
		grid.columns = COLUMNS
		grid.add_theme_constant_override("h_separation", 14)
		grid.add_theme_constant_override("v_separation", 18)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		page.add_child(grid)

		for relative_path in section["paths"]:
			total += 1
			var full_path: String = CARD_ROOT + relative_path
			if ResourceLoader.exists(full_path):
				_add_card(grid, full_path, relative_path.get_file().get_basename())
				loaded += 1
			else:
				_add_missing_card(grid, relative_path)

	status_label.text = "%d of %d card images loaded • %d columns" % [loaded, total, COLUMNS]
	if loaded == 0:
		status_label.text += " • Add the supplied PNGs under assets/sprites/cards/ to show the artwork."

func _numbered_paths(folder: String, prefix: String, first: int, last: int) -> Array[String]:
	var paths: Array[String] = []
	for number in range(first, last + 1):
		var filename := "%s%d.png" % [prefix, number] if first == 0 else "%s%02d.png" % [prefix, number]
		paths.append("%s/%s" % [folder, filename])
	return paths

func _add_card(grid: GridContainer, path: String, card_name: String) -> void:
	var item := VBoxContainer.new()
	item.custom_minimum_size = Vector2(CARD_SIZE.x, CARD_SIZE.y + 24)
	item.add_theme_constant_override("separation", 4)

	var image := TextureRect.new()
	image.custom_minimum_size = CARD_SIZE
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.texture = load(path)
	item.add_child(image)

	var caption := Label.new()
	caption.text = card_name.replace("_", " ")
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 11)
	caption.add_theme_color_override("font_color", Color("#f1eee3"))
	caption.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	item.add_child(caption)
	grid.add_child(item)

func _add_missing_card(grid: GridContainer, path: String) -> void:
	var placeholder := PanelContainer.new()
	placeholder.custom_minimum_size = CARD_SIZE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1d4038")
	style.border_color = Color("#c5a85c")
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	placeholder.add_theme_stylebox_override("panel", style)

	var label := Label.new()
	label.text = "MISSING\n" + path.get_file()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color("#f2d58a"))
	placeholder.add_child(label)
	grid.add_child(placeholder)
