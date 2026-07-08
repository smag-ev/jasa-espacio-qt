import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

    Image {
        id: bgImage
        anchors.fill: parent
        source: "Images/mainMenuBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        opacity: 0.75

        fillMode: Image.PreserveAspectCrop
    }

    Text {
        id: appNameText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.08

        color: "#ffffff"
        text: qsTr("JASA ESPACIO")
        font.pixelSize: Math.min(parent.width * 0.04, 40)
        horizontalAlignment: Text.AlignHCenter
        font.family: "Century Gothic"
        font.bold: true
    }

    Button {
        id: userProfileButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 30
        anchors.leftMargin: 30
        width: 80
        height: 80
        flat: true
        down: false

        scale: pressed ? 1.2 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }

        background: Rectangle {
            radius: width / 2

            color: userProfileButton.hovered ? "#232c40" : "#1c2333"
        }

        Image {
            anchors.centerIn: parent
            width: 60
            height: 60
            sourceSize.width: width
            sourceSize.height: height
            source: "Images/userImage.svg"
            fillMode: Image.PreserveAspectCrop
        }

        onClicked: {
            rightSlideTransition()
            stackView.replace("WelcomePage.qml")
        }
    }

    Button {
        id: feedbackButton
        width: 140
        height: 35
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 55
        anchors.rightMargin: 35
        flat: true
        down: false

        scale: pressed ? 1.2 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }

        contentItem: Text {
            text: "Submit Feedback"
            color: "#ffffff"
            font.pixelSize: 14
            font.family: "Century Gothic"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: 15
            color: feedbackButton.hovered ? "#1c2333" : "#34405d"
        }

        onClicked: { openPageTransition(); stackView.replace("Feedback.qml") }
    }

    GridLayout {
        id: grid
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 40
        rowSpacing: 30
        columnSpacing: 30
        rows: 2
        columns: 3

        Button {
            id: issTracker
            opacity: 1
            visible: true
            clip: true
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#1c2333"
                clip: true
            }

            Image {
                anchors.fill: parent
                sourceSize.width: 700
                sourceSize.height: 400
                opacity: 0.8
                visible: true
                source: "Images/menuPlaceholderImage1.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            Text {
                x: 176
                y: 20
                color: "#ffffff"
                text: "ISS TRACKER"
                font.pixelSize: 28
                horizontalAlignment: Text.AlignRight
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("ISSTracker.qml") }
        }

        Button {
            id: stargazePlaces
            opacity: 1
            clip: true
            highlighted: false
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#274ca0"
                clip: true
            }

            Image {
                anchors.fill: parent
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 86
                anchors.bottomMargin: -86
                opacity: 0.8
                visible: true
                sourceSize.width: 700
                sourceSize.height: 400
                source: "Images/menuPlaceholderImage2.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            Text {
                x: 85
                y: 20
                color: "#ffffff"
                text: "BEST STARGAZING<br>PLACES IN PAKISTAN"
                font.pixelSize: 26
                horizontalAlignment: Text.AlignRight
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("StargazePlaces.qml") }
        }

        Button {
            id: spaceWonders
            opacity: 1
            clip: true
            highlighted: false
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#1c2333"
                radius: 15
                clip: true
            }

            Image {
                anchors.fill: parent
                opacity: 0.6
                visible: true
                sourceSize.width: 700
                sourceSize.height: 400
                source: "Images/menuPlaceholderImage3.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            Text {
                x: 50
                y: 30
                color: "#ffffff"
                text: "TOP SPACE WONDERS"
                font.pixelSize: 28
                horizontalAlignment: Text.AlignRight
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("SpaceWonders.qml") }
        }

        Button {
            id: stargazeCalculator
            opacity: 1
            clip: true
            highlighted: false
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#1c2333"
                radius: 15
                clip: true
            }

            Image {
                anchors.fill: parent
                opacity: 0.8
                visible: true
                source: "Images/menuPlaceholderImage4.jpg"
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: 700
                sourceSize.height: 400
            }

            Text {
                x: 60
                y: 20
                color: "#ffffff"
                text: "STARGAZE CONDITION<br>CALCULATOR"
                font.pixelSize: 26
                horizontalAlignment: Text.AlignRight
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("StargazeCalculator.qml") }
        }

        Button {
            id: tonightWeather
            opacity: 1
            clip: true
            highlighted: false
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#1c2333"
                radius: 15
                clip: true
            }

            Image {
                anchors.fill: parent
                opacity: 0.9
                visible: true
                source: "Images/menuPlaceholderImage5.jpg"
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: 700
                sourceSize.height: 400
            }

            Text {
                x: 88
                y: 20
                color: "#ffffff"
                text: "TONIGHT's WEATHER<br>FOR STARGAZING"
                font.pixelSize: 26
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("WeatherForStargaze.qml") }
        }

        Button {
            id: models3D
            opacity: 1
            clip: true
            highlighted: false
            flat: true
            hoverEnabled: true
            padding: 0
            down: false

            scale: pressed ? 1.2 : (hovered ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150 } }

            background: Rectangle {
                implicitWidth: 350
                implicitHeight: 200
                color: "#1c2333"
                radius: 15
                clip: true
            }

            Image {
                anchors.fill: parent
                opacity: 0.8
                visible: true
                source: "Images/menuPlaceholderImage6.jpg"
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: 700
                sourceSize.height: 400
            }

            Text {
                x: 20
                y: 20
                color: "#ffffff"
                text: "3D MODELS"
                font.pixelSize: 28
                horizontalAlignment: Text.AlignLeft
                font.family: "Century Gothic"
                font.bold: true
            }

            onClicked: { openPageTransition(); stackView.replace("Models.qml") }
        }
    }
}
