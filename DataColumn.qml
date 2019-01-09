import QtQuick 2.0

QtObject {
    property var field
    property string label
    property string type: "string"
    property string namespace
    property bool visible: true
    property var format: function (value) { return value; }
    property bool invertColorRating: false
    property var columnWidth
    property Component cell
    
    function getValue(field, row) {
        if (typeof field == "function") return field(row)
        var tmp = row;
        var from = 0;
        for (var i = 0; i < field.length; i++) {
            if (field[i] === '.') {
                if (field[i - 1] == ')') {
                    from = i + 1;
                    continue;
                }

                tmp = tmp[field.substring(from, i)];
                from = i + 1;
            }
            if (field[i] === '(') {
                tmp = tmp[field.substring(from, i)]();
                i++;
                from = i + 1;
            }
        }
        if (from < i) {
            tmp = tmp[field.substring(from, i)];
        }

        return tmp;
    }
}
