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
    id: row
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    anchors.horizontalCenter: parent.horizontalCenter

    property int falloff: 3 // how many adjacent elements are affected
    property int current: -1
    property real scaleFactor: .75 // that's how much extra it scales

    Repeater {
      model: iconColors()
      Image {
        source: "icons/" + modelData + ".png"
        width: 50 * pseudoScale
        height: width
        anchors.bottom: parent.bottom
        property real pseudoScale: {
          if (row.current == -1) return 1
          else {
            var diff = Math.abs(index - row.current)
            return (Math.max(0, row.falloff - diff) / row.falloff) * row.scaleFactor + 1
          }
        }
        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          onContainsMouseChanged: row.current = containsMouse ? index : -1
          onClicked: endTimer()
        }
        Behavior on pseudoScale {
          PropertyAnimation {
            duration: 150
          }
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
