# Flash Collision

Assign selected parts to an existing collision group. Preview the old and new names before applying the batch.

## Install

1. Download this repository as a ZIP and extract it. No package installation is needed to use the plugin.
2. In a separate Studio test place, use Explorer's **Insert from File** action to insert `FlashCollision.rbxmx`.
3. Select the root Script named `FlashCollision` (it has five child ModuleScripts) and choose **Save as Local Plugin**.
4. Remove the imported Script from the place. Open **Flash Collision → Groups** on the Plugins toolbar.

The plugin runs in edit mode. Scans and edits are refused during a play test.

Preview makes no edits. Selection or option changes clear the plan. Apply rechecks changed targets and uses one Studio undo recording. A failed write asks Studio to cancel the batch. Up to 100 preview rows are shown, but Apply includes every change in the plan. Use a smaller selection if you want every row visible. Verify Undo and Redo on a copy before important work.

## Use it

1. Create the groups and collision rules in Studio's built-in collision-group editor.
2. Select parts, or select a Model/folder and choose **Include descendants**.
3. Enter the exact destination group name. **Refresh registered groups** lists the names currently registered in Workspace.
4. Preview, review the targets, then apply. Studio Undo reverts the successful batch together.

This is useful for moving existing scenery or prop collections into a group after building them. It changes each part's `CollisionGroup` property; it does not edit the collision matrix, create groups, toggle CanCollide, move parts or add constraints.

## Limits

- Only BaseParts in Workspace's own WorldRoot are targets. Parts inside nested WorldModels or other services are ignored. A locked eligible part blocks the preview.
- Up to 500 selected roots, 5000 discovered objects and 1000 eligible parts. Overlapping selections are deduplicated. Selecting a service itself is refused.
- Group names must be registered, valid UTF-8, nonblank, without control characters, and at most 100 bytes (this tool's input limit). Names are case-sensitive.
- The plan is a snapshot: descendants added later are not included. Apply rechecks target parents, worlds, groups and lock states, and checks that the destination group still exists.
- Current Studio exposes collision-group methods on WorldRoot. The reader falls back to PhysicsService for older Studio builds. No group registration or collision-rule API is called by this plugin.

## Inputs and outputs

`Rules.plan(rows, group, registered)` takes part records, a destination name and a set of registered names. It returns only changed assignments. `Scope.collect` expands the selection when requested. `Adapter` reads Studio state and writes `CollisionGroup`; it never edits group definitions.

See Roblox's [WorldRoot API](https://create.roblox.com/docs/reference/engine/classes/WorldRoot) for collision-group behavior.

## Development and tests

Source is in `src`. The dock panel follows Studio's theme. There are no runtime packages, external assets, file uploads, telemetry or network requests. The UI and scope helpers are shared with the other Flash plugins; each repository has its own copy so it can be installed independently.

Rebuild with Python 3.11+:

```sh
python build.py
python -m unittest discover -s tests -v
```

Run the Luau checks with Lune 0.11.1:

```sh
lune run tests/run
```

GitHub Actions compiles every source file, runs scope/rule/adapter checks with fake Studio objects, verifies the packaged source and checks reproducible builds. The editing plugins also test undo-recording commit/cancel behavior with a fake history service. Lune is installed on the CI runner, not on your PC.

**The dock widget, local-plugin installation and real Studio engine behavior have not been verified live.** See [Studio checks](docs/STUDIO-CHECKS.md). A passing automated test is not a live Studio compatibility guarantee.

MIT licensed; see [LICENSE](LICENSE).
