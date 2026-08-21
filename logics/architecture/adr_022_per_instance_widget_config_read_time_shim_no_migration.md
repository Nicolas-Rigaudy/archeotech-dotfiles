## adr_022_per_instance_widget_config_read_time_shim_no_migration - Per-instance widget config: read-time shim, no migration
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Consuming configSchema meant changing shell-config.json entry shape without breaking old files or reloading live widgets.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Normalize entries on read into {id, config}, carry config as a JSON string through the ListModel, and edit it per-instance in edit mode.

# Context
- Sprint 26 made configSchema consumed; zone/strip entries became {id, config} objects.
- ListModel mangles nested object/array roles; a string is trivially diffable and updatable in place with setProperty.
- Rows are keyed on id + '#' + occurrence so two same-id widgets keep distinct delegates.

# Decision
- ShellConfig._normEntry normalizes on read so old bare-string files load unchanged — no migration script, no version bump.
- Config rides through Bar._syncZone's stable ListModel as a JSON string (configJson), letting a config edit not reload the live widget.
- Edit config per-instance from the edit-mode chip gear; deliberately no global-default layer for built-ins (YAGNI — schema default covers unset fields).

# Consequences
- Reordering two identical-id widgets recreates the moved delegate (occurrence changes); cheap.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
