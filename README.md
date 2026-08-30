# Anime Dragon Super 3D

Godot 4 mobile-friendly 3D prototype.

## 10 characters
Goku, Vegeta, Gohan, Broly, Frieza, Jiren, Beerus, Gogeta, Vegito, Hit.

## Gameplay
Fast movement, lock-on, touch buttons, attack, aura, special move and ultimate.
The project uses the Compatibility renderer for better Android support.

## Voice commands
The UI reserves a voice-command layer for:
- "لكمة" -> attack
- "هالة" -> aura
- "حركة خاصة" -> special
- "Ultimate" / "التميت" -> ultimate

Actual Android speech recognition is not a built-in Godot gameplay API; connect an Android Speech Recognition plugin/bridge to call `action_do()` with the recognized command. The game remains fully playable with touch controls.

## Android
The Godot Android editor can import, develop and export 2D/3D projects directly on Android. Install the matching export templates, create an Android export preset, then Export Project to APK.

Official docs:
https://docs.godotengine.org/en/stable/tutorials/editor/using_the_android_editor.html
https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## GitHub
Upload this folder as a repository. Keep signing keys private.
