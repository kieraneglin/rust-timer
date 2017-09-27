import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: Screen.desktopAvailableWidth
  height: Screen.desktopAvailableHeight
  title: "Timer GUI"
  Component.onCompleted: visible = true
  onClosing: {
    if(icon.visible) {
      timer.end_timer(icon.colorList[counter.attempts] + ", undefined") // in case the user closes mid-run
    }
  }

  Rectangle {
    id: icon
    width: 50
    height: 50
    visible: false
    property int colorIndex
    property variant colorList

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 30

    Component.onCompleted: colorList = generateColorList()
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
      icon.color = icon.colorList[counter.attempts]
      timer.start_timer() // from Rust
    }
  }

  Text {
    id: counter
    property int attempts: 0
    text: attempts + "/50 attempts"

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
          onClicked: endTimer(index)
        }
        Behavior on pseudoScale {
          PropertyAnimation {
            duration: 100
          }
        }
      }
    }
  }

  function endTimer(index) {
    if(icon.visible) {
      timer.end_timer(formatColors(index)) // from Rust
      counter.attempts++

      resetIcons()
    }
  }

  function formatColors(index) {
    return icon.colorList[counter.attempts] + ", " + iconColors()[index]
  }

  function resetIcons() {
    start.enabled = counter.attempts >= 50 ? false : true
    icon.color = ""
    icon.visible = !start.enabled
  }

  function iconColors() {
    return ["red", "yellow", "green", "blue", "purple"]
  }

  function generateColorList() {
    var result = (Array(11).join(iconColors() + ",")).split(",") // hackerman.gif
    result.pop() // hackerman2.png

    return shuffle(result)
  }

  function shuffle(array) { // Fisher-Yates
    var counter = array.length

    while (counter > 0) {
      var index = Math.floor(Math.random() * counter)

      counter--;

      var temp = array[counter]
      array[counter] = array[index]
      array[index] = temp
    }

    return array;
  }
}
