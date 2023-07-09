import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
  id: root
  title: "Joint Angle Controller"
  width: 612
  height: 300
  visible: true
  onClosing: Qt.quit()

  ColumnLayout {
    spacing: 6
    anchors.fill: parent

    SpinBox {
      id: spinBox
      minimumValue: 1
      maximumValue: observables.num_joints
      value: observables.joint_selected
      onValueChanged: {
        observables.joint_selected = value;
        /* observables.output = observables.input; */
      }
    }

    /*
    Slider {
      value: observables.joint_selected
      Layout.alignment: Qt.AlignCenter
      Layout.fillWidth: false
      minimumValue: 1
      maximumValue: observables.num_joints
      stepSize: 1.0
      onValueChanged: {
        observables.input = value;
        observables.output = observables.input;
      }
    }
    */

    Slider {
      value: observables.input
      Layout.alignment: Qt.AlignCenter
      Layout.fillWidth: true
      minimumValue: 0.0
      maximumValue: 180.0
      stepSize: 1.0
      onValueChanged: {
        observables.input = value;
        observables.output = observables.input;
      }
    }

    Text {
      Layout.alignment: Qt.AlignCenter
      text: observables.output
      font.pixelSize: 0.1*root.height
    }
  }

}
