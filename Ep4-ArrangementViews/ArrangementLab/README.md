# ArrangementLab

The test project from **Adapting a Real App for iPhone Duo, Episode 4: Arrangement Views**.

It's the lab I used to check every arrangement-view behavior in the episode on the Xcode 27.1 release candidate, on the iPhone Duo simulator. The screens are plain colored blocks on purpose, so the layout is easy to see.

## Requirements

- Xcode 27.1 or later
- iPhone Duo simulator
- Arrangement views need iOS 27.1. The project still runs on iOS 26 and shows a fallback message there.

## What's inside

| Screen | What it tests |
|---|---|
| A: Split (recipe) | `ArrangementView` with `.split`, the 0.35 layout ratio, the split lining up with an active fold, and the ingredients switching between a list and a row based on their own size when `splitArrangementAxis` reads nil |
| B: Overlay (weather) | `ArrangementView` with `.overlay`, the overlay z-index, the fold reading that picks compact or expanded, and the overlay edge (Mode and Edge menus in the toolbar) |

Each screen shows a readout of the fold and the values the views receive, so you can watch them change as you change poses.

## Names in the video vs. this project

The code in the video uses the names of the apps on screen. Everything else is the same.

| In the video | In this project |
|---|---|
| `RecipeStepsView()` | `LabBlock(title: "Steps", color: .teal)` |
| `IngredientsView()` | `IngredientsLabBlock()` |
| `ConditionsCard()` | `ConditionsLabCard()` |
| `SkyView()` | `SkyLabBlock()` |
| `RecipeScreen` | `SplitLabView` |
| `WeatherScreen` | `OverlayLabView` |
