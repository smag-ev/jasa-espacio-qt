import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: mainCanvas
    color: "#000000"
    width: 1280
    height: 720

    Binding on width {
        value: parent ? parent.width : 1280
        restoreMode: Binding.RestoreBindingOrValue
    }
    Binding on height {
        value: parent ? parent.height : 720
        restoreMode: Binding.RestoreBindingOrValue
    }

    property int currentIndex: 0

    // ==========================================
    // BACKGROUND
    // ==========================================
    Image {
        id: bgImage
        anchors.fill: parent
        source: "Images/stargazePlacesBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: 0.6
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
    }

    // ==========================================S
    // NAVIGATION BUTTONS
    // ==========================================
    Button {
        id: backButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        width: 100
        height: 40
        flat: true
        down: false

        scale: pressed ? 0.9 : (hovered ? 1.05 : 1.0)
        Behavior on scale { NumberAnimation { duration: 150 } }

        contentItem: Text {
            text: "❮ Back"
            color: "white"
            font.pixelSize: 16
            font.family: "Century Gothic"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 20
            color: backButton.hovered ? "#33ffffff" : "transparent"
            border.color: "#55ffffff"
        }
        onClicked: { closePageTransition(); stackView.replace("MenuPage.qml") }
    }

    Button {
        id: leftArrow
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        width: 60
        height: 60
        flat: true
        down: false

        scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)
        Behavior on scale { NumberAnimation { duration: 150 } }

        contentItem: Text {
            text: "❮"
            color: "white"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 30
            color: leftArrow.hovered ? "#66000000" : "#33000000"
            border.color: "#88ffffff"
        }
        onClicked: currentIndex = (currentIndex === 0) ? 2 : currentIndex - 1
    }

    Button {
        id: rightArrow
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        width: 60
        height: 60
        flat: true
        down: false

        scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)
        Behavior on scale { NumberAnimation { duration: 150 } }

        contentItem: Text {
            text: "❯"
            color: "white"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 30
            color: rightArrow.hovered ? "#66000000" : "#33000000"
            border.color: "#88ffffff"
        }
        onClicked: currentIndex = (currentIndex === 2) ? 0 : currentIndex + 1
    }

    // ==========================================
    // PAGE 1: DEOSAI
    // ==========================================
    RowLayout {
        id: page1Deosai
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: dots.top
        anchors.left: leftArrow.right
        anchors.right: rightArrow.left
        anchors.margins: 40
        spacing: 50

        opacity: currentIndex === 0 ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

        Image {
            id: deosaiImage
            source: "Images/deosaiImage.jpg"
            fillMode: Image.PreserveAspectCrop

            Layout.fillHeight: true
            Layout.preferredWidth: height * (4/3)
            Layout.maximumWidth: parent.width * 0.55

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: maskItem
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 15

            Text {
                Layout.fillWidth: true
                text: "Deosai National Park"
                color: "white"
                font.pixelSize: Math.min(parent.width * 0.1, 40)
                font.family: "Century Gothic"
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#44ffffff"
            }
            Text {
                Layout.fillWidth: true
                text: "Known as the 'Land of Giants', this high-altitude alpine plateau offers pristine, pitch-black skies completely free from urban light pollution, making the Milky Way incredibly vibrant to the naked eye.\n\n• Bortle Scale: Class 1 (Excellent Dark-Sky Site)\n\n• Elevation: 4,114 meters (13,497 ft)"
                color: "#cccccc"
                font.pixelSize: Math.min(parent.width * 0.04, 20)
                font.family: "Century Gothic"
                wrapMode: Text.WordWrap
                lineHeight: 1.4
            }
        }
    }

    // ==========================================
    // PAGE 2: TAQWA
    // ==========================================
    RowLayout {
        id: page2Taqwa
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: dots.top
        anchors.left: leftArrow.right
        anchors.right: rightArrow.left
        anchors.margins: 40
        spacing: 50

        opacity: currentIndex === 1 ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

        Image {
            id: taqwaImage
            source: "Images/taqwaLabImage.jpg"
            fillMode: Image.PreserveAspectCrop

            Layout.fillHeight: true
            Layout.preferredWidth: height * (4/3)
            Layout.maximumWidth: parent.width * 0.55

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: maskItem
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 15

            Text {
                Layout.fillWidth: true
                text: "Taqwa Space Observatory"
                color: "white"
                font.pixelSize: Math.min(parent.width * 0.1, 48)
                font.family: "Century Gothic"
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#44ffffff"
            }
            Text {
                Layout.fillWidth: true
                text: "Pakistan's premier dedicated dark-sky site located in the isolated, arid expanses of Balochistan. It provides amateur and professional astrophotographers with impeccable atmospheric seeing conditions for deep-space observation.\n\n• Bortle Scale: Class 1-2 (Truly Dark Site)\n\n• Primary Focus: Deep-Sky Astrophotography"
                color: "#cccccc"
                font.pixelSize: Math.min(parent.width * 0.04, 20)
                font.family: "Century Gothic"
                wrapMode: Text.WordWrap
                lineHeight: 1.4
            }
        }
    }

    // ==========================================
    // PAGE 3: CHOLISTAN
    // ==========================================
    RowLayout {
        id: page3Cholistan
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: dots.top
        anchors.left: leftArrow.right
        anchors.right: rightArrow.left
        anchors.margins: 40
        spacing: 50

        opacity: currentIndex === 2 ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

        Image {
            id: cholistanImage
            source: "Images/cholistanImage.jpg"
            fillMode: Image.PreserveAspectCrop

            Layout.fillHeight: true
            Layout.preferredWidth: height * (4/3)
            Layout.maximumWidth: parent.width * 0.55

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: maskItem
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 15

            Text {
                Layout.fillWidth: true
                text: "Cholistan Desert"
                color: "white"
                font.pixelSize: Math.min(parent.width * 0.1, 48)
                font.family: "Century Gothic"
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#44ffffff"
            }
            Text {
                Layout.fillWidth: true
                text: "A sprawling, silent desert landscape offering an uninterrupted 360-degree view of the cosmos. The incredibly dry atmosphere and lack of cloud cover during winter nights create mesmerizing, crystal-clear stargazing conditions.\n\n• Bortle Scale: Class 2 (Average Dark Sky)\n\n• Best Time to Visit: November to March (Winter Months)"
                color: "#cccccc"
                font.pixelSize: Math.min(parent.width * 0.04, 20)
                font.family: "Century Gothic"
                wrapMode: Text.WordWrap
                lineHeight: 1.4
            }
        }
    }

    // ==========================================
    // BOTTOM DOTS
    // ==========================================
    Row {
        id: dots
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        Repeater {
            model: 3
            Rectangle {
                width: currentIndex === index ? 30 : 10
                height: 10
                radius: 5
                color: currentIndex === index ? "#ffffff" : "#55ffffff"

                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }
    }

    Item {
        id: maskItem
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            anchors.fill: parent
            radius: 30
            color: "black"
        }
    }
}
