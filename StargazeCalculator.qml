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
    function clamp(v, lo, hi) {
        return Math.max(lo, Math.min(hi, v))
    }

    function ratingText(score) {
        if (score < 20) return "WORST"
        if (score < 40) return "BAD"
        if (score < 60) return "JUST OK"
        if (score < 80) return "GOOD"
        return "EXCELLENT"
    }

    function ratingColor(score) {
        if (score < 20) return "#dd3311"
        if (score < 40) return "#cc5500"
        if (score < 60) return "#cc8800"
        if (score < 80) return "#66cc66"
        return "#00cc88"
    }

    function statusLine(score) {
        if (score < 20) return "Heavy light pollution and poor transparency."
        if (score < 40) return "Only the brightest targets will stand out."
        if (score < 60) return "A mixed night with a few good windows."
        if (score < 80) return "A solid sky for deep-sky observing."
        return "Dark, clean, and wide open for stargazing."
    }

    function objectPack(score) {
        if (score < 20) return ["Moon", "Venus", "Jupiter"]
        if (score < 40) return ["Orion Nebula", "Pleiades", "Andromeda Galaxy"]
        if (score < 60) return ["Double Cluster", "Lagoon Nebula", "Hercules Cluster"]
        if (score < 80) return ["Milky Way Core", "Veil Nebula", "North America Nebula"]
        return ["Barnard's Loop", "California Nebula", "Horsehead Nebula"]
    }

    function objectDetail(name, score) {
        if (score < 20) {
            if (name === "Moon") return "Blazing anchor in bright skies"
            if (name === "Venus") return "Easy naked-eye showpiece"
            return "Only a few bright points remain obvious"
        }

        if (score < 40) {
            if (name === "Orion Nebula") return "Best bright nebula target"
            if (name === "Pleiades") return "Compact and obvious cluster"
            return "Large galaxy with strong contrast"
        }

        if (score < 60) {
            if (name === "Double Cluster") return "Classic binocular favorite"
            if (name === "Lagoon Nebula") return "Strong emission target"
            return "Dense cluster with good structure"
        }

        if (score < 80) {
            if (name === "Milky Way Core") return "Richer detail and dust lanes"
            if (name === "Veil Nebula") return "Filament structure becomes visible"
            return "Wide-field nebula with clear outline"
        }

        if (name === "Barnard's Loop") return "Subtle large-scale glow"
        if (name === "California Nebula") return "Excellent dark-sky emission target"
        return "Fine detail on a very dark night"
    }

    function bortleRaw(level) {
        switch (level) {
        case 1: return 100
        case 2: return 88
        case 3: return 74
        case 4: return 58
        case 5: return 42
        case 6: return 26
        case 7: return 15
        case 8: return 7
        case 9: return 2
        default: return 2
        }
    }

    function aqiRaw(aqi) {
        if (aqi <= 50) return 100
        if (aqi <= 100) return 80
        if (aqi <= 150) return 55
        if (aqi <= 200) return 30
        return 8
    }

    function skyRaw(condition) {
        switch (condition) {
        case "Clear": return 100
        case "Mostly Clear": return 85
        case "Partly Cloudy": return 55
        case "Hazy": return 22
        case "Cloudy": return 4
        case "Foggy": return 2
        case "Rainy": return 1
        case "Stormy": return 0
        default: return 100
        }
    }

    function validationScore() {
        var bortle = parseInt(bortleField.text)
        var aqi = parseInt(aqiField.text)

        if (isNaN(bortle) || bortle < 1 || bortle > 9) return 0
        if (isNaN(aqi) || aqi < 0 || aqi > 500) return 0

        var sky = conditionCombo.currentText

        if (sky === "Stormy") return 0
        if (sky === "Rainy") return 3
        if (sky === "Foggy") return 5
        if (sky === "Cloudy") return 8

        var raw = (bortleRaw(bortle) * 0.80)
                + (aqiRaw(aqi) * 0.10)
                + (skyRaw(sky) * 0.10)

        return clamp(raw, 0, 100)
    }

    function scoreText() {
        return ratingText(validationScore())
    }

    function currentObjects() {
        return objectPack(validationScore())
    }

    // ==========================================
    // BACKGROUND
    // ==========================================
    Image {
        id: bgImage
        anchors.fill: parent
        source: "Images/stargazeCalculatorBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: 0.8
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#050306"
        opacity: 0.22
    }

    // ==========================================
    // BACK BUTTON
    // ==========================================
    Button {
        id: backButton
        down: false

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30

        width: 100
        height: 40
        flat: true

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
    // LEFT SIDE — INPUTS
    // ==========================================
    Item {
        id: leftPanel

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.052
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 10

        width: Math.min(parent.width * 0.31, 370)
        height: Math.min(parent.height * 0.83, 530)

        Column {
            anchors.fill: parent
            spacing: 0

            Text {
                text: "INPUTS"
                color: "#ffffff"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 6 }

            Text {
                text: "Stargaze Condition"
                color: "#ffffff"
                font.pixelSize: 28
                font.family: "Century Gothic"
                font.bold: true
                width: leftPanel.width
                wrapMode: Text.WordWrap

                style: Text.Raised
                styleColor: "#99000000"
            }

            Item { width: 1; height: 10 }

            Text {
                text: "Enter the sky inputs and let the night decide."
                color: "#ffffff"
                font.pixelSize: 12
                font.family: "Century Gothic"
                width: leftPanel.width - 20
                wrapMode: Text.WordWrap
                opacity: 0.9

                style: Text.Raised
                styleColor: "#99000000"
            }

            Item { width: 1; height: 24 }

            Text {
                text: "BORTLE SCALE"
                color: "#ffffff"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            TextField {
                id: bortleField
                width: leftPanel.width - 18
                height: 42
                text: "4"

                placeholderText: "1 to 9"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 1; top: 9 }

                font.pixelSize: 15
                font.family: "Century Gothic"

                color: "white"
                leftPadding: 14

                background: Rectangle {
                    radius: 12
                    color: "#22000000"
                    border.color: bortleField.acceptableInput ? "#66ffffff" : "#aadd6633"
                    border.width: 1
                }
            }

            Item { width: 1; height: 8 }

            Text {
                text: bortleField.acceptableInput ? "Valid Bortle class" : "Use a value from 1 through 9"
                color: "#ffffff"
                opacity: 0.9
                font.pixelSize: 11
                font.family: "Century Gothic"
            }

            Item { width: 1; height: 18 }

            Text {
                text: "AQI"
                color: "#ffffff"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            TextField {
                id: aqiField
                width: leftPanel.width - 18
                height: 42
                text: "50"

                placeholderText: "0 to 500"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 500 }

                font.pixelSize: 15
                font.family: "Century Gothic"

                color: "white"
                leftPadding: 14

                background: Rectangle {
                    radius: 12
                    color: "#22000000"
                    border.color: aqiField.acceptableInput ? "#66ffffff" : "#aadd6633"
                    border.width: 1
                }
            }

            Item { width: 1; height: 8 }

            Text {
                text: aqiField.acceptableInput ? "Valid AQI range" : "Use a value from 0 through 500"
                color: "#ffffff"
                opacity: 0.9
                font.pixelSize: 11
                font.family: "Century Gothic"
            }

            Item { width: 1; height: 18 }

            Text {
                text: "SKY STATE"
                color: "#ffffff"
                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 10 }

            ComboBox {
                id: conditionCombo
                width: leftPanel.width - 18
                height: 42

                model: ["Clear", "Mostly Clear", "Partly Cloudy", "Hazy", "Cloudy", "Foggy", "Rainy", "Stormy"]
                currentIndex: 0

                font.pixelSize: 14
                font.family: "Century Gothic"

                background: Rectangle {
                    radius: 10
                    color: "#2f000000"
                    border.color: "#55ffffff"
                    border.width: 1
                }

                contentItem: Text {
                    text: conditionCombo.displayText
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.family: "Century Gothic"
                    verticalAlignment: Text.AlignVCenter

                    leftPadding: 14
                }

                popup: Popup {
                    y: conditionCombo.height + 4
                    width: conditionCombo.width
                    padding: 2

                    height: Math.min(200, contentItem.implicitHeight)

                    enter: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 180
                        }
                    }

                    background: Rectangle {
                        radius: 10
                        color: "#33000000"
                        border.color: "#44ffffff"
                        border.width: 1
                    }

                    contentItem: ListView {
                        implicitHeight: contentHeight
                        clip: true
                        model: conditionCombo.popup.visible ? conditionCombo.model : []

                        delegate: ItemDelegate {
                            width: conditionCombo.width
                            height: 34

                            hoverEnabled: true

                            contentItem: Text {
                                text: modelData
                                color: "#ffffff"
                                font.pixelSize: 13
                                font.family: "Century Gothic"
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? "#1affffff" : "transparent"

                                Behavior on color {
                                    ColorAnimation { duration: 120 }
                                }
                            }

                            onClicked: {
                                conditionCombo.currentIndex = index
                                conditionCombo.popup.close()
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 18 }

            Rectangle {
                width: leftPanel.width - 18
                height: 1
                color: "#33ffffff"
            }

            Item { width: 1; height: 16 }

            Row {
                spacing: 7

                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: bortleField.acceptableInput && aqiField.acceptableInput ? "#00ff88" : "#ff9966"

                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite

                        NumberAnimation {
                            to: 0.2
                            duration: 900
                            easing.type: Easing.InOutSine
                        }

                        NumberAnimation {
                            to: 1.0
                            duration: 900
                            easing.type: Easing.InOutSine
                        }
                    }
                }

                Text {
                    text: bortleField.acceptableInput && aqiField.acceptableInput
                          ? "Ready for scoring"
                          : "Waiting for valid input"

                    color: "#ffffff"
                    opacity: 0.75

                    font.pixelSize: 10
                    font.family: "Century Gothic"
                    font.letterSpacing: 0.5

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // ==========================================
    // RIGHT SIDE — RESULTS
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
                text: "STARGAZE CONDITION"
                color: "#ffffff"

                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 20 }

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter

                text: mainCanvas.scoreText()
                color: mainCanvas.ratingColor(mainCanvas.validationScore())

                font.pixelSize: 46
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 4

                style: Text.Raised
                styleColor: "#aa000000"

                Behavior on color {
                    ColorAnimation { duration: 900 }
                }
            }

            Item { width: 1; height: 6 }

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter

                text: Math.round(mainCanvas.validationScore()) + "% Stargazing Potential"
                color: mainCanvas.ratingColor(mainCanvas.validationScore())

                font.pixelSize: 13
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 0.5
            }

            Item { width: 1; height: 12 }

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter

                text: mainCanvas.statusLine(mainCanvas.validationScore())
                color: "#ffffff"

                font.pixelSize: 14
                font.family: "Century Gothic"
                font.letterSpacing: 0.3
                wrapMode: Text.WordWrap
                opacity: 0.92

                style: Text.Raised
                styleColor: "#99000000"
            }

            Item { width: 1; height: 28 }

            Rectangle {
                width: meterArea.meterBarWidth
                height: 1
                color: "#2dffffff"
            }

            Item { width: 1; height: 22 }

            Text {
                width: meterArea.meterBarWidth
                horizontalAlignment: Text.AlignHCenter

                text: "TOP OBJECTS"
                color: "#ffffff"

                font.pixelSize: 10
                font.family: "Century Gothic"
                font.bold: true
                font.letterSpacing: 2.5
            }

            Item { width: 1; height: 18 }

            Row {
                width: meterArea.meterBarWidth
                spacing: 12

                Repeater {
                    model: 3

                    Rectangle {
                        width: (meterArea.meterBarWidth - 24) / 3
                        height: 128
                        radius: 16

                        color: "#150d0d12"
                        border.color: "#2fdddddd"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 6

                            Text {
                                text: mainCanvas.currentObjects()[index]
                                color: "#ffffff"

                                font.pixelSize: 16
                                font.family: "Century Gothic"
                                font.bold: true

                                width: parent.width
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                text: mainCanvas.ratingText(mainCanvas.validationScore())
                                color: mainCanvas.ratingColor(mainCanvas.validationScore())

                                font.pixelSize: 10
                                font.family: "Century Gothic"
                                font.bold: true
                                font.letterSpacing: 1.5
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#2cffffff"
                            }

                            Text {
                                text: mainCanvas.objectDetail(
                                          mainCanvas.currentObjects()[index],
                                          mainCanvas.validationScore())

                                color: "#ffffff"
                                opacity: 0.82

                                font.pixelSize: 11
                                font.family: "Century Gothic"

                                width: parent.width
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
