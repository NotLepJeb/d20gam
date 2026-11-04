# D20Gam — Blackjack

A blackjack game built in Godot 4.3 using the supplied D20 playing-card artwork.

## Run
1. Install Godot 4.3 or a compatible Godot 4.x release.
2. Clone or download this repository.
3. Open `project.godot` in Godot and press **F5**.

## How to play
- **Deal / Deal Again** starts a hand with a $50 wager.
- **Hit** takes another card.
- **Stand** ends your turn.
- **Double** doubles your wager and gives you exactly one more card.
- **Split** separates a pair into two hands, matching the original wager on the second hand.
- Aces count as 1 or 11. Face cards count as 10. The dealer stands on 17.
- Natural blackjack pays 3:2; regular wins pay 1:1.

You start with a $1,000 bankroll. Wagers are deducted when the hand starts; winning returns the wager plus winnings, and a push returns the wager.

## Card assets
The game loads its card faces from these paths:
- `assets/sprites/cards/Clubs/Clubs_card_01.png` through `Clubs_card_13.png`
- `assets/sprites/cards/Diamonds/Diamonds_card_01.png` through `Diamonds_card_13.png`
- `assets/sprites/cards/Hearts/Hearts_card_01.png` through `Hearts_card_13.png`
- `assets/sprites/cards/Spades/Spades_card_01.png` through `Spades_card_13.png`
- `assets/sprites/cards/Backs/back_0.png` for the dealer's hidden card

The table centers the dealer and player hands. Cards animate into view with a quick pop, fade, and slight rotation when dealing, hitting, splitting, or doubling.

## Project layout
- `scenes/main.tscn` — main game scene
- `scripts/main.gd` — blackjack game logic and UI
- `assets/sprites/cards/` — card artwork
- `assets/fonts/` — supplied fonts
- `assets/audio/` — audio assets
- `resources/` — reusable Godot resources
- `addons/` — optional editor plugins
