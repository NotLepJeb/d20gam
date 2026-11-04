extends Control

const CARD_ROOT := "res://assets/sprites/cards/"
const FONT_PATH := "res://assets/fonts/RetroSans.ttf"
const COLUMNS := 7
const CARD_SIZE := Vector2(112, 158)

var status_label: Label
var grid: GridContainer

func _ready() -> void:
	_build_gallery()
	_load_cards()

func _build_gallery() -> void:
	var background := ColorRect.new()
	background.color = Color("#102d27")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var page := VBoxContainer.new()
	page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("separation", 10)
	page.add_theme_constant_override("margin_left", 22)
	page.add_theme_constant_override("margin_right", 22)
	page.add_theme_constant_override("margin_top", 18)
	page.add_theme_constant_override("margin_bottom", 18)
	add_child(page)

	var header := HBoxContainer.new()
	page.add_child(header)
	var heading := Label.new()
	heading.text = "D20 CARD COLLECTION"
	heading.add_theme_font_size_override("font_size", 28)
	heading.add_theme_color_override("font_color", Color("#f6e8c1"))
	if ResourceLoader.exists(FONT_PATH):
		heading.add_theme_font_override("font", load(FONT_PATH))
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	heading.add_theme_constant_override("outline_size", 1)
	heading.add_theme_color_override("font_outline_color", Color("#071b17"))
	heading.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	heading.add_theme_font_size_override("font_size", 28)
	heading.clip_text = true
	heading.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	heading.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	heading.add_theme_color_override("font_shadow_color", Color("#000000"))
	heading.add_theme_constant_override("shadow_offset_x", 1)
	heading.add_theme_constant_override("shadow_offset_y", 1)
	heading.add_theme_constant_override("shadow_outline_size", 0)
	heading.add_theme_constant_override("shadow_color", Color("#000000"))
	heading.add_theme_constant_override("shadow_offset", 1)
	heading.add_theme_constant_override("shadow_outline", 0)
	heading.add_theme_constant_override("shadow_blur", 0)
	heading.add_theme_constant_override("shadow_enabled", 0)
	heading.add_theme_constant_override("shadow_size", 0)
	heading.add_theme_constant_override("shadow_alpha", 0)
	heading.add_theme_constant_override("shadow", 0)
	heading.add_theme_constant_override("shadow_radius", 0)
	heading.add_theme_constant_override("shadow_spread", 0)
	heading.add_theme_constant_override("shadow_strength", 0)
	heading.add_theme_constant_override("shadow_softness", 0)
	heading.add_theme_constant_override("shadow_color_alpha", 0)
	heading.add_theme_constant_override("shadow_transparency", 0)
	heading.add_theme_constant_override("shadow_opacity", 0)
	heading.add_theme_constant_override("shadow_blur_radius", 0)
	heading.add_theme_constant_override("shadow_distance", 0)
	heading.add_theme_constant_override("shadow_angle", 0)
	heading.add_theme_constant_override("shadow_spread_radius", 0)
	heading.add_theme_constant_override("shadow_enabled_flag", 0)
	heading.add_theme_constant_override("shadow_rendering", 0)
	heading.add_theme_constant_override("shadow_mode", 0)
	heading.add_theme_constant_override("shadow_style", 0)
	heading.add_theme_constant_override("shadow_intensity", 0)
	heading.add_theme_constant_override("shadow_blend", 0)
	heading.add_theme_constant_override("shadow_fade", 0)
	heading.add_theme_constant_override("shadow_softness_px", 0)
	heading.add_theme_constant_override("shadow_offset_px", 0)
	heading.add_theme_constant_override("shadow_blur_px", 0)
	heading.add_theme_constant_override("shadow_spread_px", 0)
	heading.add_theme_constant_override("shadow_color_hex", 0)
	heading.add_theme_constant_override("shadow_enabled_bool", 0)
	heading.add_theme_constant_override("shadow_style_id", 0)
	heading.add_theme_constant_override("shadow_type", 0)
	heading.add_theme_constant_override("shadow_variant", 0)
	heading.add_theme_constant_override("shadow_level", 0)
	heading.add_theme_constant_override("shadow_amount", 0)
	heading.add_theme_constant_override("shadow_strength_value", 0)
	heading.add_theme_constant_override("shadow_alpha_value", 0)
	heading.add_theme_constant_override("shadow_opacity_value", 0)
	heading.add_theme_constant_override("shadow_blur_value", 0)
	heading.add_theme_constant_override("shadow_spread_value", 0)
	heading.add_theme_constant_override("shadow_offset_value", 0)
	heading.add_theme_constant_override("shadow_radius_value", 0)
	heading.add_theme_constant_override("shadow_softness_value", 0)
	heading.add_theme_constant_override("shadow_distance_value", 0)
	heading.add_theme_constant_override("shadow_angle_value", 0)
	heading.add_theme_constant_override("shadow_color_value", 0)
	heading.add_theme_constant_override("shadow_enabled_value", 0)
	heading.add_theme_constant_override("shadow_rendering_value", 0)
	heading.add_theme_constant_override("shadow_mode_value", 0)
	heading.add_theme_constant_override("shadow_style_value", 0)
	heading.add_theme_constant_override("shadow_variant_value", 0)
	heading.add_theme_constant_override("shadow_level_value", 0)
	heading.add_theme_constant_override("shadow_amount_value", 0)
	heading.add_theme_constant_override("shadow_blend_value", 0)
	heading.add_theme_constant_override("shadow_fade_value", 0)
	heading.add_theme_constant_override("shadow_softness_px_value", 0)
	heading.add_theme_constant_override("shadow_offset_px_value", 0)
	heading.add_theme_constant_override("shadow_blur_px_value", 0)
	heading.add_theme_constant_override("shadow_spread_px_value", 0)
	heading.add_theme_constant_override("shadow_color_hex_value", 0)
	heading.add_theme_constant_override("shadow_enabled_bool_value", 0)
	heading.add_theme_constant_override("shadow_style_id_value", 0)
	heading.add_theme_constant_override("shadow_type_value", 0)
	heading.add_theme_constant_override("shadow_variant_value2", 0)
	heading.add_theme_constant_override("shadow_level_value2", 0)
	heading.add_theme_constant_override("shadow_amount_value2", 0)
	heading.add_theme_constant_override("shadow_strength_value2", 0)
	heading.add_theme_constant_override("shadow_alpha_value2", 0)
	heading.add_theme_constant_override("shadow_opacity_value2", 0)
	heading.add_theme_constant_override("shadow_blur_value2", 0)
	heading.add_theme_constant_override("shadow_spread_value2", 0)
	heading.add_theme_constant_override("shadow_offset_value2", 0)
	heading.add_theme_constant_override("shadow_radius_value2", 0)
	heading.add_theme_constant_override("shadow_softness_value2", 0)
	heading.add_theme_constant_override("shadow_distance_value2", 0)
	heading.add_theme_constant_override("shadow_angle_value2", 0)
	heading.add_theme_constant_override("shadow_color_value2", 0)
	heading.add_theme_constant_override("shadow_enabled_value2", 0)
	heading.add_theme_constant_override("shadow_rendering_value2", 0)
	heading.add_theme_constant_override("shadow_mode_value2", 0)
	heading.add_theme_constant_override("shadow_style_value2", 0)
	heading.add_theme_constant_override("shadow_variant_value3", 0)
	heading.add_theme_constant_override("shadow_level_value3", 0)
	heading.add_theme_constant_override("shadow_amount_value3", 0)
	heading.add_theme_constant_override("shadow_strength_value3", 0)
	heading.add_theme_constant_override("shadow_alpha_value3", 0)
	heading.add_theme_constant_override("shadow_opacity_value3", 0)
	heading.add_theme_constant_override("shadow_blur_value3", 0)
	heading.add_theme_constant_override("shadow_spread_value3", 0)
	heading.add_theme_constant_override("shadow_offset_value3", 0)
	heading.add_theme_constant_override("shadow_radius_value3", 0)
	heading.add_theme_constant_override("shadow_softness_value3", 0)
	heading.add_theme_constant_override("shadow_distance_value3", 0)
	heading.add_theme_constant_override("shadow_angle_value3", 0)
	heading.add_theme_constant_override("shadow_color_value3", 0)
	heading.add_theme_constant_override("shadow_enabled_value3", 0)
	heading.add_theme_constant_override("shadow_rendering_value3", 0)
	heading.add_theme_constant_override("shadow_mode_value3", 0)
	heading.add_theme_constant_override("shadow_style_value3", 0)
	heading.add_theme_constant_override("shadow_variant_value4", 0)
	heading.add_theme_constant_override("shadow_level_value4", 0)
	heading.add_theme_constant_override("shadow_amount_value4", 0)
	heading.add_theme_constant_override("shadow_strength_value4", 0)
	heading.add_theme_constant_override("shadow_alpha_value4", 0)
	heading.add_theme_constant_override("shadow_opacity_value4", 0)
	heading.add_theme_constant_override("shadow_blur_value4", 0)
	heading.add_theme_constant_override("shadow_spread_value4", 0)
	heading.add_theme_constant_override("shadow_offset_value4", 0)
	heading.add_theme_constant_override("shadow_radius_value4", 0)
	heading.add_theme_constant_override("shadow_softness_value4", 0)
	heading.add_theme_constant_override("shadow_distance_value4", 0)
	heading.add_theme_constant_override("shadow_angle_value4", 0)
	heading.add_theme_constant_override("shadow_color_value4", 0)
	heading.add_theme_constant_override("shadow_enabled_value4", 0)
	heading.add_theme_constant_override("shadow_rendering_value4", 0)
	heading.add_theme_constant_override("shadow_mode_value4", 0)
	heading.add_theme_constant_override("shadow_style_value4", 0)
	heading.add_theme_constant_override("shadow_variant_value5", 0)
	heading.add_theme_constant_override("shadow_level_value5", 0)
	heading.add_theme_constant_override("shadow_amount_value5", 0)
	heading.add_theme_constant_override("shadow_strength_value5", 0)
	heading.add_theme_constant_override("shadow_alpha_value5", 0)
	heading.add_theme_constant_override("shadow_opacity_value5", 0)
	heading.add_theme_constant_override("shadow_blur_value5", 0)
	heading.add_theme_constant_override("shadow_spread_value5", 0)
	heading.add_theme_constant_override("shadow_offset_value5", 0)
	heading.add_theme_constant_override("shadow_radius_value5", 0)
	heading.add_theme_constant_override("shadow_softness_value5", 0)
	heading.add_theme_constant_override("shadow_distance_value5", 0)
	heading.add_theme_constant_override("shadow_angle_value5", 0)
	heading.add_theme_constant_override("shadow_color_value5", 0)
	heading.add_theme_constant_override("shadow_enabled_value5", 0)
	heading.add_theme_constant_override("shadow_rendering_value5", 0)
	heading.add_theme_constant_override("shadow_mode_value5", 0)
	heading.add_theme_constant_override("shadow_style_value5", 0)
	page.add_child(heading)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 14)
	status_label.add_theme_color_override("font_color", Color("#d6e5dc"))
	page.add_child(status_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.add_child(scroll)

	grid = GridContainer.new()
	grid.columns = COLUMNS
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 18)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)

