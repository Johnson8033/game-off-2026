# Game Off 2026

## Project structure

```text
.
├── addons/
│   └── dialogic/                  # Dialogic plugin
├── dialogic/
│   ├── characters/                # Character definitions (.dch)
│   └── timelines/                 # Dialogue scripts (.dtl)
│       ├── monday/
│       │   ├── day/
│       │   └── night/
│       └── placeholder.dtl        # Fallback for missing dialogue
├── scenes/
│   ├── main_menu.tscn
│   ├── game.tscn                  # Parent of the gameplay screens
│   ├── scheduling_screen.tscn
│   ├── shift_screen.tscn          # CCTV and dialogue
│   └── ending_screen.tscn
├── scripts/
│   ├── main_menu.gd               # Menu navigation
│   ├── game.gd                    # Game flow and screen transitions
│   ├── game_state.gd              # Schedule, progression and shift history
│   ├── scheduling_screen.gd       # Employee selection and preview
│   ├── shift_screen.gd            # Timeline loading and outcome signals
│   ├── ending_screen.gd           # Ending results and restart
│   ├── employee.gd                # Employee enum and Dialogic IDs
│   └── employee_button.gd         # Employee ID assigned to each button
├── project.godot
└── export_presets.cfg             # Web export settings
```

## How it works

- `Game` owns a `GameState` instance and switches between its child screens using `show()` and `hide()`.
- `SchedulingScreen` emits `schedule_confirmed` with the two selected employee IDs. `GameState` assigns the remaining employees to the night shift.
- `ShiftScreen` loads the appropriate Dialogic timeline and emits `shift_completed` with its outcome when it finishes.
- `Game` records each result before advancing from day to night, or returning to scheduling for the next day.
- After Friday night, `EndingScreen` displays the final results. Restart creates a fresh game state.

`GameState` stores the current day, current shift, employee assignments and a history of completed shifts (day, shift, employees and outcome). Outcomes are `GOOD`, `BAD` or `UNKNOWN`.

## Adding dialogue

Create `.dtl` files under `dialogic/timelines/<day>/<shift>/`.
Use lowercase employee IDs in alphabetical order for filenames, e.g. `tuesday/day/cordelle_roy.dtl`.

```text
join cordelle left
join roy right
cordelle: Shall we get started?
roy: Fine.
game: They finished their work. Good shift.
[signal arg="shift_good"]
```

Each playable path should execute exactly one outcome signal: `shift_good` or `shift_bad`. Missing timelines use `placeholder.dtl` and are recorded as `UNKNOWN`.

Hold Ctrl during dialogue to fast-forward for testing.

## Web export

Use the existing Web export preset. Export all resources so dynamically loaded timelines are included. Keep generated builds out of Git; ZIP the exported files with `index.html` at the archive root for itch.io.

## TODO

- [ ] More timelines
- [ ] Conditional endings
- [ ] Conditional dialogue
- [ ] Ending cutscenes
- [ ] Persistent saves
- [ ] Final artwork
- [ ] Game title
- [ ] Credits
