import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: library
    color: "#1a202c"
    border.color: "#2d3748"
    border.width: 1

    property var bookModel: ListModel {}

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Button {
            id: addButton
            text: qsTr("Add PDFs")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            onClicked: fileDialog.open()

            background: Rectangle {
                color: parent.down ? "#4f46e5" : "#4f46e580"
                radius: 3
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: bookList
                model: bookModel
                spacing: 5
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    width: bookList.width
                    height: 60
                    color: ListView.isCurrentItem ? "#4f46e5" : "transparent"
                    radius: 3

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10

                        Image {
                            source: "qrc:/resources/icons/pdf-icon.png"
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: title
                                color: "white"
                                font.bold: true
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: author || "Unknown author"
                                color: "#a0aec0"
                                font.pixelSize: 12
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            bookList.currentIndex = index
                            pdfViewer.loadPdf(path)
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Select PDF files")
        nameFilters: ["PDF files (*.pdf)"]
        selectMultiple: true
        onAccepted: {
            for (var i = 0; i < fileDialog.selectedFiles.length; i++) {
                var filePath = fileDialog.selectedFiles[i]
                if (pythonBridge.add_pdf(filePath)) {
                    bookModel.append({
                        "title": filePath.split("/").pop(),
                        "path": filePath,
                        "author": ""
                    })
                }
            }
        }
    }

    Component.onCompleted: {
        // Load initial book collection
        // This could be replaced with loading from database
        bookModel.append({
            "title": "Sample PDF",
            "path": "sample.pdf",
            "author": "Test Author"
        })
    }
}