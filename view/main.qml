import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: Screen.desktopAvailableWidth
  height: Screen.desktopAvailableHeight
  title: "Timer GUI"
  Component.onCompleted: visible = true

  Image {
    id: icon
    width: 50
    height: 50
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 30
  }

  Button {
    id: start
    text: "Start"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: icon.bottom
    anchors.topMargin: 30
    onClicked: function() {
      start.enabled = false
      icon.source = chooseIcon()
      timer.start_timer() // from Rust
    }
  }

  Text {
    property int attempts: 0
    text: attempts + "/50 attempts"

    id: counter
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: start.bottom
    anchors.topMargin: 30
  }

  Row {
    spacing: 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    anchors.horizontalCenter: parent.horizontalCenter

    Repeater {
      model: iconColors()
      Image {
        source: "icons/" + iconColors()[index] + ".png"
        MouseArea {
          anchors.fill: parent
          onClicked: endTimer()
        }
      }
    }
  }

  function endTimer() {
    timer.end_timer() // from Rust

    counter.attempts++
    start.enabled = true
    icon.source = ""
  }

  function iconColors() {
    return ["red", "yellow", "green", "blue", "purple"]
  }

  function chooseIcon() {
    var iconList = iconColors()
    var randomIcon = iconList[Math.floor(Math.random() * iconList.length)]

    return "icons/" + randomIcon + ".png"
  }
}
