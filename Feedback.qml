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

    // ==========================================
    // BACKGROUND IMAGE
    // ==========================================
    Image {
        id: bgFeedback
        anchors.fill: parent
        source: "Images/feedbackBGImage.jpg"
        sourceSize.width: 1920
        sourceSize.height: 1080
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
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
        onClicked: { closePageTransition(); stackView.replace("MenuPage.qml") }
    }

    // ==========================================
    // FEEDBACK FORM
    // ==========================================
    Item {
        id: feedbackPanel
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110

        property bool isVisible: true
        opacity: isVisible ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.InOutQuad } }

        // ---- Experience Rating (Top Left) ----
        Column {
            id: ratingBlock
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -60
            spacing: 12
            width: parent.width * 0.32

            transform: Translate {
                x: feedbackPanel.isVisible ? 0 : -800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            Text {
                text: "How was your experience?"
                color: "white"
                font.pixelSize: 15
                font.family: "Century Gothic"
                font.bold: true
            }

            Text {
                text: "Rate your overall journey through JASAEspacio."
                color: "#aaaaaa"
                font.pixelSize: 12
                font.family: "Century Gothic"
                wrapMode: Text.WordWrap
                width: parent.width
                lineHeight: 1.4
            }

            Row {
                spacing: 10
                property int selectedStar: 0

                Repeater {
                    id: starRepeater
                    model: 5
                    property int hoveredStar: 0
                    property int selectedStar: 0

                    delegate: Text {
                        required property int index
                        text: "★"
                        font.pixelSize: 30
                        font.family: "Century Gothic"
                        color: {
                            if (index < starRepeater.selectedStar)    return "#FFD700"
                            if (index < starRepeater.hoveredStar)     return "#FFE87C"
                            return "#44ffffff"
                        }
                        Behavior on color { ColorAnimation { duration: 150 } }

                        scale: (index < starRepeater.hoveredStar) ? 1.15 : 1.0
                        Behavior on scale { NumberAnimation { duration: 120 } }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: starRepeater.hoveredStar = index + 1
                            onExited:  starRepeater.hoveredStar = 0
                            onClicked: starRepeater.selectedStar = index + 1
                        }
                    }
                }
            }
        }

        // ---- Section Selector (Top Right) ----
        Column {
            id: sectionBlock
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -70
            spacing: 12
            width: parent.width * 0.32

            transform: Translate {
                x: feedbackPanel.isVisible ? 0 : 800
                Behavior on x { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            Text {
                text: "Which section impressed you most?"
                color: "white"
                font.pixelSize: 15
                font.family: "Century Gothic"
                font.bold: true
                width: parent.width
                wrapMode: Text.WordWrap
            }

            property string selectedSection: ""

            Column {
                spacing: 8
                width: parent.width

                Repeater {
                    model: ["Top Space Wonders", "ISS Tracker", "3D Models", "All of them!"]
                    delegate: Button {
                        required property string modelData
                        required property int index

                        width: sectionBlock.width
                        height: 34
                        flat: true
                        down: false

                        contentItem: Text {
                            text: (sectionBlock.selectedSection === modelData ? "◉  " : "○  ") + modelData
                            color: sectionBlock.selectedSection === modelData ? "white" : "#aaaaaa"
                            font.pixelSize: 13
                            font.family: "Century Gothic"
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            radius: 8
                            color: sectionBlock.selectedSection === modelData
                                   ? "#33ffffff"
                                   : (parent.hovered ? "#1affffff" : "transparent")
                            border.color: sectionBlock.selectedSection === modelData ? "#88ffffff" : "#33ffffff"
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        scale: pressed ? 0.97 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }

                        onClicked: sectionBlock.selectedSection = modelData
                    }
                }
            }
        }

        // ---- Message Box (Bottom Centre) ----
        Column {
            id: messageBlock
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            width: parent.width * 0.50

            transform: Translate {
                y: feedbackPanel.isVisible ? 0 : 400
                Behavior on y { NumberAnimation { duration: 850; easing.type: Easing.OutExpo } }
            }

            Text {
                text: "Leave a message for the team"
                color: "white"
                font.pixelSize: 15
                font.family: "Century Gothic"
                font.bold: true
            }

            Rectangle {
                id: messageBox
                width: parent.width
                height: 90
                radius: 12
                color: messageArea.activeFocus ? "#22ffffff" : "#14ffffff"
                border.color: messageArea.activeFocus ? "#88ffffff" : "#33ffffff"

                Behavior on color  { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                TextArea {
                    id: messageArea
                    anchors.fill: parent
                    anchors.margins: 12
                    placeholderText: "Your thoughts, suggestions, or cosmic discoveries…"
                    color: "white"
                    placeholderTextColor: "#66ffffff"
                    font.pixelSize: 13
                    font.family: "Century Gothic"
                    wrapMode: TextArea.Wrap
                    background: null
                    selectByMouse: true
                }
            }

            // ---- Error Message & Submit Button Row ----
            Item {
                width: parent.width
                height: 38

                Text {
                    id: errorText
                    anchors.right: submitButton.left
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Please complete all fields!"
                    color: "#ff5555"
                    font.pixelSize: 13
                    font.family: "Century Gothic"
                    font.bold: true
                    opacity: 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }

                Button {
                    id: submitButton
                    anchors.right: parent.right
                    width: 150
                    height: 38
                    flat: true
                    down: false

                    property bool submitted: false

                    scale: pressed ? 0.93 : (hovered ? 1.04 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150 } }

                    transform: Translate { id: shakeTranslate; x: 0 }

                    SequentialAnimation {
                        id: shakeAnim
                        NumberAnimation { target: shakeTranslate; property: "x"; to: -8; duration: 40 }
                        NumberAnimation { target: shakeTranslate; property: "x"; to: 8; duration: 40 }
                        NumberAnimation { target: shakeTranslate; property: "x"; to: -8; duration: 40 }
                        NumberAnimation { target: shakeTranslate; property: "x"; to: 8; duration: 40 }
                        NumberAnimation { target: shakeTranslate; property: "x"; to: 0; duration: 40 }
                    }

                    contentItem: Text {
                        text: submitButton.submitted ? "✓ Sent!" : (submitButton.enabled ? "Submit  ➤" : "Sending...")
                        color: "white"
                        font.pixelSize: 14
                        font.family: "Century Gothic"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: 20
                        color: submitButton.submitted ? "#334CAF50" : (submitButton.hovered ? "#44ffffff" : "#22ffffff")
                        border.color: submitButton.submitted ? "#8850af50" : "#88ffffff"
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        // 1. VALIDATION CHECK
                        if (starRepeater.selectedStar === 0 || sectionBlock.selectedSection === "" || messageArea.text.trim() === "") {
                            errorText.opacity = 1
                            shakeAnim.start()
                            errorHideTimer.start()
                            return;
                        }

                        // 2. SEND EMAIL VIA FORMSPREE
                        submitButton.enabled = false

                        var xhr = new XMLHttpRequest()
                        xhr.open("POST", "https://formspree.io/f/xlgzdzep")
                        xhr.setRequestHeader("Accept", "application/json")
                        xhr.setRequestHeader("Content-Type", "application/json")

                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                submitButton.enabled = true
                                if (xhr.status === 200 || xhr.status === 201) {
                                    submitButton.submitted = true
                                    resetTimer.start()
                                } else {
                                    errorText.text = "Network Error. Try again."
                                    errorText.opacity = 1
                                    shakeAnim.start()
                                    errorHideTimer.start()
                                }
                            }
                        }

                        var data = JSON.stringify({
                            "User": mainWindow.loggedInUser,
                            "Rating": starRepeater.selectedStar + " Stars",
                            "Favorite Section": sectionBlock.selectedSection,
                            "Message": messageArea.text
                        })

                        xhr.send(data)
                    }

                    Timer {
                        id: errorHideTimer
                        interval: 3000
                        onTriggered: {
                            errorText.opacity = 0
                            errorText.text = "Please complete all fields!"
                        }
                    }

                    Timer {
                        id: resetTimer
                        interval: 2500
                        repeat: false
                        onTriggered: {
                            submitButton.submitted = false
                            messageArea.clear()
                            starRepeater.selectedStar = 0
                            sectionBlock.selectedSection = ""
                        }
                    }
                }
            }
        }
    }
}
