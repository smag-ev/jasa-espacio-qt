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

    // ==========================================
    // SCORE HELPERS
    // ==========================================
    function ratingText(score) {
        if (score < 0.33) return "BAD"
        if (score < 0.67) return "MODERATE"
        return "BEST"
    }

    function ratingColor(score) {
        if (score < 0.33) return "#dd3311"
        if (score < 0.67) return "#cc8800"
        return "#00cc88"
    }

    // ==========================================
    // BACKGROUND
    // ==========================================
    Image {
        id: bgImage
        anchors.fill: parent
        source: "Images/stargazeWeatherBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: 0.75
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
    }

    // ==========================================
    // REFRESH TIMER  (every 5 minutes)
    // ==========================================
    Timer {
        interval: 300000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: stargazeBackend.fetchData()
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
    // LEFT PANEL — WEATHER DATA CARD
    // ==========================================
    Rectangle {
        id: leftPanel
        clip: true

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.052
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 10

        width:  Math.min(parent.width * 0.295, 348)
        height: Math.min(parent.height * 0.83, 530)

        color: "#cc120524"
        radius: 18
        border.color: "#442a1a44"
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
                NumberAnimation { to: leftPanel.height; duration: 3200; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0; duration: 0 }
                PauseAnimation  { duration: 1200 }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 26
            spacing: 0

            Text {
                text: "LOCATION"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 6 }

            Text {
                text: stargazeBackend.cityName
                color: "#ffffff"
                font.pixelSize: 26
                font.family: "Century Gothic"
                font.bold: true
                width: leftPanel.width - 52
                wrapMode: Text.WordWrap
            }

            Item { width: 1; height: 14 }
            Rectangle { width: leftPanel.width - 52; height: 1; color: "#333333" }
            Item { width: 1; height: 16 }

            Text {
                text: "CONDITIONS"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            Row {
                width: leftPanel.width - 52; height: 36; spacing: 0
                Text { text: stargazeBackend.conditionIcon; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Sky"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: stargazeBackend.condition; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; height: parent.height; width: parent.width - 108; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            }

            Item { width: 1; height: 8 }

            Row {
                width: leftPanel.width - 52; height: 36; spacing: 0
                Text { text: "◉"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "AQI"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Row {
                    height: parent.height; width: parent.width - 108; spacing: 8
                    Text { text: stargazeBackend.aqi; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "· " + stargazeBackend.aqiLabel; color: "#888888"; font.pixelSize: 12; font.family: "Century Gothic"; anchors.verticalCenter: parent.verticalCenter }
                }
            }

            Item { width: 1; height: 18 }
            Rectangle { width: leftPanel.width - 52; height: 1; color: "#333333" }
            Item { width: 1; height: 16 }

            Text {
                text: "LIGHT POLLUTION"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            Row {
                width: leftPanel.width - 52; height: 36; spacing: 0
                Text { text: "★"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 22; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Text { text: "Bortle"; color: "#aaaaaa"; font.pixelSize: 13; font.family: "Century Gothic"; width: 86; height: parent.height; verticalAlignment: Text.AlignVCenter }
                Row {
                    height: parent.height; width: parent.width - 108; spacing: 8
                    Text { text: "Class " + stargazeBackend.bortle; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.family: "Century Gothic"; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "· " + stargazeBackend.bortleDesc; color: "#888888"; font.pixelSize: 12; font.family: "Century Gothic"; anchors.verticalCenter: parent.verticalCenter; elide: Text.ElideRight; width: 100 }
                }
            }

            Item { width: 1; height: 20 }
            Rectangle { width: leftPanel.width - 52; height: 1; color: "#333333" }
            Item { width: 1; height: 14 }

            Row {
                spacing: 7
                Rectangle {
                    width: 6; height: 6; radius: 3
                    color: stargazeBackend.loading ? "#888888" : "#00ff88"
                    anchors.verticalCenter: parent.verticalCenter
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.2; duration: 900; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                    }
                }
                Text {
                    text: stargazeBackend.loading ? "Fetching data..." : "Open-Meteo · LightPollutionMap · IPInfo"
                    color: "#777777"; font.pixelSize: 10; font.family: "Century Gothic"; font.letterSpacing: 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // ==========================================
    // RIGHT AREA — STARGAZE METER
    // ==========================================
    Item {
        id: meterArea
        anchors.left: leftPanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        property real meterBarWidth: Math.min(width * 0.62, 750)

        Column {
            anchors.centerIn: parent
            spacing: 0

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter
                text: "STARGAZE METER"
                color: "#888888"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 22 }

            // Large rating label
            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter
                text: stargazeBackend.loading ? "LOADING" : mainCanvas.ratingText(stargazeBackend.stargazeScore)
                color: stargazeBackend.loading ? "#444444" : mainCanvas.ratingColor(stargazeBackend.stargazeScore)
                font.pixelSize: 44
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 4
                Behavior on color { ColorAnimation { duration: 900 } }

                SequentialAnimation on opacity {
                    running: stargazeBackend.loading
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.25; duration: 650; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.00; duration: 650; easing.type: Easing.InOutSine }
                }
            }

            Item { width: 1; height: 5 }

            // Score percentage sub-label
            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter
                text: stargazeBackend.loading
                    ? "Calculating conditions..."
                    : Math.round(stargazeBackend.stargazeScore * 100) + "% Stargazing Potential"
                color: "#555555"
                font.pixelSize: 13
                font.family: "Century Gothic"
                font.letterSpacing: 0.5
            }

            Item { width: 1; height: 30 }

            // ---- THE BAR ----
            Item {
                id: meterContainer
                width: meterArea.meterBarWidth
                height: 60

                // Zone boundary tick marks above the bar
                Rectangle { x: meterArea.meterBarWidth * 0.33 - 1; y: 2; width: 2; height: 10; color: "#252525" }
                Rectangle { x: meterArea.meterBarWidth * 0.67 - 1; y: 2; width: 2; height: 10; color: "#252525" }

                // Track
                Rectangle {
                    id: meterTrack
                    width: parent.width
                    height: 22
                    radius: 11
                    anchors.bottom: parent.bottom
                    clip: true
                    color: "transparent"

                    // Full-spectrum gradient — always rendered, dim (shows the scale)
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.00; color: "#aacc1100" }
                            GradientStop { position: 0.45; color: "#aacc8800" }
                            GradientStop { position: 1.00; color: "#aa00bb77" }
                        }
                    }

                    // Dark overlay recedes rightward as score increases
                    Rectangle {
                        id: darkOverlay
                        height: parent.height
                        color: "#dd050508"
                        x: meterArea.meterBarWidth * stargazeBackend.stargazeScore
                        width: parent.width - x
                        Behavior on x { NumberAnimation { duration: 1400; easing.type: Easing.OutCubic } }
                    }

                    // Shimmer — slides across the lit portion on a loop
                    Rectangle {
                        id: shimmer
                        width: 22; height: parent.height
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "transparent"  }
                            GradientStop { position: 0.5; color: "#1effffff"    }
                            GradientStop { position: 1.0; color: "transparent"  }
                        }
                        x: -width
                        SequentialAnimation on x {
                            loops: Animation.Infinite
                            PauseAnimation  { duration: 1800 }
                            NumberAnimation {
                                to: meterArea.meterBarWidth * stargazeBackend.stargazeScore
                                duration: 1000
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation { to: -shimmer.width; duration: 0 }
                        }
                    }
                }

                // Needle
                Rectangle {
                    id: meterNeedle
                    width: 3; height: 38; radius: 2
                    color: "white"
                    anchors.bottom: meterTrack.bottom
                    anchors.bottomMargin: -5
                    x: (meterArea.meterBarWidth * stargazeBackend.stargazeScore) - 1.5
                    Behavior on x { NumberAnimation { duration: 1400; easing.type: Easing.OutCubic } }

                    // Glow pip — pulses faster + brighter at higher scores
                    Rectangle {
                        width: 10; height: 10; radius: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top; anchors.topMargin: -4
                        color: mainCanvas.ratingColor(stargazeBackend.stargazeScore)
                        Behavior on color { ColorAnimation { duration: 900 } }

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 0.15
                                duration: 350 + (1.0 - stargazeBackend.stargazeScore) * 1000
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                to: 1.0
                                duration: 350 + (1.0 - stargazeBackend.stargazeScore) * 1000
                                easing.type: Easing.InOutSine
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 10 }

            // Zone labels
            Item {
                width: meterArea.meterBarWidth
                height: 18
                Text { anchors.left: parent.left; text: "BAD"; color: "#cc4422"; opacity: 0.65; font.pixelSize: 10; font.family: "Century Gothic"; font.bold: true; font.letterSpacing: 1.5 }
                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "MODERATE"; color: "#cc8800"; opacity: 0.65; font.pixelSize: 10; font.family: "Century Gothic"; font.bold: true; font.letterSpacing: 1.5 }
                Text { anchors.right: parent.right; text: "BEST"; color: "#00cc88"; opacity: 0.65; font.pixelSize: 10; font.family: "Century Gothic"; font.bold: true; font.letterSpacing: 1.5 }
            }

            Item { width: 1; height: 26 }

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter
                text: stargazeBackend.loading ? "" : stargazeBackend.insight
                color: mainCanvas.ratingColor(stargazeBackend.stargazeScore)
                opacity: 0.72
                font.pixelSize: 13
                font.family: "Century Gothic"
                font.letterSpacing: 0.4
                wrapMode: Text.WordWrap
                Behavior on color { ColorAnimation { duration: 900 } }
            }
        }
    }
}
