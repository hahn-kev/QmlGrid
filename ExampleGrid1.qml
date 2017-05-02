import QtQuick 2.0

DataTable {
    id: tableId
    property alias ageColumn: ageColumnId
    columns: [
        DataColumn {field:"name"; label: "First Name"},
        DataColumn {field:"lastName"; label: "Last Name"},
        DataColumn {
            id: ageColumnId
            field:"age"
            type:"number"
            cell: DefaultCell {
                color: row.age > 20 ? "blue" : "red"
            }
        }
    ]
    
    
    rows: [
        {lastName: "Bobberson", name:"bob", age: 4}, 
        {lastName: "be", name: "jo", age: 6},
        {lastName: "ington", name: "Alex", age: 50},
        {lastName: "Butterfly", name: "Rebekah", age: 22},
    ]
    onColumnHeaderClicked: {
        print("sorting column: " + column.name);
    }
    onCellClicked: print("clicked cell:" + column.name + "|" + row.name)
}