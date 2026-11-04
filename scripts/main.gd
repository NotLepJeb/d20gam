extends Control

const CARD_ROOT := "res://assets/sprites/cards/"
const BACK_PATH := CARD_ROOT + "Backs/back_0.png"
const CARD_SIZE := Vector2(116, 164)
const STARTING_BANKROLL := 1000
const BASE_BET := 50

var rng := RandomNumberGenerator.new()
var deck: Array[Dictionary] = []
var player_hands: Array = []
var hand_bets: Array[int] = []
var dealer_hand: Array[Dictionary] = []
var active_hand := 0
var bankroll := STARTING_BANKROLL
var round_over := true
var dealer_hidden := true
var natural_blackjack := false
var status_text := "Place your bet and deal."
var status_label: Label
var bankroll_label: Label
var bet_label: Label
var dealer_cards: HBoxContainer
var player_hands_row: HBoxContainer
var action_buttons: Dictionary = {}
var deal_button: Button
var bet_amount := BASE_BET

func _ready() -> void:
	rng.randomize()
	_build_table()
	_start_round()

func _build_table() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#09271f")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color("#103c2e")
	glow.anchor_left = 0.08
	glow.anchor_top = 0.08
	glow.anchor_right = 0.92
	glow.anchor_bottom = 0.92
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(glow)
	var glow_style := StyleBoxFlat.new()
	glow_style.bg_color = Color("#103c2e")
	glow_style.border_color = Color("#b9974b")
	glow_style.set_border_width_all(2)
	glow_style.set_corner_radius_all(28)
	glow.add_theme_stylebox_override("panel", glow_style)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 42)
	margin.add_theme_constant_override("margin_right", 42)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)

	var main := VBoxContainer.new()
	main.add_theme_constant_override("separation", 12)
	margin.add_child(main)

	var header := HBoxContainer.new()
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	main.add_child(header)
	var title := Label.new()
	title.text = "D20  •  BLACKJACK"
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("#f4dfaa"))
	header.add_child(title)

	var stats := HBoxContainer.new()
	stats.alignment = BoxContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("separation", 28)
	main.add_child(stats)
	bankroll_label = _make_label("BANKROLL  $%d" % bankroll, 16, Color("#f3e9cc"))
	bet_label = _make_label("BET  $%d" % bet_amount, 16, Color("#e5c477"))
	stats.add_child(bankroll_label)
	stats.add_child(bet_label)

	var dealer_title := _make_label("DEALER", 18, Color("#d7c18c"))
	dealer_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main.add_child(dealer_title)
	var dealer_center := CenterContainer.new()
	dealer_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.add_child(dealer_center)
	dealer_cards = HBoxContainer.new()
	dealer_cards.alignment = BoxContainer.ALIGNMENT_CENTER
	dealer_cards.add_theme_constant_override("separation", 12)
	dealer_center.add_child(dealer_cards)

	status_label = _make_label(status_text, 17, Color("#fff1cf"))
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	main.add_child(status_label)

	var player_title := _make_label("YOUR HAND", 18, Color("#d7c18c"))
	player_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main.add_child(player_title)
	var player_center := CenterContainer.new()
	player_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.add_child(player_center)
	player_hands_row = HBoxContainer.new()
	player_hands_row.alignment = BoxContainer.ALIGNMENT_CENTER
	player_hands_row.add_theme_constant_override("separation", 34)
	player_center.add_child(player_hands_row)

	var controls := HBoxContainer.new()
	controls.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_theme_constant_override("separation", 12)
	main.add_child(controls)

	deal_button = _make_button("DEAL", _on_deal_pressed)
	controls.add_child(deal_button)
	_add_action_button(controls, "HIT", _on_hit_pressed)
	_add_action_button(controls, "STAND", _on_stand_pressed)
	_add_action_button(controls, "DOUBLE", _on_double_pressed)
	_add_action_button(controls, "SPLIT", _on_split_pressed)

	var footer := _make_label("A = 1 or 11   •   Dealer stands on 17   •   Blackjack pays 3:2", 12, Color("#9bb6a6"))
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main.add_child(footer)

