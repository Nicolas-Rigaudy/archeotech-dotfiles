## item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule - Downloads tidy: sort ~/Downloads into type folders on a schedule
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: downloads, tidy, sort, type, folders, schedule
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- ~/Downloads holds 196 loose files of every type and is never sorted, so finding a recent PDF or slide deck means scrolling through images and archives.

# Scope
- In:
  - scripts/downloads-tidy.sh: moves top-level files into Images, Documents (pdf, md, txt, office docs), Slides (pptx, odp, key), Archives (zip, tar.*, 7z), Media, Installers, Other; folder map at the top of the script.
  - Skips partial downloads (.part, .crdownload, .download), dotfiles, folders, and files modified in the last day; a name clash gets a numbered suffix, never an overwrite; never deletes.
  - --dry-run prints the moves; a log of moves in the state dir so a sort can be undone by hand.
  - config/.config/systemd/user/downloads-tidy.{service,timer}: daily, Persistent=true; install.sh links and enables them.
- Out:
  - Deleting or archiving old files (owner decision later).
  - Sorting inside subfolders or other directories.

# Acceptance criteria
- AC3: A dry run on the real folder lists the planned moves and changes nothing; a real run leaves no loose files older than a day except Other, and the file count before and after is equal.
- AC3: A file being written (a .part file, or one modified within the day) is left in place.
- AC4: Units and script are tracked and listed in docs/TOOLS.md.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: A dry run on the real folder lists the planned moves and changes nothing; a real run leaves no loose files older than a day except Other, and the file count before and after is equal.
- request-AC4 -> This backlog slice. Proof: AC3: A file being written (a .part file, or one modified within the day) is left in place.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)
- Request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Primary task(s): `task_083_orchestrate_machine_housekeeping`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

