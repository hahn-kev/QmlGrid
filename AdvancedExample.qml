import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

DataTable {
    id: tableId
    property var sortedColumn
    property bool inverted: false    
    function sortBy(column) {
        var inverse = false;
        if (sortedColumn == column.name) inverse = !inverted
        function compareNumber(a, b) {
            return (a[column.name] - b[column.name]) * (inverse ? -1 : 1);
        }
        function compareString(a, b) {
            return a[column.name].localeCompare(b[column.name]) * (inverse ? -1 : 1);
        }
        var rows = tableId.rows;
        rows.sort(column.type == "string" ? compareString : compareNumber);
        tableId.rows = rows;
        sortedColumn = column.name;
        inverted = inverse;
    }

    columns: [
        {name:"name", label: "First Name", type:"string"},
        {name:"lastName", label: "Last Name", type:"string"},
        {name:"age", type:"number"},
        {
            name:"money",
            type:"number", 
            format:function(value) {
                return "$" + value;
            }
        }, 
        {
            name:"address.city",
            label: "City",
            type:"string"
        }
    ]
    rows: [
        {lastName: "Bobberson", name:"bob", age: 4, money: 500, address: {city:"city ville"}}, 
        {lastName: "be", name: "jo", age: 6, money: 13400, address: {city:"city ville"}},
        {lastName: "ington", name: "Alex", age: 50, money: 5, address: {city:"city ville"}},
        {lastName: "Butterfly", name: "Rebekah", age: 22, money: 235234, address: {city:"city ville"}},
    ]
    onColumnHeaderClicked: {
        print("sorting column: " + column.name);
        sortBy(column);
    }
    onCellClicked: print("clicked cell:" + column.name + "|" + row.name)
    columnHeader: Row {
        property var column
        Text {
            text: sortedColumn !== column.name ? " " : (inverted ? "\u25B2" : "\u25BC")
        }
        Label {
            text: column.label || column.name
        }
    }
}