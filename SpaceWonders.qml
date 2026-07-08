import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia

Rectangle {
    id: mainCanvas
    color: "#000000"
    width: 1280
    height: 720

    MediaPlayer {
        id: backgroundMusic
        audioOutput: AudioOutput {
            id: audioOut
            volume: 0.0

            Behavior on volume {
                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
            }
        }
        source: "Audio/spaceWondersBG.mp3"
        loops: MediaPlayer.Infinite
    }

    Component.onCompleted: {
        backgroundMusic.play()
        audioOut.volume = 0.7
    }

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
    // BACKGROUNDS
    // ==========================================
    Image {
        id: bgBlackHole
        anchors.fill: parent
        source: "Images/blackHoleImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: currentIndex === 0 ? 0.8 : 0.0
        fillMode: Image.PreserveAspectCrop
        Behavior on opacity { NumberAnimation { duration: 800; easing.type: Easing.InOutQuad } }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#CC000000" } // Dark edges
                GradientStop { position: 0.5; color: "transparent" } // Clear center
                GradientStop { position: 1.0; color: "#CC000000" } // Dark bottom
            }
        }
    }

    Image {
        id: bgNebulae
        anchors.fill: parent
        source: "Images/nebulaImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: currentIndex === 1 ? 0.8 : 0.0
        fillMode: Image.PreserveAspectCrop
        Behavior on opacity { NumberAnimation { duration: 800; easing.type: Easing.InOutQuad } }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#CC000000" } // Dark edges
                GradientStop { position: 0.5; color: "transparent" } // Clear center
                GradientStop { position: 1.0; color: "#CC000000" } // Dark bottom
            }
        }
    }

    Image {
        id: bgGalaxies
        anchors.fill: parent
        source: "Images/galaxyImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: currentIndex === 2 ? 0.8 : 0.0
        fillMode: Image.PreserveAspectCrop
        Behavior on opacity { NumberAnimation { duration: 800; easing.type: Easing.InOutQuad } }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#CC000000" } // Dark edges
                GradientStop { position: 0.5; color: "transparent" } // Clear center
                GradientStop { position: 1.0; color: "#CC000000" } // Dark bottom
            }
        }
    }

    // ==========================================
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
        onClicked: {
            audioOut.volume = 0.0
            closePageTransition()
            stackView.replace("MenuPage.qml")
        }
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
    // PAGE 1: BLACK HOLES
    // ==========================================
    Item {
        id: page1BlackHoles
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110

        property bool isActive: currentIndex === 0
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        // Title
        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Supermassive Black Holes"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 48)
            font.family: "Century Gothic"
            font.bold: true
        }

        // Block 1: Left (A little below center)
        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.35
            text: "A region of spacetime where gravity is so relentlessly strong that nothing—no particles, no planets, and not even light—can escape its grasp."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5

            transform: Translate {
                x: page1BlackHoles.isActive ? 0 : -800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 2: Right (A little above center)
        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -75
            width: parent.width * 0.35
            text: "The theory of general relativity predicts that a sufficiently compact mass can deform the very fabric of spacetime itself."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5
            horizontalAlignment: Text.AlignRight

            transform: Translate {
                x: page1BlackHoles.isActive ? 0 : 800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 3: Bottom (A bit right of middle)
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset:200
            width: parent.width * 0.4
            text: "At the absolute center lies the singularity, a point where density becomes infinite and the laws of physics as we know them completely break down.\n\n• Escape Velocity: > Speed of Light"
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5
            horizontalAlignment: Text.AlignRight

            transform: Translate {
                y: page1BlackHoles.isActive ? 0 : 400
                Behavior on y { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }
    }

    // ==========================================
    // PAGE 2: NEBULAE
    // ==========================================
    Item {
        id: page2Nebulae
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110

        property bool isActive: currentIndex === 1
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        // Title
        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Cosmic Nebulae"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 48)
            font.family: "Century Gothic"
            font.bold: true
        }

        // Block 1: Left (A little above center - Reversed)
        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -75
            width: parent.width * 0.35
            text: "A sprawling, distinct body of interstellar clouds consisting of cosmic dust, hydrogen, helium, and intensely ionized gases."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5

            transform: Translate {
                x: page2Nebulae.isActive ? 0 : -800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 2: Right (A little below center - Reversed)
        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            width: parent.width * 0.35
            text: "These colorful monuments are suspended in the deep vacuum of space, often serving as the universe's stellar nurseries."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5
            horizontalAlignment: Text.AlignRight

            transform: Translate {
                x: page2Nebulae.isActive ? 0 : 800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 3: Bottom (A bit left of middle - Reversed)
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -200
            width: parent.width * 0.4
            text: "Here, the seeds of new stars are planted, violently ignited, and born. Conversely, many are also the beautiful aftermath of a dying star's explosive supernova."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5

            transform: Translate {
                y: page2Nebulae.isActive ? 0 : 400
                Behavior on y { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }
    }

    // ==========================================
    // PAGE 3: GALAXIES
    // ==========================================
    Item {
        id: page3Galaxies
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110

        property bool isActive: currentIndex === 2
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        // Title
        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Spiral Galaxies"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 48)
            font.family: "Century Gothic"
            font.bold: true
        }

        // Block 1: Left (A little below center)
        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            width: parent.width * 0.35
            text: "Colossal, gravitationally bound systems consisting of billions of stars, stellar remnants, interstellar gas, dust, and elusive dark matter."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5

            transform: Translate {
                x: page3Galaxies.isActive ? 0 : -800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 2: Right (A little above center)
        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -75
            width: parent.width * 0.35
            text: "These cosmic islands slowly rotate around a densely packed galactic center, dancing together in a massive cosmic whirlpool."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5
            horizontalAlignment: Text.AlignRight

            transform: Translate {
                x: page3Galaxies.isActive ? 0 : 800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }
        }

        // Block 3: Bottom (A bit right of middle)
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 200
            width: parent.width * 0.4
            text: "Bound entirely by gravitational forces, these structures almost always harbor a supermassive black hole serving as the anchor at their core."
            color: "#cccccc"
            font.pixelSize: Math.min(parent.width * 0.035, 16)
            font.family: "Century Gothic"
            wrapMode: Text.WordWrap
            lineHeight: 1.5
            horizontalAlignment: Text.AlignRight

            transform: Translate {
                y: page3Galaxies.isActive ? 0 : 400
                Behavior on y { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
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
}
