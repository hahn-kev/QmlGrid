import QtQuick 2.0
import QtQuick.Controls 2.0

Label {
    property var column
    opacity: 0.54
    text: column.label || column.name
}