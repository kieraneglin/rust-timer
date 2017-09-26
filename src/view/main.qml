import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: Screen.desktopAvailableWidth
  height: Screen.desktopAvailableHeight
  title: "Timer GUI"
  Component.onCompleted: visible = true

  Rectangle {
    id: icon
    width: 50
    height: 50
    visible: false

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
      icon.visible = true
      icon.color = randomIcon()
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
      Item {
        width: 55 * pseudoScale
        height: width
        anchors.bottom: parent.bottom
        property real pseudoScale: {
          if (row.current == -1) return 1
          else {
            return (Math.max(0, row.falloff - Math.abs(index - row.current)) / row.falloff) * row.scaleFactor + 1
          }
        }
        Rectangle {
          width: 50 * parent.pseudoScale
          height: width
          color: modelData
          anchors.bottom: parent.bottom
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
            duration: 100
          }
        }
      }
    }
  }

  function endTimer() {
    timer.end_timer() // from Rust

    counter.attempts++
    start.enabled = true
    icon.color = ""
    icon.visible = false
  }

  function iconColors() {
    return ["red", "yellow", "green", "blue", "purple"]
  }

  function randomIcon() {
    return iconColors()[Math.floor(Math.random() * iconColors().length)]
  }
}
