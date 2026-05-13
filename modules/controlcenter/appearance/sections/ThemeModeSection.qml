pragma ComponentBehavior: Bound

import QtQuick
import qs.components.controls
import qs.services

CollapsibleSection {
    title: qsTr("Theme mode")
    description: qsTr("Light or dark theme")
    showBackground: true

    SwitchRow {
        label: qsTr("Dark mode")
        checked: !Colours.currentLight
        onToggled: checked => {
            Colours.setMode(checked ? "dark" : "light");
        }
    }
}
