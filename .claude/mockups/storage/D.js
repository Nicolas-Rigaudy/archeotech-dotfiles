.pragma library
var G=1073741824
var root={size:232109637632, used:204389195776, free:22854033408, pct:90, meta:2692775936, unalloc:1048576}
// tier, label, path/sub, cost, bytes, admin, checked, how
var safe=[
 {l:"uv cache", p:"~/.cdx/shared-cache/uv", c:"Packages re-download on the next install", b:29754223082, a:false, on:true},
 {l:"Pacman package cache", p:"/var/cache/pacman/pkg", c:"Keeps the last 2 versions of each package", b:8346402954, a:true, on:true},
 {l:"AUR build cache (paru)", p:"~/.cache/paru", c:"Rebuilt on the next AUR update", b:5343659385, a:false, on:true},
 {l:"App caches", p:"zen, spotify, aws, poetry, wallpaper +4", c:"Apps rebuild them; close the apps first", b:3817095109, a:false, on:true},
 {l:"Systemd journal", p:"/var/log/journal", c:"Keeps the newest 500 MB of logs", b:679477248, a:true, on:true},
 {l:"Trash", p:"~/.local/share/Trash", c:"Emptied for good", b:557164992, a:false, on:true},
 {l:"Old snapshots", p:"82 snapshots (50 pre/post)", c:"Snapper cleanup rules; size unknown", b:null, a:true, on:false}
]
var review=[
 {l:"Leftover cdx profile", p:".digital.remove._m4mgsnz  ·  2026-05-05", c:"Left by a profile reset; check nothing in it is needed", b:19712985017, a:false, on:false},
 {l:"Old config backup", p:"~/arch-backup-20251126", c:"Copy of ~/.config from 26 Nov 2025", b:3544217168, a:false, on:false},
 {l:"Leftover cdx profile", p:".corvus.remove.uxz8psry  ·  2026-05-05", c:"Left by a profile reset; check nothing in it is needed", b:3135736703, a:false, on:false},
 {l:"Downloads", p:"~/Downloads  ·  sorted daily", c:"Opens the folder; you pick what goes", b:3560881333, a:false, on:false, open:true}
]
