import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: searchBar
    height: 50
    radius: 5
    color: "#2d3748"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: qsTr("Search...")
            color: "white"
            font.pixelSize: 16
            background: Rectangle {
                color: "transparent"
                border.width: 0
            }

            onTextChanged: {
                if (text.length > 2) {
                    pythonBridge.search(text)
                }
            }
        }

        Button {
            text: qsTr("Advanced")
            onClicked: advancedSearchPopup.open()
            background: Rectangle {
                color: parent.down ? "#4f46e5" : "#4f46e580"
                radius: 3
            }
        }

        Button {
            icon.source: "qrc:/resources/icons/language.png"
            onClicked: root.isArabic = !root.isArabic
            ToolTip.text: qsTr("Toggle Arabic/English")
            background: Rectangle {
                color: "transparent"
            }
        }
    }

    Popup {
        id: advancedSearchPopup
        width: 300
        height: 200
        x: (parent.width - width) / 2
        y: searchBar.height + 5
        modal: true
        focus: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            CheckBox {
                text: qsTr("Regex Search")
                checked: false
                onCheckedChanged: pythonBridge.setRegexMode(checked)
            }

            CheckBox {
                text: qsTr("Search in Arabic only")
                checked: false
                onCheckedChanged: pythonBridge.setArabicOnly(checked)
            }

            Button {
                text: qsTr("Apply")
                onClicked: advancedSearchPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}