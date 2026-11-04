extends Control

const STARTING_CHIPS := 1000
const MIN_BET := 25
const MAX_BET := 500

var chips: int = STARTING_CHIPS
var bet: int = 50
var deck: Array = []
var player_hand: Array = []
var dealer_hand: Array = []
var round_active := false
var round_over := true

var chips_label: Label
var bet_label: Label
var dealer_cards: HBoxContainer
var player_cards: HBoxContainer
var dealer_score_label: Label
var player_score_label: Label
var status_label: Label
var deal_button: Button
var hit_button: Button
var stand_button: Button
var lower_bet_button: Button
var raise_bet_button: Button

func _ready() -> void:
	_build_table()
	_update_ui()

func _build_table() -> void:
	var background := ColorRect.new()
	background.color = Color("#104b3b")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 36)
	margin.add_theme_constant_override("margin_right", 36)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	margin.add_child(layout)

	var header := HBoxContainer.new()
	layout.add_child(header)
	var title := Label.new()
	title.text = "D20 BLACKJACK"
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("#f4e7bd"))
	header.add_child(title)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	chips_label = _make_label("CHIPS: 1000", 20, Color("#f7d978"))
	header.add_child(chips_label)

	var rule := HSeparator.new()
	layout.add_child(rule)

	var dealer_title := _make_label("DEALER", 18, Color("#f4e7bd"))
	layout.add_child(dealer_title)
	dealer_cards = HBoxContainer.new()
	dealer_cards.add_theme_constant_override("separation", 10)
	layout.add_child(dealer_cards)
	dealer_score_label = _make_label("", 16, Color.WHITE)
	layout.add_child(dealer_score_label)

	var middle := Control.new()
	middle.custom_minimum_size.y = 8
	layout.add_child(middle)

	var player_title := _make_label("YOUR HAND", 18, Color("#f4e7bd"))
	layout.add_child(player_title)
	player_cards = HBoxContainer.new()
	player_cards.add_theme_constant_override("separation", 10)
	layout.add_child(player_cards)
	player_score_label = _make_label("", 16, Color.WHITE)
	layout.add_child(player_score_label)

	var filler := Control.new()
	filler.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(filler)

	status_label = _make_label("Welcome! Place your bet and deal.", 18, Color("#fff2c6"))
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(status_label)

	var betting := HBoxContainer.new()
	betting.alignment = BoxContainer.ALIGNMENT_CENTER
	betting.add_theme_constant_override("separation", 12)
	layout.add_child(betting)
	lower_bet_button = _make_button("− BET")
	lower_bet_button.pressed.connect(_change_bet.bind(-25))
	betting.add_child(lower_bet_button)
	bet_label = _make_label("BET: 50", 18, Color("#f7d978"))
	betting.add_child(bet_label)
	raise_bet_button = _make_button("+ BET")
	raise_bet_button.pressed.connect(_change_bet.bind(25))
	betting.add_child(raise_bet_button)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 12)
	layout.add_child(actions)
	deal_button = _make_button("DEAL")
	deal_button.pressed.connect(_deal)
	actions.add_child(deal_button)
	hit_button = _make_button("HIT")
	hit_button.pressed.connect(_hit)
	actions.add_child(hit_button)
	stand_button = _make_button("STAND")
	stand_button.pressed.connect(_stand)
	actions.add_child(stand_button)

	var footer := _make_label("21 wins • Dealer stands on 17 • Blackjack pays 3:2 • Play chips only", 12, Color("#b9d6c9"))
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(footer)

func _make_label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _make_button(value: String) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(120, 46)
	button.add_theme_font_size_override("font_size", 16)
	return button

func _change_bet(amount: int) -> void:
	if round_active:
		return
	bet = clampi(bet + amount, MIN_BET, min(MAX_BET, chips))
	_update_ui()

func _deal() -> void:
	if round_active:
		return
	if chips < MIN_BET:
		status_label.text = "You're out of chips. Reset the game to play again."
		return
	bet = clampi(bet, MIN_BET, min(MAX_BET, chips))
	chips -= bet
	deck.clear()
	for suit in ["♠", "♥", "♦", "♣"]:
		for rank in ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]:
			deck.append({"rank": rank, "suit": suit})
	deck.shuffle()
	player_hand = [_draw_card(), _draw_card()]
	dealer_hand = [_draw_card(), _draw_card()]
	round_active = true
	round_over = false
	status_label.text = "Your move: hit or stand."
	if _hand_value(player_hand) == 21:
		_finish_player_blackjack()
	_update_ui()

