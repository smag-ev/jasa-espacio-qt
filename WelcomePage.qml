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

        Image {
            id: bgImage
            anchors.fill: parent
            source: "Images/loginSingnupBGImage.jpg"
            sourceSize.width: 1920
            sourceSize.height: 1080
            opacity: 0.75

            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: welcomeText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.08

            color: "#ffffff"
            text: qsTr("WELCOME TO JASA ESPACIO")
            font.pixelSize: Math.min(parent.width * 0.04, 40)
            horizontalAlignment: Text.AlignHCenter
            font.family: "Century Gothic"
            font.bold: true
        }

        Flipable {
            id: cardFlip
            width: 400
            height: 540
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 49

            property bool flipped: false

            front: loginCard
            back: signupCard

            Rectangle {
                    id: loginCard
                    anchors.fill: parent
                    color: "#b30a0a1a"
                    radius: 15
                    border.color: "#33ffffff"
                    border.width: 1

                    Text {
                        x: 160; y: 23
                        color: "#ffffff"
                        text: qsTr("Login")
                        font.pixelSize: 32; font.bold: true; font.family: "Century Gothic"
                    }

                    Text {
                        x: 149; y: 64
                        color: "#cccccc"
                        text: qsTr("to get started")
                        font.pixelSize: 16; font.family: "Century Gothic"
                    }

                    TextField {
                        id: emailInput
                        x: 40; y: 140; width: 320; height: 45
                        color: "#ffffff"; verticalAlignment: Text.AlignVCenter; font.pointSize: 12; placeholderText: qsTr("Email"); font.family: "Century Gothic"
                        background: Rectangle { color: "#33ffffff"; radius: 8; border.color: emailInput.activeFocus ? "#0055ff" : "transparent" }

                        onAccepted: passwordInput.forceActiveFocus()
                    }

                    TextField {
                        id: passwordInput
                        x: 40; y: 205; width: 320; height: 45
                        color: "#ffffff"; verticalAlignment: Text.AlignVCenter; font.pointSize: 12; echoMode: TextInput.Password; placeholderText: qsTr("Password"); font.family: "Century Gothic"
                        background: Rectangle { color: "#33ffffff"; radius: 8; border.color: passwordInput.activeFocus ? "#0055ff" : "transparent" }

                        onAccepted: loginButton.clicked()
                    }

                    Text {
                        x: 40; y: 260
                        color: "#aaaaaa"; text: qsTr("Forgot Password?"); font.pixelSize: 12; font.family: "Century Gothic"
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                    }

                    Text {
                        id: loginErrorText
                        x: 40; y: 281; width: 320
                        color: "#ff3333"
                        font.pixelSize: 15
                        font.family: "Century Gothic"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    SequentialAnimation {
                        id: loginShakeAnimation
                        PropertyAnimation { target: loginButton; property: "x"; from: 40; to: 60; duration: 50 }
                        PropertyAnimation { target: loginButton; property: "x"; from: 60; to: 30; duration: 50 }
                        PropertyAnimation { target: loginButton; property: "x"; from: 30; to: 50; duration: 50 }
                        PropertyAnimation { target: loginButton; property: "x"; from: 50; to: 40; duration: 50 }
                    }

                    Button {
                        id: loginButton
                        x: 40; y: 310; width: 320; height: 45
                        background: Rectangle { color: "#0033cc"; radius: 8 }
                        contentItem: Text { text: qsTr("Continue"); color: "#ffffff"; font.pixelSize: 16; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.family: "Century Gothic" }

                        onClicked: {
                            if (emailInput.text === "" || passwordInput.text === "") {
                                loginShakeAnimation.start()
                                loginErrorText.text = "Please enter both email and password!"
                                loginErrorText.color = "#ff3333"
                            } else {
                                var isValid = storeLogin.checkLogin(emailInput.text, passwordInput.text)

                                if (isValid) {
                                    loginErrorText.color = "#00ff00"
                                    loginErrorText.text = "Login Successful!"
                                    mainWindow.loggedInUser = emailInput.text
                                    leftSlideTransition()
                                    stackView.replace("MenuPage.qml")
                                } else {
                                    loginShakeAnimation.start()
                                    loginErrorText.color = "#ff3333"
                                    loginErrorText.text = "Invalid email or password!"
                                }
                            }
                            clearTimer.restart()
                        }
                    }

                    Text {
                        x: 127; y: 387
                        color: "#aaaaaa"
                        text: qsTr("New User? <font color='#ffffff'><b>Register</b></font>")
                        textFormat: Text.RichText; font.pixelSize: 16; font.family: "Century Gothic"
                        MouseArea {
                            anchors.fill: parent; anchors.leftMargin: 84; cursorShape: Qt.PointingHandCursor
                            onClicked: cardFlip.flipped = true
                        }
                    }
                }

            Rectangle {
                    id: signupCard
                    anchors.fill: parent
                    color: "#b30a0a1a"
                    radius: 15
                    border.color: "#33ffffff"
                    border.width: 1

                    Text {
                        x: 140; y: 23
                        color: "#ffffff"
                        text: qsTr("Sign Up")
                        font.pixelSize: 32; font.bold: true; font.family: "Century Gothic"
                    }

                    TextField {
                        id: signemailInput
                        x: 40; y: 105; width: 320; height: 45
                        color: "#ffffff"; verticalAlignment: Text.AlignVCenter; font.pointSize: 12; placeholderText: qsTr("Email Address"); font.family: "Century Gothic"
                        background: Rectangle { color: "#33ffffff"; radius: 8 }

                        onAccepted: signpasswordInput.forceActiveFocus()
                    }

                    TextField {
                        id: signpasswordInput
                        x: 40; y: 177; width: 320; height: 45
                        color: "#ffffff"; verticalAlignment: Text.AlignVCenter; font.pointSize: 12; echoMode: TextInput.Password; placeholderText: qsTr("Password"); font.family: "Century Gothic"
                        background: Rectangle { color: "#33ffffff"; radius: 8 }

                        onAccepted: signconfirmPasswordInput.forceActiveFocus()
                    }

                    TextField {
                        id: signconfirmPasswordInput
                        x: 40; y: 259; width: 320; height: 45
                        color: "#ffffff"; verticalAlignment: Text.AlignVCenter; font.pointSize: 12; echoMode: TextInput.Password; placeholderText: qsTr("Confirm Password"); font.family: "Century Gothic"
                        background: Rectangle { color: "#33ffffff"; radius: 8 }

                        onAccepted: createAccountButton.clicked()
                    }

                    Text {
                        id: errorText
                        x: 40; y: 317; width: 320
                        color: "#ff3333"
                        font.pixelSize: 15
                        font.family: "Century Gothic"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    SequentialAnimation {
                        id: shakeAnimation
                        PropertyAnimation { target: createAccountButton; property: "x"; from: 40; to: 60; duration: 50 }
                        PropertyAnimation { target: createAccountButton; property: "x"; from: 60; to: 30; duration: 50 }
                        PropertyAnimation { target: createAccountButton; property: "x"; from: 30; to: 50; duration: 50 }
                        PropertyAnimation { target: createAccountButton; property: "x"; from: 50; to: 40; duration: 50 }
                    }

                    Button {
                        id: createAccountButton
                        x: 40; y: 350; width: 320; height: 45
                        background: Rectangle { color: "#0033cc"; radius: 8 }
                        contentItem: Text { text: qsTr("Create Account"); color: "#ffffff"; font.pixelSize: 16; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.family: "Century Gothic" }

                        onClicked: {
                            if (signemailInput.text === "") {
                                shakeAnimation.start()
                                errorText.text = "Email cannot be empty!"
                                errorText.color = "#ff3333"
                            } else if (signemailInput.text.length < 3) {
                                shakeAnimation.start()
                                errorText.text = "Email must be at least 3 characters!"
                                errorText.color = "#ff3333"
                            } else if (signemailInput.text.indexOf("@") === -1) {
                                shakeAnimation.start()
                                errorText.text = "Email must contain an @"
                                errorText.color = "#ff3333"
                            } else if (signpasswordInput.text.length < 5) {
                                shakeAnimation.start()
                                errorText.text = "Password must be at least 5 characters!"
                                errorText.color = "#ff3333"
                            } else if (signpasswordInput.text !== signconfirmPasswordInput.text) {
                                shakeAnimation.start()
                                errorText.text = "Passwords do not match!"
                                errorText.color = "#ff3333"
                            } else {
                                var isNewUser = storeLogin.saveLogin(signemailInput.text, signpasswordInput.text)

                                if (isNewUser) {
                                    errorText.color = "#00ff00"
                                    errorText.text = "Account Created!"
                                } else {
                                    errorText.text = "Account already exists!"
                                    errorText.color = "#ff3333"
                                    shakeAnimation.start()
                                }
                            }
                            clearTimer.restart()
                        }
                    }

                    Text {
                        x: 110; y: 420
                        color: "#aaaaaa"
                        text: qsTr("Already a member? <font color='#ffffff'><b>Login</b></font>")
                        textFormat: Text.RichText; font.pixelSize: 16; font.family: "Century Gothic"
                        MouseArea {
                            anchors.fill: parent; anchors.leftMargin: 160; cursorShape: Qt.PointingHandCursor
                            onClicked: cardFlip.flipped = false
                        }
                    }
                }

            Timer {
                id: clearTimer
                interval: 2000 // 2 seconds
                onTriggered: { errorText.text = ""; loginErrorText.text = "" }
            }

            transform: Rotation {
                id: rotation
                origin.x: cardFlip.width / 2
                origin.y: cardFlip.height / 2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: cardFlip.flipped ? 180 : 0

                Behavior on angle {
                    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                }
            }
        }
}