func _make_label(value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func _make_button(value: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(118, 44)
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("#fff1d0"))
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#245743")
	style.border_color = Color("#c5a45b")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.content_margin_left = 12
	style.content_margin_right = 12
	button.add_theme_stylebox_override("normal", style)
	var hover := style.duplicate()
	hover.bg_color = Color("#367557")
	button.add_theme_stylebox_override("hover", hover)
	button.pressed.connect(callback)
	return button

func _add_action_button(parent: HBoxContainer, key: String, callback: Callable) -> void:
	var button := _make_button(key, callback)
	parent.add_child(button)
	action_buttons[key] = button

func _start_round() -> void:
	if bankroll < BASE_BET:
		status_text = "You're out of chips. Restart to play again."
		_update_status()
		return
	bet_amount = mini(bet_amount, bankroll)
	hand_bets = [bet_amount]
	bankroll -= bet_amount
	natural_blackjack = false
	player_hands = [[]]
	dealer_hand = []
	active_hand = 0
	round_over = false
	dealer_hidden = true
	_build_deck()
	_clear_cards()
	status_text = "Cards are in the air..."
	_update_status()
	_update_controls()
	_deal_to(dealer_hand, true)
	_deal_to(player_hands[0], false)
	_deal_to(dealer_hand, true)
	_deal_to(player_hands[0], false)
	_refresh_table()
	_update_controls()
	natural_blackjack = _hand_value(player_hands[0]) == 21
	if natural_blackjack:
		_finish_player_turn()

func _build_deck() -> void:
	deck.clear()
	var suits := ["Clubs", "Diamonds", "Hearts", "Spades"]
	for suit in suits:
		for rank in range(1, 14):
			deck.append({"suit": suit, "rank": rank})
	deck.shuffle()

func _draw_card() -> Dictionary:
	if deck.is_empty():
		_build_deck()
	return deck.pop_back()

func _deal_to(hand: Array, is_dealer: bool) -> void:
	var card := _draw_card()
	hand.append(card)
	_animate_deal(is_dealer, card)

func _clear_cards() -> void:
	for child in dealer_cards.get_children():
		child.queue_free()
	for child in player_hands_row.get_children():
		child.queue_free()

func _refresh_table() -> void:
	for child in dealer_cards.get_children():
		child.queue_free()
	for i in range(dealer_hand.size()):
		var hidden := dealer_hidden and i == 1
		dealer_cards.add_child(_create_card(dealer_hand[i], hidden))
	for hand_index in range(player_hands.size()):
		var hand_panel := VBoxContainer.new()
		hand_panel.add_theme_constant_override("separation", 5)
		player_hands_row.add_child(hand_panel)
		var label := _make_label("HAND %d  •  %d%s" % [hand_index + 1, _hand_value(player_hands[hand_index]), "  ◀" if hand_index == active_hand and not round_over else ""], 14, Color("#f2d99f"))
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hand_panel.add_child(label)
		var cards := HBoxContainer.new()
		cards.alignment = BoxContainer.ALIGNMENT_CENTER
		cards.add_theme_constant_override("separation", 7)
		hand_panel.add_child(cards)
		for card in player_hands[hand_index]:
			cards.add_child(_create_card(card, false))
	_update_stats()

func _create_card(card: Dictionary, face_down: bool) -> Control:
	var image := TextureRect.new()
	image.custom_minimum_size = CARD_SIZE
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var path := BACK_PATH if face_down else _card_path(card)
	if ResourceLoader.exists(path):
		image.texture = load(path)
	else:
		var fallback := Label.new()
		fallback.text = "CARD" if face_down else _rank_name(int(card.rank)) + "\n" + _suit_symbol(str(card.suit))
		fallback.custom_minimum_size = CARD_SIZE
		fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		fallback.add_theme_color_override("font_color", Color("#222222"))
		fallback.add_theme_font_size_override("font_size", 22)
		var panel := PanelContainer.new()
		panel.custom_minimum_size = CARD_SIZE
		panel.add_child(fallback)
		return panel
	image.pivot_offset = CARD_SIZE / 2.0
	image.scale = Vector2(0.86, 0.86)
	image.modulate.a = 0.0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(image, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(image, "modulate:a", 1.0, 0.18)
	tween.tween_property(image, "rotation", 0.0, 0.24).from(randf_range(-0.12, 0.12))
	return image

func _animate_deal(is_dealer: bool, card: Dictionary) -> void:
	# The table refresh builds the visual card; a quick status pulse sells the deal.
	if status_label:
		var tween := create_tween()
		tween.tween_property(status_label, "scale", Vector2(1.04, 1.04), 0.08)
		tween.tween_property(status_label, "scale", Vector2.ONE, 0.14)

func _card_path(card: Dictionary) -> String:
	return CARD_ROOT + str(card.suit) + "/" + str(card.suit) + "_card_%02d.png" % int(card.rank)

func _rank_name(rank: int) -> String:
	if rank == 1: return "A"
	if rank == 11: return "J"
	if rank == 12: return "Q"
	if rank == 13: return "K"
	return str(rank)

func _suit_symbol(suit: String) -> String:
	match suit:
		"Clubs": return "♣"
		"Diamonds": return "♦"
		"Hearts": return "♥"
		_: return "♠"

func _hand_value(hand: Array) -> int:
	var total := 0
	var aces := 0
	for card in hand:
		var rank := int(card.rank)
		if rank == 1:
			total += 11
			aces += 1
		elif rank >= 10:
			total += 10
		else:
			total += rank
	while total > 21 and aces > 0:
		total -= 10
		aces -= 1
	return total

func _is_pair(hand: Array) -> bool:
	return hand.size() == 2 and _card_points(hand[0]) == _card_points(hand[1])

func _card_points(card: Dictionary) -> int:
	return mini(int(card.rank), 10)

func _on_deal_pressed() -> void:
	if round_over:
		_start_round()

func _on_hit_pressed() -> void:
	if round_over: return
	_deal_to(player_hands[active_hand], false)
	_refresh_table()
	var value := _hand_value(player_hands[active_hand])
	if value > 21:
		status_text = "Bust! Hand %d went over 21." % (active_hand + 1)
		_advance_hand()
	elif value == 21:
		status_text = "21! Nice hand."
		_advance_hand()
	else:
		status_text = "Card dealt. You're on %d." % value
	_update_status()
	_update_controls()

func _on_stand_pressed() -> void:
	if round_over: return
	status_text = "Standing on %d." % _hand_value(player_hands[active_hand])
	_advance_hand()
	_update_status()
	_update_controls()

func _on_double_pressed() -> void:
	if round_over: return
	var hand: Array = player_hands[active_hand]
	if hand.size() != 2 or bankroll < hand_bets[active_hand]:
		return
	bankroll -= hand_bets[active_hand]
	hand_bets[active_hand] *= 2
	_deal_to(hand, false)
	_refresh_table()
	status_text = "Double down! One card, double the stakes."
	_advance_hand()
	_update_status()
	_update_controls()

func _on_split_pressed() -> void:
	if round_over: return
	var hand: Array = player_hands[active_hand]
	if not _is_pair(hand) or bankroll < hand_bets[active_hand]:
		return
	bankroll -= hand_bets[active_hand]
	var second_card: Dictionary = hand.pop_back()
	var new_hand: Array = [second_card]
	player_hands.insert(active_hand + 1, new_hand)
	hand_bets.insert(active_hand + 1, hand_bets[active_hand])
	_deal_to(hand, false)
	_deal_to(new_hand, false)
	_refresh_table()
	status_text = "Split! Play each hand one at a time."
	_update_status()
	_update_controls()

func _advance_hand() -> void:
	if active_hand + 1 < player_hands.size():
		active_hand += 1
		_refresh_table()
		status_text = "Your turn: hand %d." % (active_hand + 1)
	else:
		_finish_player_turn()

func _finish_player_turn() -> void:
	for hand in player_hands:
		if _hand_value(hand) <= 21:
			dealer_hidden = false
			while _hand_value(dealer_hand) < 17:
				_deal_to(dealer_hand, true)
			break
	dealer_hidden = false
	_refresh_table()
	round_over = true
	var dealer_value := _hand_value(dealer_hand)
	var dealer_natural := dealer_hand.size() == 2 and dealer_value == 21
	var results: Array[String] = []
	for i in range(player_hands.size()):
		var value := _hand_value(player_hands[i])
		if value > 21:
			results.append("H%d bust" % (i + 1))
		elif natural_blackjack and i == 0:
			if dealer_natural:
				bankroll += hand_bets[i]
				results.append("H%d push (both blackjack)" % (i + 1))
			else:
				var blackjack_payout := int(hand_bets[i] * 2.5)
				bankroll += blackjack_payout
				results.append("H%d blackjack +$%d" % [i + 1, blackjack_payout - hand_bets[i]])
		elif dealer_natural:
			results.append("H%d loses to dealer blackjack" % (i + 1))
		elif dealer_value > 21 or value > dealer_value:
			var payout := hand_bets[i] * 2
			bankroll += payout
			results.append("H%d wins +$%d" % [i + 1, payout - hand_bets[i]])
		elif value == dealer_value:
			bankroll += hand_bets[i]
			results.append("H%d push" % (i + 1))
		else:
			results.append("H%d loses" % (i + 1))
	status_text = "Dealer: %d  •  %s" % [dealer_value, "   ".join(results)]
	_update_status()
	_update_controls()
	_update_stats()

func _update_controls() -> void:
	var playing := not round_over
	deal_button.disabled = playing
	deal_button.text = "DEAL AGAIN" if round_over else "IN PLAY"
	action_buttons["HIT"].disabled = not playing
	action_buttons["STAND"].disabled = not playing
	var hand: Array = player_hands[active_hand] if playing and active_hand < player_hands.size() else []
	action_buttons["DOUBLE"].disabled = not playing or hand.size() != 2 or bankroll < hand_bets[active_hand]
	action_buttons["SPLIT"].disabled = not playing or not _is_pair(hand) or bankroll < hand_bets[active_hand]

func _update_stats() -> void:
	bankroll_label.text = "BANKROLL  $%d" % bankroll
	bet_label.text = "BET  $%d" % bet_amount

func _update_status() -> void:
	status_label.text = status_text
	var pulse := create_tween()
	pulse.tween_property(status_label, "scale", Vector2(1.03, 1.03), 0.08)
	pulse.tween_property(status_label, "scale", Vector2.ONE, 0.14)
