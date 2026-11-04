# D20Gam — Blackjack

A small single-player blackjack game built with Godot 4. It uses virtual play chips only; there are no real-money wagers or payments.

## Run
1. Install Godot Engine 4.x.
2. Clone or download this repository.
3. In Godot, choose **Import** and select this folder's `project.godot`.
4. Press **F6** to run the main scene (or **F5** to run the project).

## How to play
- Start with 1,000 virtual chips.
- Adjust your wager with **− BET** and **+ BET**.
- Press **DEAL**, then choose **HIT** or **STAND**.
- Get as close to 21 as possible without going over.
- Dealer stands on 17. Blackjack pays 3:2; a tie returns the wager.

## Project layout
- `scenes/main.tscn` — game entry scene
- `scripts/main.gd` — blackjack rules and dynamically-built table UI
- `assets/` — sprites, audio, and fonts
- `resources/` — reusable Godot resources
- `addons/` — optional editor plugins
