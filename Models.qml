import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia
import QtQuick3D
import QtQuick3D.Helpers
import "Models"

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
        source: "Audio/modelsBG.mp3"
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
    // BACKGROUND
    // ==========================================
    Repeater {
        id: stars
        model: 200

        Rectangle {
            required property int index

            x: (index * 137 + 31) % 1280
            y: (index * 251 + 73) % 720

            property real sz: ((index * 17 + 5) % 3) + 1
            property real baseOpacity: 0.2 + ((index * 43) % 10) * 0.07

            width: sz
            height: sz
            radius: sz
            color: "white"
            opacity: baseOpacity

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: baseOpacity * 0.2; duration: 1200 + (index * 97) % 2000; easing.type: Easing.InOutSine }
                NumberAnimation { to: baseOpacity; duration: 1200 + (index * 97) % 2000; easing.type: Easing.InOutSine }
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
        z: 10
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
        z: 10
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
        z: 10
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
    // EARTH MODEL
    // ==========================================
    Item {
        id: page1Earth
        anchors.fill: parent

        property bool isActive: currentIndex === 0
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Earth"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 48)
            font.family: "Century Gothic"
            font.bold: true

            transform: Translate {
                y: page1Earth.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 700; easing.type: Easing.OutExpo } }
            }
        }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 108
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Our Pale Blue Dot  ·  6,371 km radius  ·  1 AU from the Sun"
            color: "#88ccddff"
            font.pixelSize: 13
            font.family: "Century Gothic"

            transform: Translate {
                y: page1Earth.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }

        View3D {
            id: earthView
            anchors.centerIn: parent
            width: 520
            height: 520
            renderMode: View3D.Offscreen
            renderFormat: ShaderEffectSource.RGBA8

            opacity: page1Earth.isActive ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 600 } }

            transform: Scale {
                xScale: page1Earth.isActive ? 1.0 : 0.75
                yScale: page1Earth.isActive ? 1.0 : 0.75
                origin.x: earthView.width / 2
                origin.y: earthView.height / 2
                Behavior on xScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
                Behavior on yScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            environment: SceneEnvironment {
                clearColor: "transparent"
                backgroundMode: SceneEnvironment.Transparent
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.Medium
            }

            PerspectiveCamera {
                id: earthCamera
                position: Qt.vector3d(0, 0, 1200)
                clipNear: 0.01
                clipFar: 1000
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(-20, 45, 0)
                brightness: 1.5
                castsShadow: false
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(20, -160, 0)
                brightness: 0.3
                color: "#aaccff"
                castsShadow: false
            }

            Model {
                id: earthModel
                source: "Models/earth.mesh"
                scale: Qt.vector3d(1, 1, 1)
                pickable: true

                materials: PrincipledMaterial {
                    baseColorMap: Texture {
                        source: "Models/maps/earthTextureData.png"
                        generateMipmaps: true
                        mipFilter: Texture.Linear
                    }
                    normalMap: Texture {
                        source: "Models/maps/earthTextureData2.png"
                        generateMipmaps: true
                        mipFilter: Texture.Linear
                    }
                    metalness: 0.1
                    roughness: 0.8
                    alphaMode: PrincipledMaterial.Opaque
                }
            }

            OrbitCameraController {
                anchors.fill: parent
                origin: earthModel
                camera: earthCamera
                panEnabled: false
                xInvert: true

            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 55
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Drag to rotate  ·  Scroll to zoom"
            color: "#55ffffff"
            font.pixelSize: 12
            font.family: "Century Gothic"
            horizontalAlignment: Text.AlignHCenter

            transform: Translate {
                y: page1Earth.isActive ? 0 : 60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }
    }

    // ==========================================
    // MOON MODEL
    // ==========================================
    Item {
        id: page2Moon
        anchors.fill: parent

        property bool isActive: currentIndex === 1
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Moon"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 48)
            font.family: "Century Gothic"
            font.bold: true

            transform: Translate {
                y: page2Moon.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 700; easing.type: Easing.OutExpo } }
            }
        }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 108
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Earth's Natural Satellite  ·  1,737 km radius  ·  384,400 km away"
            color: "#88ccccbb"
            font.pixelSize: 13
            font.family: "Century Gothic"

            transform: Translate {
                y: page2Moon.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }

        View3D {
            id: moonView
            anchors.centerIn: parent
            width: 500
            height: 500
            renderMode: View3D.Offscreen
            renderFormat: ShaderEffectSource.RGBA8

            opacity: page2Moon.isActive ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 600 } }

            transform: Scale {
                xScale: page2Moon.isActive ? 1.0 : 0.75
                yScale: page2Moon.isActive ? 1.0 : 0.75
                origin.x: moonView.width / 2
                origin.y: moonView.height / 2
                Behavior on xScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
                Behavior on yScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            environment: SceneEnvironment {
                clearColor: "transparent"
                backgroundMode: SceneEnvironment.Transparent
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.Medium
            }

            PerspectiveCamera {
                id: moonCamera
                position: Qt.vector3d(0, 0, 3)
                clipNear: 0.01
                clipFar: 1000
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(-15, 40, 0)
                brightness: 1.4
                castsShadow: false
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(10, -150, 0)
                brightness: 0.2
                color: "#cccccc"
                castsShadow: false
            }

            Model {
                id: moonModel
                source: "Models/moon.mesh"
                scale: Qt.vector3d(1, 1, 1)
                pickable: true

                materials: PrincipledMaterial {
                    baseColorMap: Texture {
                        source: "Models/maps/moonTextureData.png"
                        generateMipmaps: true
                        mipFilter: Texture.Linear
                    }
                    metalness: 0.0
                    roughness: 0.95
                    alphaMode: PrincipledMaterial.Opaque
                }
            }

            OrbitCameraController {
                anchors.fill: parent
                origin: moonModel
                camera: moonCamera
                panEnabled: false
                xInvert: true
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 55
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Drag to rotate  ·  Scroll to zoom"
            color: "#55ffffff"
            font.pixelSize: 12
            font.family: "Century Gothic"
            horizontalAlignment: Text.AlignHCenter

            transform: Translate {
                y: page2Moon.isActive ? 0 : 60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }
    }

    // ==========================================
    // JWST MODEL
    // ==========================================
    Item {
        id: page3JWST
        anchors.fill: parent

        property bool isActive: currentIndex === 2
        opacity: isActive ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "James Webb Space Telescope"
            color: "white"
            font.pixelSize: Math.min(parent.width * 0.1, 40)
            font.family: "Century Gothic"
            font.bold: true

            transform: Translate {
                y: page3JWST.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 700; easing.type: Easing.OutExpo } }
            }
        }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 105
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Launched Dec 25, 2021  ·  Orbiting L2  ·  6.5 m primary mirror"
            color: "#88ffd580"
            font.pixelSize: 13
            font.family: "Century Gothic"

            transform: Translate {
                y: page3JWST.isActive ? 0 : -60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }

        View3D {
            id: jwstView
            anchors.centerIn: parent
            width: 620
            height: 480
            renderMode: View3D.Offscreen
            renderFormat: ShaderEffectSource.RGBA8

            opacity: page3JWST.isActive ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 600 } }

            transform: Scale {
                xScale: page3JWST.isActive ? 1.0 : 0.75
                yScale: page3JWST.isActive ? 1.0 : 0.75
                origin.x: jwstView.width / 2
                origin.y: jwstView.height / 2
                Behavior on xScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
                Behavior on yScale { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            environment: SceneEnvironment {
                clearColor: "transparent"
                backgroundMode: SceneEnvironment.Transparent
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.Medium
            }

            PerspectiveCamera {
                id: jwstCamera
                position: Qt.vector3d(0, 0, 22)
                clipNear: 0.01
                clipFar: 1000
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(-10, 30, 0)
                brightness: 1.8
                castsShadow: false
            }

            DirectionalLight {
                eulerRotation: Qt.vector3d(15, -140, 0)
                brightness: 0.4
                color: "#ffeebb"
                castsShadow: false
            }

            Jwst {
                id: jwstModel
                scale: Qt.vector3d(1, 1, 1)
            }

            OrbitCameraController {
                anchors.fill: parent
                origin: jwstModel
                camera: jwstCamera
                panEnabled: false
                xInvert: true
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 55
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Drag to rotate  ·  Scroll to zoom"
            color: "#55ffffff"
            font.pixelSize: 12
            font.family: "Century Gothic"
            horizontalAlignment: Text.AlignHCenter

            transform: Translate {
                y: page3JWST.isActive ? 0 : 60
                Behavior on y { NumberAnimation { duration: 780; easing.type: Easing.OutExpo } }
            }
        }
    }

    Row {
        id: dots
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        z: 10
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
