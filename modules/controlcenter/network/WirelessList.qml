pragma ComponentBehavior: Bound

import ".."
import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services
import qs.utils

DeviceList {
    id: root

    required property Session session

    function checkSavedProfileForNetwork(ssid: string): void {
        if (ssid && ssid.length > 0) {
            Nmcli.loadSavedConnections(() => {});
        }
    }

    title: qsTr("Networks (%1)").arg(Nmcli.networks.length)
    description: qsTr("All available WiFi networks")
    activeItem: session.network.active

    titleSuffix: Component {
        StyledText {
            visible: Nmcli.scanning
            text: qsTr("Scanning...")
            color: Colours.palette.m3primary
            font.pointSize: Tokens.font.size.small
        }
    }

    model: ScriptModel {
        values: [...Nmcli.networks].sort((a, b) => {
            if (a.active !== b.active)
                return b.active - a.active;
            return b.strength - a.strength;
        })
    }

    headerComponent: Component {
        RowLayout {
            spacing: Tokens.spacing.smaller

            StyledText {
                text: qsTr("Settings")
                font.pointSize: Tokens.font.size.large
                font.weight: 500
            }

            Item {
                Layout.fillWidth: true
            }

            ToggleButton {
                toggled: Nmcli.wifiEnabled
                icon: "wifi"
                accent: "Tertiary"
                iconSize: Tokens.font.size.normal
                horizontalPadding: Tokens.padding.normal
                verticalPadding: Tokens.padding.smaller

                onClicked: {
                    Nmcli.toggleWifi(null);
                }
            }

            ToggleButton {
                toggled: Nmcli.scanning
                icon: "wifi_find"
                accent: "Secondary"
                iconSize: Tokens.font.size.normal
                horizontalPadding: Tokens.padding.normal
                verticalPadding: Tokens.padding.smaller

                onClicked: {
                    Nmcli.rescanWifi();
                }
            }

            ToggleButton {
                toggled: !root.session.network.active
                icon: "settings"
                accent: "Primary"
                iconSize: Tokens.font.size.normal
                horizontalPadding: Tokens.padding.normal
                verticalPadding: Tokens.padding.smaller

                onClicked: {
                    if (root.session.network.active)
                        root.session.network.active = null;
                    else {
                        root.session.network.active = root.view.model.get(0)?.modelData ?? null;
                    }
                }
            }
        }
    }

    delegate: Component {
        StyledRect {
            id: networkItem

            required property var modelData

            width: ListView.view ? ListView.view.width : undefined
            implicitHeight: rowLayout.implicitHeight + Tokens.padding.normal * 2

            color: Qt.alpha(Colours.tPalette.m3surfaceContainer, root.activeItem === modelData ? Colours.tPalette.m3surfaceContainer.a : 0)
            radius: Tokens.rounding.normal

            StateLayer {
                onClicked: {
                    root.session.network.active = networkItem.modelData;
                    if (networkItem.modelData && networkItem.modelData.ssid) {
                        root.checkSavedProfileForNetwork(networkItem.modelData.ssid);
                    }
                }
            }

            RowLayout {
                id: rowLayout

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Tokens.padding.normal

                spacing: Tokens.spacing.normal

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: icon.implicitHeight + Tokens.padding.normal * 2

                    radius: Tokens.rounding.normal
                    color: networkItem.modelData.active ? Colours.palette.m3primaryContainer : Colours.tPalette.m3surfaceContainerHigh

                    MaterialIcon {
                        id: icon

                        anchors.centerIn: parent
                        text: Icons.getNetworkIcon(networkItem.modelData.strength, networkItem.modelData.isSecure)
                        font.pointSize: Tokens.font.size.large
                        fill: networkItem.modelData.active ? 1 : 0
                        color: networkItem.modelData.active ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        maximumLineCount: 1

                        text: networkItem.modelData.ssid || qsTr("Unknown")
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.smaller

                        StyledText {
                            Layout.fillWidth: true
                            text: {
                                if (networkItem.modelData.active)
                                    return qsTr("Connected");
                                if (networkItem.modelData.isSecure && networkItem.modelData.security && networkItem.modelData.security.length > 0) {
                                    return networkItem.modelData.security;
                                }
                                if (networkItem.modelData.isSecure)
                                    return qsTr("Secured");
                                return qsTr("Open");
                            }
                            color: networkItem.modelData.active ? Colours.palette.m3primary : Colours.palette.m3outline
                            font.pointSize: Tokens.font.size.small
                            font.weight: networkItem.modelData.active ? 500 : 400
                            elide: Text.ElideRight
                        }
                    }
                }

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: connectIcon.implicitHeight + Tokens.padding.smaller * 2

                    radius: Tokens.rounding.full
                    color: Qt.alpha(Colours.palette.m3primaryContainer, networkItem.modelData.active ? 1 : 0)

                    StateLayer {
                        onClicked: {
                            if (networkItem.modelData.active) {
                                Nmcli.disconnectFromNetwork();
                            } else {
                                NetworkConnection.handleConnect(networkItem.modelData, root.session, null);
                            }
                        }
                    }

                    MaterialIcon {
                        id: connectIcon

                        anchors.centerIn: parent
                        text: networkItem.modelData.active ? "link_off" : "link"
                        color: networkItem.modelData.active ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                    }
                }
            }
        }
    }

    onItemSelected: function (item) {
        session.network.active = item;
        if (item && item.ssid) {
            checkSavedProfileForNetwork(item.ssid);
        }
    }
}