func _draw_card() -> Dictionary:
	if deck.is_empty():
		return {"rank": "A", "suit": "♠"}
	return deck.pop_back()

func _hit() -> void:
	if not round_active:
		return
	player_hand.append(_draw_card())
	if _hand_value(player_hand) > 21:
		_end_round("Bust! Dealer wins.")
	elif _hand_value(player_hand) == 21:
		_stand()
	else:
		status_label.text = "You have %d. Hit or stand?" % _hand_value(player_hand)
	_update_ui()

func _stand() -> void:
	if not round_active:
		return
	while _hand_value(dealer_hand) < 17:
		dealer_hand.append(_draw_card())
	var player_total := _hand_value(player_hand)
	var dealer_total := _hand_value(dealer_hand)
	if dealer_total > 21:
		_win_bet(2.0, "Dealer busts! You win.")
	elif player_total > dealer_total:
		_win_bet(2.0, "You win!")
	elif player_total < dealer_total:
		_end_round("Dealer wins.")
	else:
		_win_bet(1.0, "Push — your bet is returned.")

func _finish_player_blackjack() -> void:
	if _hand_value(dealer_hand) == 21:
		_win_bet(1.0, "Both have blackjack — push.")
	else:
		_win_bet(2.5, "BLACKJACK! You win 3:2.")

func _win_bet(return_multiplier: float, message: String) -> void:
	chips += int(round(float(bet) * return_multiplier))
	_end_round(message)

func _end_round(message: String) -> void:
	round_active = false
	round_over = true
	status_label.text = message + " Deal again when ready."
	_update_ui()

func _hand_value(hand: Array) -> int:
	var total := 0
	var aces := 0
	for card in hand:
		var rank: String = card["rank"]
		if rank == "A":
			total += 11
			aces += 1
		elif rank in ["K", "Q", "J"]:
			total += 10
		else:
			total += int(rank)
	while total > 21 and aces > 0:
		total -= 10
		aces -= 1
	return total

func _update_ui() -> void:
	if not is_node_ready() or chips_label == null:
		return
	chips_label.text = "CHIPS: %d" % chips
	bet_label.text = "BET: %d" % bet
	lower_bet_button.disabled = round_active or bet <= MIN_BET
	raise_bet_button.disabled = round_active or bet >= min(MAX_BET, chips)
	deal_button.disabled = round_active or chips < MIN_BET
	hit_button.disabled = not round_active
	stand_button.disabled = not round_active
	_render_hand(player_cards, player_hand, false)
	_render_hand(dealer_cards, dealer_hand, round_active)
	player_score_label.text = "Total: %d" % _hand_value(player_hand) if not player_hand.is_empty() else ""
	if dealer_hand.is_empty():
		dealer_score_label.text = ""
	elif round_active:
		dealer_score_label.text = "Showing: %d" % _hand_value([dealer_hand[0]])
	else:
		dealer_score_label.text = "Total: %d" % _hand_value(dealer_hand)

func _render_hand(container: HBoxContainer, hand: Array, hide_second: bool) -> void:
	for child in container.get_children():
		child.queue_free()
	for index in range(hand.size()):
		var card: Dictionary = hand[index]
		var face_down := hide_second and index == 1
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(76, 104)
		var style := StyleBoxFlat.new()
		style.bg_color = Color("#173f36") if face_down else Color("#fffdf4")
		style.set_corner_radius_all(8)
		style.set_border_width_all(2)
		style.border_color = Color("#d7bd78")
		panel.add_theme_stylebox_override("panel", style)
		container.add_child(panel)
		var face := Label.new()
		face.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		face.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		face.add_theme_font_size_override("font_size", 25)
		if face_down:
			face.text = "D20"
			face.add_theme_color_override("font_color", Color("#f7d978"))
		else:
			face.text = "%s\n%s" % [card["rank"], card["suit"]]
			var red_suit: bool = card["suit"] in ["♥", "♦"]
			face.add_theme_color_override("font_color", Color("#c43c45") if red_suit else Color("#202b28"))
		panel.add_child(face)
