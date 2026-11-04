# D20Gam — Card Gallery

This Godot 4 project displays the complete supplied playing-card artwork as a scrollable gallery. The previous blackjack game has been replaced by a card collection viewer.

## Run
1. Install Godot Engine 4.x.
2. Clone or download this repository.
3. Copy the supplied card PNGs into `assets/sprites/cards/`, keeping the folders and filenames unchanged.
4. Copy the supplied TTF files into `assets/fonts/`.
5. Import `project.godot` in Godot and press **F5**.

## Asset layout
- `assets/sprites/cards/Backs/` — 9 card backs
- `assets/sprites/cards/Clubs/` — 13 cards
- `assets/sprites/cards/Diamonds/` — 13 cards
- `assets/sprites/cards/Hearts/` — 13 cards
- `assets/sprites/cards/Spades/` — 13 cards
- `assets/sprites/cards/Joker/` — 2 jokers
- `assets/fonts/` — supplied pixel fonts

The gallery is grouped by card type, uses a seven-column grid, and shows placeholders for any missing images. The supplied artwork contains 63 PNG files and the font archive contains 19 TTF files.

## Project layout
- `scenes/main.tscn` — main gallery scene
- `scripts/main.gd` — dynamic card gallery
- `assets/sprites/cards/` — card artwork
- `assets/fonts/` — fonts
- `assets/audio/` — audio assets
- `resources/` — reusable Godot resources
- `addons/` — optional editor plugins
