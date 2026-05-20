import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../Commons" as Commons
import "../../../Services/Networking" as NetworkServices
import "../Widgets"

Item {
    id: root

    property string _wifiAskPwFor: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        PaneHeader {
            icon: "󰤨"
            title: "Connections"
            description: "Manage WiFi networks and paired Bluetooth devices"
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: col.implicitHeight + 32
            clip: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: col
                anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 24; leftMargin: 24; rightMargin: 24 }
                width: root.width - 48
                spacing: 6

                // ── WiFi ──────────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    SectionLabel { text: "WI-FI"; Layout.fillWidth: true }

                    // Enable/disable toggle pill
                    Rectangle {
                        height: 22; width: wifiToggleRow.implicitWidth + 16
                        radius: 11
                        color: NetworkServices.Network.wifiEnabled
                            ? Commons.Appearance.colors.accentAlpha
                            : Commons.Appearance.colors.surface0
                        border.color: NetworkServices.Network.wifiEnabled
                            ? Commons.Appearance.colors.accentBorder
                            : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                        RowLayout {
                            id: wifiToggleRow
                            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 8; right: parent.right; rightMargin: 8 }
                            spacing: 5

                            Text {
                                text: NetworkServices.Network.wifiEnabled ? "󰖩" : "󰖪"
                                color: NetworkServices.Network.wifiEnabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            }
                            Text {
                                text: NetworkServices.Network.wifiEnabled ? "On" : "Off"
                                color: NetworkServices.Network.wifiEnabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: NetworkServices.Network.toggleWifi()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: wifiCol.implicitHeight
                    visible: NetworkServices.Network.wifiEnabled

                    ColumnLayout {
                        id: wifiCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 12; rightMargin: 12 }
                        spacing: 0

                        Item { implicitHeight: 6; Layout.fillWidth: true }

                        // Connected
                        Repeater {
                            model: NetworkServices.Network.displayNetworks.filter(function(n) { return n.active })
                            delegate: WifiRow { Layout.fillWidth: true }
                        }

                        // Divider between connected and saved when both present
                        Item {
                            implicitHeight: 2; Layout.fillWidth: true
                            visible: NetworkServices.Network.displayNetworks.filter(function(n){ return n.active }).length > 0
                                  && NetworkServices.Network.displayNetworks.filter(function(n){ return n.saved && !n.active }).length > 0
                        }

                        // Saved
                        Repeater {
                            model: NetworkServices.Network.displayNetworks.filter(function(n) { return n.saved && !n.active })
                            delegate: WifiRow { Layout.fillWidth: true }
                        }

                        // Divider before available
                        Rectangle {
                            height: 1; Layout.fillWidth: true
                            color: Commons.Appearance.colors.base
                            visible: NetworkServices.Network.displayNetworks.filter(function(n){ return !n.saved && !n.active }).length > 0
                                  && (NetworkServices.Network.displayNetworks.filter(function(n){ return n.active }).length > 0
                                   || NetworkServices.Network.displayNetworks.filter(function(n){ return n.saved && !n.active }).length > 0)
                        }

                        Text {
                            visible: NetworkServices.Network.displayNetworks.filter(function(n){ return !n.saved && !n.active }).length > 0
                            text: "AVAILABLE"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: 9; font.family: Commons.Appearance.font.family
                            font.weight: Font.Medium; font.letterSpacing: 1.5
                            Layout.fillWidth: true
                            Layout.topMargin: 6; Layout.bottomMargin: 2
                        }

                        Repeater {
                            model: NetworkServices.Network.displayNetworks.filter(function(n) { return !n.saved && !n.active })
                            delegate: WifiRow { Layout.fillWidth: true }
                        }

                        Text {
                            visible: NetworkServices.Network.displayNetworks.length === 0
                            text: "Scanning for networks…"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4
                        }

                        Item { implicitHeight: 6; Layout.fillWidth: true }
                    }
                }

                Text {
                    visible: !NetworkServices.Network.wifiEnabled
                    text: "Wi-Fi is disabled."
                    color: Commons.Appearance.colors.overlay0
                    font.pixelSize: Commons.Appearance.font.sizeBase
                    font.family: Commons.Appearance.font.family
                }

                // ── Bluetooth ─────────────────────────────────────────────────
                Item { implicitHeight: 10; Layout.fillWidth: true }

                RowLayout {
                    Layout.fillWidth: true
                    SectionLabel { text: "BLUETOOTH"; Layout.fillWidth: true }

                    Rectangle {
                        height: 22; width: btToggleRow.implicitWidth + 16
                        radius: 11
                        color: NetworkServices.Bluetooth.enabled
                            ? Commons.Appearance.colors.accentAlpha
                            : Commons.Appearance.colors.surface0
                        border.color: NetworkServices.Bluetooth.enabled
                            ? Commons.Appearance.colors.accentBorder
                            : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                        RowLayout {
                            id: btToggleRow
                            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 8; right: parent.right; rightMargin: 8 }
                            spacing: 5

                            Text {
                                text: NetworkServices.Bluetooth.enabled ? "󰂯" : "󰂲"
                                color: NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            }
                            Text {
                                text: NetworkServices.Bluetooth.enabled ? "On" : "Off"
                                color: NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                font.pixelSize: 11; font.family: Commons.Appearance.font.family
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: NetworkServices.Bluetooth.toggleBluetooth()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: btCol.implicitHeight
                    visible: NetworkServices.Bluetooth.enabled

                    ColumnLayout {
                        id: btCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 12; rightMargin: 12 }
                        spacing: 0

                        Item { implicitHeight: 6; Layout.fillWidth: true }

                        Text {
                            visible: NetworkServices.Bluetooth.devices.length === 0
                            text: "No paired devices"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            Layout.fillWidth: true; Layout.topMargin: 2; Layout.bottomMargin: 2
                        }

                        Repeater {
                            model: NetworkServices.Bluetooth.devices
                            delegate: Item {
                                required property var modelData
                                required property int index
                                Layout.fillWidth: true
                                implicitHeight: 40

                                Rectangle {
                                    visible: index > 0
                                    anchors { left: parent.left; right: parent.right; top: parent.top }
                                    height: 1; color: Commons.Appearance.colors.base
                                }

                                RowLayout {
                                    anchors { fill: parent; topMargin: index > 0 ? 1 : 0 }
                                    spacing: 10

                                    Text {
                                        text: modelData.connected ? "󰂱" : "󰂯"
                                        color: modelData.connected ? Commons.Appearance.colors.mauve : Commons.Appearance.colors.overlay0
                                        font.pixelSize: 16; font.family: Commons.Appearance.font.family
                                        Layout.alignment: Qt.AlignVCenter
                                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1

                                        Text {
                                            text: modelData.name
                                            color: modelData.connected ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                                            font.pixelSize: Commons.Appearance.font.sizeBase
                                            font.family: Commons.Appearance.font.family
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                        }
                                        Text {
                                            visible: modelData.connected
                                            text: "Connected"
                                            color: Commons.Appearance.colors.mauve
                                            font.pixelSize: Commons.Appearance.font.sizeSm
                                            font.family: Commons.Appearance.font.family
                                        }
                                    }

                                    Rectangle {
                                        height: 26; width: btActionTxt.implicitWidth + 16
                                        radius: Commons.Appearance.radius.sm
                                        color: btActionMa.containsMouse
                                            ? Commons.Appearance.colors.surface1
                                            : Commons.Appearance.colors.base
                                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                                        Text {
                                            id: btActionTxt
                                            anchors.centerIn: parent
                                            text: modelData.connected ? "Disconnect" : "Connect"
                                            color: modelData.connected ? Commons.Appearance.colors.red : Commons.Appearance.colors.mauve
                                            font.pixelSize: Commons.Appearance.font.sizeSm
                                            font.family: Commons.Appearance.font.family
                                        }

                                        MouseArea {
                                            id: btActionMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: modelData.connected
                                                ? NetworkServices.Bluetooth.disconnectDevice(modelData.address)
                                                : NetworkServices.Bluetooth.connectDevice(modelData.address)
                                        }
                                    }
                                }
                            }
                        }

                        Item { implicitHeight: 6; Layout.fillWidth: true }
                    }
                }

                Text {
                    visible: !NetworkServices.Bluetooth.enabled
                    text: "Bluetooth is disabled."
                    color: Commons.Appearance.colors.overlay0
                    font.pixelSize: Commons.Appearance.font.sizeBase
                    font.family: Commons.Appearance.font.family
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
            }
        }
    }

    // ── WiFi network row ──────────────────────────────────────────────────────
    component WifiRow: Item {
        required property var modelData

        property bool _showPw:     root._wifiAskPwFor === modelData.ssid
        property bool _busyConn:   NetworkServices.Network.connectingTo === modelData.ssid
        property bool _busyDisc:   modelData.active && NetworkServices.Network.disconnectingFrom === modelData.ssid
        property bool _busy:       _busyConn || _busyDisc
        property bool _needsPw:    !modelData.saved && modelData.security !== "" && modelData.security !== "--"

        implicitHeight: _showPw ? 82 : 40
        clip: true
        Behavior on implicitHeight { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        RowLayout {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 40
            spacing: 8

            Text {
                text: NetworkServices.Network.signalIcon(modelData.signal, modelData.security !== "" && modelData.security !== "--")
                color: modelData.active ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                font.pixelSize: 14; font.family: Commons.Appearance.font.family
                Layout.alignment: Qt.AlignVCenter
                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    text: modelData.ssid
                    color: modelData.active ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                    font.pixelSize: Commons.Appearance.font.sizeBase
                    font.family: Commons.Appearance.font.family
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                }
                Text {
                    visible: modelData.active
                    text: NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band
                    color: Commons.Appearance.colors.overlay0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }
            }

            // Spinner or action button
            Item {
                width: _busy ? 20 : (actionBtn.visible ? actionBtn.width : 0)
                height: 26
                Behavior on width { NumberAnimation { duration: Commons.Appearance.anim.fast } }

                Text {
                    id: spinnerTxt
                    visible: _busy
                    anchors.centerIn: parent
                    text: "󰑙"; color: Commons.Appearance.colors.accent
                    font.pixelSize: 14; font.family: Commons.Appearance.font.family
                    RotationAnimator { target: spinnerTxt; running: _busy; loops: Animation.Infinite; from: 0; to: 360; duration: 900 }
                }

                Rectangle {
                    id: actionBtn
                    visible: !_busy
                    anchors.fill: parent
                    width: actionTxt.implicitWidth + 16
                    radius: Commons.Appearance.radius.sm
                    color: actionMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                    Text {
                        id: actionTxt
                        anchors.centerIn: parent
                        text: modelData.active ? "Disconnect" : "Connect"
                        color: modelData.active ? Commons.Appearance.colors.red : Commons.Appearance.colors.mauve
                        font.pixelSize: Commons.Appearance.font.sizeSm
                        font.family: Commons.Appearance.font.family
                    }

                    MouseArea {
                        id: actionMa
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.active) {
                                NetworkServices.Network.disconnect()
                            } else if (_needsPw) {
                                root._wifiAskPwFor = modelData.ssid
                            } else {
                                NetworkServices.Network.connect(modelData.ssid)
                            }
                        }
                    }
                }
            }
        }

        // Inline password field
        RowLayout {
            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 42 }
            height: 34
            spacing: 8
            visible: _showPw

            TextField {
                id: pwField
                Layout.fillWidth: true
                height: 30
                placeholderText: "Password for " + modelData.ssid
                echoMode: TextInput.Password
                font.pixelSize: Commons.Appearance.font.sizeSm
                font.family: Commons.Appearance.font.family
                color: Commons.Appearance.colors.text
                background: Rectangle {
                    radius: Commons.Appearance.radius.sm
                    color: Commons.Appearance.colors.base
                    border.color: pwField.activeFocus ? Commons.Appearance.colors.accentBorder : Commons.Appearance.colors.surface1
                    border.width: 1
                }
                onAccepted: {
                    NetworkServices.Network.connectWithPassword(modelData.ssid, pwField.text)
                    root._wifiAskPwFor = ""
                    pwField.text = ""
                }
            }

            Rectangle {
                height: 30; width: 60
                radius: Commons.Appearance.radius.sm
                color: connectMa.containsMouse ? Commons.Appearance.colors.accentAlpha : Commons.Appearance.colors.surface0
                border.color: Commons.Appearance.colors.accentBorder; border.width: 1
                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                Text {
                    anchors.centerIn: parent
                    text: "Join"
                    color: Commons.Appearance.colors.accent
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }

                MouseArea {
                    id: connectMa
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        NetworkServices.Network.connectWithPassword(modelData.ssid, pwField.text)
                        root._wifiAskPwFor = ""
                        pwField.text = ""
                    }
                }
            }

            Rectangle {
                height: 30; width: 60
                radius: Commons.Appearance.radius.sm
                color: cancelMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: Commons.Appearance.colors.subtext0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }

                MouseArea {
                    id: cancelMa
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: { root._wifiAskPwFor = ""; pwField.text = "" }
                }
            }
        }
    }

    component SectionLabel: Text {
        color: Commons.Appearance.colors.overlay0
        font.pixelSize: 10
        font.family: Commons.Appearance.font.family
        font.weight: Font.Medium
        font.letterSpacing: 1.5
    }
}
