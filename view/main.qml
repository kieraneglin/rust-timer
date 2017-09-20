import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: 400
  height: 300
  title: "COSC GUI"
  Component.onCompleted: visible = true

  Button {
    anchors.horizontalCenter: parent.horizontalCenter
    text: "Start"
    onClicked: function() {
      timer.start_timer()
      console.log('asdasd')
    }
  }
}
