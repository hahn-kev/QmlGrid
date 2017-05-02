import QtQuick 2.0

QtObject {
    property var field
    property string label
    property string type: "string"
    property string namespace
    property bool visible: true
    property var format
    property Component cell
}
