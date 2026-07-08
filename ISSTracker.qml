import QtQuick
import QtQuick.Controls

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

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: issBackend.fetchLiveLocation()
    }

    // ==========================================
    // BACKGROUND
    // ==========================================
    Image {
        id: bgImage
        anchors.fill: parent
        source: "Images/issTrackerBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: 0.8
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
    }

    // ==========================================
    // BACK BUTTON
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
        onClicked: {
            closePageTransition()
            stackView.replace("MenuPage.qml")
        }
    }

    // ==========================================
    // LIVE DATA CARD
    // ==========================================
    Rectangle {
        id: dataPanel
        clip: true

        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.052
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 10

        width:  Math.min(parent.width * 0.295, 348)
        height: Math.min(parent.height * 0.83, 530)

        color: "#b30a0a0a"
        radius: 18
        border.color: "#333333"
        border.width: 1

        Rectangle {
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height: 3
            radius: 18
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.4; color: "#777777"     }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            id: scanLine
            anchors.left:  parent.left
            anchors.right: parent.right
            height: 1
            color: "#18ffffff"
            y: 0

            SequentialAnimation on y {
                loops: Animation.Infinite
                NumberAnimation { to: dataPanel.height; duration: 3200; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0;                duration: 0                                   }
                PauseAnimation  { duration: 1200                                                      }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 26
            spacing: 0

            Text {
                text: "CURRENTLY ABOVE"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 6 }

            Text {
                id: countryText
                text: issBackend.country
                color: "#ffffff"
                font.pixelSize: 26
                font.family: "Century Gothic"
                font.bold: true
                width: dataPanel.width - 52
                wrapMode: Text.WordWrap
            }

            Item { width: 1; height: 14 }

            Rectangle {
                width: dataPanel.width - 52
                height: 1
                color: "#333333"
            }

            Item { width: 1; height: 16 }

            Text {
                text: "COORDINATES"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            Row {
                width: dataPanel.width - 52
                height: 36
                spacing: 0

                Text { text: "◈"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Latitude"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: issBackend.latitude + " °"; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; height: parent.height; width: parent.width - 108; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            }

            Item { width: 1; height: 8 }

            Row {
                width: dataPanel.width - 52
                height: 36
                spacing: 0

                Text { text: "◈"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Longitude"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: issBackend.longitude + " °"; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; height: parent.height; width: parent.width - 108; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            }

            Item { width: 1; height: 18 }

            Rectangle {
                width: dataPanel.width - 52
                height: 1
                color: "#333333"
            }

            Item { width: 1; height: 16 }

            Text {
                text: "ORBITAL DATA"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            Row {
                width: dataPanel.width - 52
                height: 36
                spacing: 0

                Text { text: "△"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Altitude"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: issBackend.altitude + " km"; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; height: parent.height; width: parent.width - 108; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            }

            Item { width: 1; height: 8 }

            Row {
                width: dataPanel.width - 52
                height: 36
                spacing: 0

                Text { text: "➤"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Velocity"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: issBackend.velocity + " km/h"; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; height: parent.height; width: parent.width - 108; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            }

            Item { width: 1; height: 20 }

            Rectangle {
                width: dataPanel.width - 52
                height: 1
                color: "#333333"
            }

            Item { width: 1; height: 14 }

            Row {
                spacing: 7

                Rectangle {
                    width: 6; height: 6; radius: 3
                    color: "#00ff88"
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.2; duration: 900; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                    }
                }

                Text {
                    text: "WhereTheISSAt? · OpenStreetMap"
                    color: "#777777"
                    font.pixelSize: 10
                    font.family: "Century Gothic"
                    font.letterSpacing: 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
