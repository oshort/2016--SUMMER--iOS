/*:
![Remote Image](http://theironyard.com/images/home/tiy-logo.png)

## Intro to Swift Playgrounds

### Resources

- [The Iron Yard](http://www.theironyard.com)
- [Iron Yard Meetups](http://www.meetup.com/The-Iron-Yard-Orlando/)
- [Playgrounds via Ray Wenderlich](http://www.raywenderlich.com/115253/swift-2-tutorial-a-quick-start)
- [XCPlaygrounds via NSHipster](http://nshipster.com/xcplayground/)

*/
//: As tradition dictates, any exploration of a new language needs to start with "hello, world"

let helloString = "Hello, World!"
print(helloString)

// A single line comment is one with two slashes as the first characters
/* 
   A multi-line comment
   is one that is bounded by
   /* and */ characters
*/

//: Semi-colons, not required, unless you place multiple instructions on the same line

let greeting = "Hello"; print(greeting)

//: Identifiers, first character A-Z or a-z or _, followed by any of these plus 0-9

let theIronYard = "awesome", tiy100 = "100%", _travelBack = "1985"
print("The Iron Yard is \(tiy100) \(theIronYard).")

let 你好 = "你好世界"
print(你好)

//: Constants are declared with 'let' keyword

let students = 30
let tiyStaff = 4
let totalPeople = students + tiyStaff
//totalPeople = 4

//: Variables are declared with 'var' keyword

var appleCount = 10
appleCount -= 2

//: Above values determined implicitly, below shows explicit types

let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70

//: Data types in Swift

let anInt: Int = 4
let aDouble: Double = 4000.25
let aBool: Bool = false
let aString: String = "The Iron Yard"

//: Type safety: once a var's data type is set, it cannot hold a value of any other type

var life = 42
//life = "The ultimate answer to life, the universe and everything"

//: Types are never automatically converted

let label = "The width is "
let width = 94
let widthLabel = label + String(width)
//let widthLabel = label + width

//: String interpolation and concatenation

let heightLabel = "The height is" + "100"
let anotherWidthLabel = "The width is \(width)"

//: Literals, just a value

42 // integer literal
3.14159 // double literal
"Hello, World!" // string literal

//: Operators

var a = 5
var b = a + 3
var c = b - a
var d = c * 5
var e = Double(d) / 3.2
var myMod = 9 % 4

var x1 = 1
x1 += 5
x1 -= 2
x1 /= 2

var f = 10
var g = 3.6
var h = f + Int(g)

//: Collections: Arrays

let shipCaptains = ["Malcolm Reynolds", "Jean-Luc Picard", "James T. Kirk", "Han Solo"]
let sameCaptains = ["Malcolm Reynolds", "Jean-Luc Picard", "James T. Kirk", "Han Solo"]

if shipCaptains == sameCaptains
{
    print("Arrays are equal")
}
else
{
    print("Arrays are not equal")
}

var moreCaptains = shipCaptains
moreCaptains.append("Kathryn Janeway")
print(moreCaptains)

moreCaptains[3]

//: Collections: Dictionaries

var occupations = ["Malcolm": "Captain", "Kaylee": "Mechanic"]
occupations["Malcolm"]
occupations["Jayne"] = "Public Relations"
print(occupations)

//: for loop

let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores
{
    if score > 50
    {
        teamScore += 3
    } else
    {
        teamScore += 1
    }
}
print(teamScore)

//: switch

switch a
{
case 1:
    print("Got 1")
case 2:
    print("Got 2")
case 3, 4, 5:
    print("Got 3 or 4 or 5")
case 6...22:
    print("Got 6 to 22")
default:
    print("Got Default")
}

let furniture = "Chair"
switch furniture
{
case "Table":
    print("Got Table")
case "Chair", "Stool", "Bench":
    print("Got Something to sit on")
default:
    print("Default")
}

//: Testing a UIKit component in a playground

import UIKit

class TestDataSource : NSObject, UITableViewDataSource
{
    let sortedCaptains = moreCaptains.sort()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sortedCaptains.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        let captainsName = sortedCaptains[indexPath.row]
        cell.textLabel?.text = "\(captainsName)"
        return cell
    }
}

let testDataSource = TestDataSource()
let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 320), style: .Plain)
tableView.dataSource = testDataSource
tableView.reloadData()

