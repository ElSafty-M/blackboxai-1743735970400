cmake_minimum_required(VERSION 3.16)
project(PDFSearchApp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Qml WebEngineQuick)

# Python integration
find_package(Python3 COMPONENTS Interpreter Development REQUIRED)

# Add executable
qt_add_executable(PDFSearchApp
    main.cpp
    backend/PythonBridge.py
)

# Include Python modules
target_link_libraries(PDFSearchApp PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Qml
    Qt6::WebEngineQuick
    Python3::Python
)

# Install resources
qt_add_resources(PDFSearchApp "qml"
    PREFIX "/"
    FILES
        qml/MainWindow.qml
        qml/SearchBar.qml
        qml/PdfViewer.qml
        qml/BookLibrary.qml
        qml/MetadataPanel.qml
)

# Install icons
qt_add_resources(PDFSearchApp "icons"
    PREFIX "/resources/icons"
    FILES
        resources/icons/app-icon.png
        resources/icons/pdf-icon.png
        resources/icons/language.png
)