import QtQuick
import QtQuick.Layouts
import "./Panes"

// Shows the active settings pane. Uses a StackLayout (shows only currentIndex)
// rather than a translated carousel — the old `y: -activeIndex * height`
// approach flashed Appearance (index 0) on open because `height` is 0 on the
// first layout pass, and it slid between panes. StackLayout has no position
// state to get wrong: the correct pane is shown on the first frame, switching
// is instant.
Item {
    id: root
    property int activeIndex: 0
    clip: true

    StackLayout {
        anchors.fill: parent
        currentIndex: root.activeIndex

        // Order must match PaneRegistry.panes exactly (activeIndex selects the
        // child by index; mismatched order = wrong pane).
        AppearancePane    {}
        ShellPane         {}
        DisplayPane       {}
        NotificationsPane {}
        ConnectionsPane   {}
        AudioPane         {}
        PowerPane         {}
        AboutPane         {}
    }
}
