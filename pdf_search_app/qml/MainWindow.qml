import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true
    width: 1024
    height: 768
    title: qsTr("PDF Search App")

    // Theme properties
    property color backgroundColor: "#1e1e2e"
    property color textColor: "#ffffff"
    property color accentColor: "#4f46e5"

    // RTL support
    property bool isArabic: false
    LayoutMirroring.enabled: isArabic
    LayoutMirroring.childrenInherit: true

    // Main layout
    RowLayout {
        anchors.fill: parent
        spacing: 10

        // Left panel - Book library
        BookLibrary {
            Layout.preferredWidth: parent.width * 0.25
            Layout.fillHeight: true
        }

        // Center panel - PDF viewer and search results
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            SearchBar {
                Layout.fillWidth: true
            }

            PdfViewer {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        // Right panel - Metadata editor
        MetadataPanel {
            Layout.preferredWidth: parent.width * 0.25
            Layout.fillHeight: true
        }
    }
}