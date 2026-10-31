# Studio checks

Status: not yet run in a live Studio session. Record the Studio version, date and outcome when running these checks.

1. Install `FlashCollision.rbxmx` in a separate test place. Check that the toolbar button opens and closes the dock panel.
2. Try light and dark themes and a narrow dock. Fields, result text and status should remain readable and scrollable.
3. Test selection-only and nested scopes where supported, including overlapping roots and a removed object. Compare the counts with Explorer.
4. Try the valid and invalid inputs listed in the README. A rejected operation should leave the place unchanged.
5. Start a play test. The plugin must refuse scans/edits, then work again after the test stops.
6. Disable or reload the plugin. The dock panel and toolbar should disappear without leftover connections or errors.

7. Preview a batch; confirm no properties changed. Change an option or selection and confirm Apply requires another preview. Change a target after preview and confirm Apply refuses it.
8. Apply a small valid batch, Undo once and Redo once. Verify the exact prior states, including pre-existing replacement tags for Flash Tags. A no-op batch must not create an undo entry.
