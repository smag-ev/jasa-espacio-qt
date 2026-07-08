import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: "JASA Espacio"

    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    property int slideDirection: 1
    property string loggedInUser: "Guest"

    SequentialAnimation {
        id: exitMinimizeAnim
        property string action: ""

        ParallelAnimation {
            NumberAnimation { target: rootBackground; property: "scale"; to: 0.95; duration: 150; easing.type: Easing.InQuad }
            NumberAnimation { target: rootBackground; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InQuad }
        }
        ScriptAction {
            script: {
                if (exitMinimizeAnim.action === "minimize") {
                    mainWindow.showMinimized()
                    rootBackground.scale = 1.0
                    rootBackground.opacity = 1.0
                } else {
                    Qt.quit()
                }
            }
        }
    }

    SequentialAnimation {
        id: smoothMaximizeAnim

        NumberAnimation {
            target: rootBackground
            property: "opacity"
            to: 0.5
            duration: 200
            easing.type: Easing.OutQuad
        }

        ScriptAction {
            script: {
                if (mainWindow.visibility === Window.Maximized) {
                    mainWindow.showNormal()
                } else {
                    mainWindow.showMaximized()
                }
            }
        }

        NumberAnimation { target: rootBackground; property: "opacity"; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
    }

    Rectangle {
        id: rootBackground
        anchors.fill: parent
        color: "#000000"
        clip: true

        radius: mainWindow.visibility === Window.Maximized ? 0 : 15
        Behavior on radius { NumberAnimation { duration: 200 } }

        Item {
            width: parent.width
            height: 35
            z: 998

            DragHandler {
                target: null
                enabled: mainWindow.visibility !== Window.Maximized
                onActiveChanged: if (active) mainWindow.startSystemMove()
            }
            TapHandler {
                onDoubleTapped: smoothMaximizeAnim.start()
            }
        }

        Transition {
            id: slideEnter
            NumberAnimation {
                property: "x"
                from: stackView.width * mainWindow.slideDirection
                to: 0
                duration: 750
                easing.type: Easing.OutQuad
            }
        }

        Transition {
            id: slideExit
            NumberAnimation {
                property: "x"
                from: 0
                to: -stackView.width * mainWindow.slideDirection
                duration: 750
                easing.type: Easing.OutQuad
            }
        }

        Transition {
            id: zoomInEnter
            ParallelAnimation {
                NumberAnimation { property: "scale"; from: 0.5; to: 1.0; duration: 1000; easing.type: Easing.OutExpo }
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 500 }
            }
        }

        Transition {
            id: zoomInExit
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 1000 }
        }

        Transition {
            id: zoomOutEnter
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 500 }
        }

        Transition {
            id: zoomOutExit
            ParallelAnimation {
                NumberAnimation { property: "scale"; from: 1.0; to: 0.5; duration: 1000; easing.type: Easing.OutExpo }
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 1000 }
            }
        }

        StackView {
            id: stackView
            anchors.fill: parent
            //------------------
            //  OPENING PAGE
            //------------------
            initialItem: "WelcomePage.qml"

            replaceEnter: slideEnter
            replaceExit: slideExit
        }

        Row {
            anchors { top: parent.top; right: parent.right; margins: 10 }
            spacing: 8
            z: 999

            Button {
                id: minBtn
                width: 35; height: 35; flat: true; down: false
                onClicked: { exitMinimizeAnim.action = "minimize"; exitMinimizeAnim.start() }
                background: Rectangle { radius: 17.5; color: minBtn.hovered ? "#33ffffff" : "transparent" }
                contentItem: Text { text: "—"; color: "white"; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }

            Button {
                id: maxBtn
                width: 35; height: 35; flat: true; down: false
                onClicked: smoothMaximizeAnim.start()
                background: Rectangle { radius: 17.5; color: maxBtn.hovered ? "#33ffffff" : "transparent" }
                contentItem: Text {
                    text: mainWindow.visibility === Window.Maximized ? "❐" : "☐"
                    color: "white"; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                }
            }

            Button {
                id: closeBtn
                width: 35; height: 35; flat: true; down: false
                onClicked: { exitMinimizeAnim.action = "close"; exitMinimizeAnim.start() }
                background: Rectangle { radius: 17.5; color: closeBtn.hovered ? "#ff4444" : "transparent" }
                contentItem: Text { text: "✕"; color: "white"; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
    }

    function leftSlideTransition() {
        mainWindow.slideDirection = 1
        stackView.replaceEnter = slideEnter
        stackView.replaceExit = slideExit
    }

    function rightSlideTransition() {
        mainWindow.slideDirection = -1
        stackView.replaceEnter = slideEnter
        stackView.replaceExit = slideExit
    }

    function openPageTransition() {
        stackView.replaceEnter = zoomInEnter
        stackView.replaceExit = zoomInExit
    }

    function closePageTransition() {
        stackView.replaceEnter = zoomOutEnter
        stackView.replaceExit = zoomOutExit
    }
}
