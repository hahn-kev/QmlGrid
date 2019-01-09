import QtQuick 2.0
import QtQuick.Controls 2.0

Label {
    property DataColumn column
    property var row
    property var context
    property var value
    opacity: 0.87
    text: column.format ? column.format(value? value : "", row) : value
    wrapMode: Label.WordWrap
}