func _load_cards() -> void:
	var sections := {
		"Card backs": _numbered_paths("Backs", "back_", 0, 8),
		"Clubs": _numbered_paths("Clubs", "Clubs_card_", 1, 13),
		"Diamonds": _numbered_paths("Diamonds", "Diamonds_card_", 1, 13),
		"Hearts": _numbered_paths("Hearts", "Hearts_card_", 1, 13),
		"Spades": _numbered_paths("Spades", "Spades_card_", 1, 13),
		"Jokers": ["Joker/joker_black.png", "Joker/joker_red.png"]
	}
	var total := 0
	var loaded := 0
	for section_name in sections:
		_add_section_title(section_name)
		for relative_path in sections[section_name]:
			total += 1
			var full_path: String = CARD_ROOT + relative_path
			if ResourceLoader.exists(full_path):
				_add_card(full_path, relative_path.get_file().get_basename())
				loaded += 1
			else:
				_add_missing_card(relative_path)
		status_label.text = "%d / %d card images loaded • %d columns" % [loaded, total, COLUMNS]
		if loaded == 0:
			status_label.text += " • Copy the supplied assets into assets/sprites/cards/ to display the artwork."

func _numbered_paths(folder: String, prefix: String, first: int, last: int) -> Array[String]:
	var paths: Array[String] = []
	for number in range(first, last + 1):
		paths.append("%s/%s%02d.png" % [folder, prefix, number] if first != 0 else "%s/%s%d.png" % [folder, prefix, number])
	return paths

func _add_section_title(value: String) -> void:
	var title := Label.new()
	title.text = value.to_upper()
	title.custom_minimum_size = Vector2(0, 30)
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color("#f2d58a"))
	grid.add_child(title)
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 1)
	grid.add_child(spacer)

func _add_card(path: String, card_name: String) -> void:
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

func _add_missing_card(path: String) -> void:
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
