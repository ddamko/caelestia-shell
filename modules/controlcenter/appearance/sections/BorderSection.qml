pragma ComponentBehavior: Bound

import "../../components"
import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls

CollapsibleSection {
    id: root

    required property var rootPane

    title: qsTr("Border")
    showBackground: true

    SectionContainer {
        contentSpacing: Tokens.spacing.normal

        SliderInput {
            Layout.fillWidth: true

            label: qsTr("Border rounding")
            value: root.rootPane.borderRounding
            from: 0.1
            to: 100
            decimals: 1
            suffix: "px"
            validator: DoubleValidator {
                bottom: 0.1
                top: 100
            }

            onValueModified: newValue => {
                root.rootPane.borderRounding = newValue;
                root.rootPane.saveConfig();
            }
        }
    }

    SectionContainer {
        contentSpacing: Tokens.spacing.normal

        SliderInput {
            Layout.fillWidth: true

            label: qsTr("Border thickness")
            value: root.rootPane.borderThickness
            from: 0
            to: 100
            decimals: 1
            suffix: "px"
            validator: DoubleValidator {
                bottom: 0.1
                top: 100
            }

            onValueModified: newValue => {
                root.rootPane.borderThickness = newValue;
                root.rootPane.saveConfig();
            }
        }
    }
}
