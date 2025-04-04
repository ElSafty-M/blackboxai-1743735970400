import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: metadataPanel
    color: "#1a202c"
    border.color: "#2d3748"
    border.width: 1

    property string currentPdf: ""
    property var currentMetadata: ({})

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: qsTr("Document Metadata")
            color: "white"
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            columns: 2
            columnSpacing: 10
            rowSpacing: 10
            Layout.fillWidth: true

            Text {
                text: qsTr("Title:")
                color: "white"
            }
            TextField {
                id: titleField
                text: currentMetadata.title || ""
                Layout.fillWidth: true
                color: "white"
                background: Rectangle {
                    color: "#2d3748"
                    radius: 3
                }
            }

            Text {
                text: qsTr("Author:")
                color: "white"
            }
            TextField {
                id: authorField
                text: currentMetadata.author || ""
                Layout.fillWidth: true
                color: "white"
                background: Rectangle {
                    color: "#2d3748"
                    radius: 3
                }
            }

            Text {
                text: qsTr("Keywords:")
                color: "white"
            }
            TextField {
                id: keywordsField
                text: currentMetadata.keywords || ""
                Layout.fillWidth: true
                color: "white"
                background: Rectangle {
                    color: "#2d3748"
                    radius: 3
                }
            }
        }

        Text {
            text: qsTr("Tags:")
            color: "white"
            Layout.topMargin: 10
        }

        Flow {
            id: tagsFlow
            width: parent.width
            spacing: 5

            Repeater {
                model: currentMetadata.tags ? currentMetadata.tags.split(",") : []

                delegate: Rectangle {
                    width: tagText.width + 20
                    height: 30
                    color: "#4f46e5"
                    radius: 15

                    Text {
                        id: tagText
                        text: modelData.trim()
                        color: "white"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Remove tag
                            var tags = currentMetadata.tags.split(",")
                            tags.splice(index, 1)
                            currentMetadata.tags = tags.join(",")
                        }
                    }
                }
            }
        }

        TextField {
            id: newTagField
            placeholderText: qsTr("Add new tag...")
            Layout.fillWidth: true
            color: "white"
            background: Rectangle {
                color: "#2d3748"
                radius: 3
            }

            onAccepted: {
                if (text.trim() !== "") {
                    var tags = currentMetadata.tags ? currentMetadata.tags.split(",") : []
                    tags.push(text.trim())
                    currentMetadata.tags = tags.join(",")
                    text = ""
                }
            }
        }

        Button {
            text: qsTr("Save Changes")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            onClicked: saveMetadata()

            background: Rectangle {
                color: parent.down ? "#4f46e5" : "#4f46e580"
                radius: 3
            }
        }
    }

    function loadMetadata(pdfPath) {
        currentPdf = pdfPath
        // In a real app, this would fetch from database
        currentMetadata = {
            "title": pdfPath.split("/").pop().replace(".pdf", ""),
            "author": "",
            "keywords": "",
            "tags": ""
        }
    }

    function saveMetadata() {
        currentMetadata = {
            "title": titleField.text,
            "author": authorField.text,
            "keywords": keywordsField.text,
            "tags": currentMetadata.tags
        }
        // In a real app, this would save to database
        console.log("Metadata saved for:", currentPdf)
    }

    Connections {
        target: pdfViewer
        function onCurrentPdfChanged() {
            if (pdfViewer.currentPdf !== "") {
                loadMetadata(pdfViewer.currentPdf)
            }
        }
    }
}