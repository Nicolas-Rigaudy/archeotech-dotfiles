## adr_014_bluetooth_set_trusted_before_connect_with_a_persistent_pairing_agent - Bluetooth: set Trusted before Connect, with a persistent pairing agent
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Untrusted audio devices connect-then-disconnect, and scan/pair need a persistent D-Bus connection a one-shot busctl call can't hold.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Mark devices Trusted before Connect and run a persistent bt-agent.py to hold discovery and answer pairing.

# Context
- An untrusted audio device brings the ACL link up, then bluez denies A2DP/HFP setup and tears the whole link down.
- Trust authorises the audio profiles and enables auto-reconnect on power-on / range return.
- A one-shot busctl call dies instantly, so discovery can't be held open and pairing has no agent to answer.

# Decision
- connectDevice() sets Trusted=true before calling Connect; the device model emits all tree devices deduped with sort -u.
- scripts/bt-agent.py is a persistent dbus-python + GLib NoInputNoOutput agent (--scan holds discovery, --pair does Pair+Trust+Connect), symlinked to ~/.local/bin and called by name from Bluetooth.qml.

# Consequences
- Adds a Python dependency (dbus-python, PyGObject) for the pairing path.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
