//: Playground - noun: a place where people can play

import UIKit

enum CompassPoint: String
{
    case North
    case South
    case East
    case West = "Travel West"
}

var directionToHead = CompassPoint.North
directionToHead = .South

switch directionToHead
{
case .North:
    print("Lots of planets have a north")
case .South:
    print("Watch out for penguins")
case .East:
    print("Where the sun rises")
case .West:
    print("Where the skies are blue")
}

enum Planet: Int
{
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

let somePlanet = Planet.Mars
switch somePlanet.rawValue
{
case 3:
    print("Mostly harmless")
case 4:
    print("The red planet")
default:
    print("Not a safe place for humans")
}

switch somePlanet
{
case .Earth:
    print("Mostly harmless")
case .Mars:
    print("The red planet")
default:
    print("Not a safe place for humans")
}

let earthsOrder = Planet.Earth.rawValue
let sunsetDirection = CompassPoint.West.rawValue
let sunriseDirection = CompassPoint.East.rawValue

let possiblePlanet = Planet(rawValue: 10)

if let realPlanet = possiblePlanet
{
    switch realPlanet
    {
    case .Earth:
        print("Mostly harmless")
    case .Mars:
        print("The red planet")
    default:
        print("Not a safe place for humans")
    }
}


enum Barcode
{
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}

var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
//productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

switch productBarcode
{
case .UPCA(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case .QRCode(let productCode):
    print("QR Code: \(productCode).")
}

// Enums can support recursion, as shown below to model simple arithmetic expressions.

enum ArithmeticExpression
{
    case Number(Int)
    indirect case Addition(ArithmeticExpression, ArithmeticExpression)
    indirect case Multiplication(ArithmeticExpression, ArithmeticExpression)
}

func evaluate(expression: ArithmeticExpression) -> Int
{
    switch expression
    {
    case .Number(let value):
        return value
    case .Addition(let left, let right):
        return evaluate(expression: left) + evaluate(expression: right)
    case .Multiplication(let left, let right):
        return evaluate(expression: left) * evaluate(expression: right)
    }
}

// evaluate (5 + 4) * 2
let five = ArithmeticExpression.Number(5)
let four = ArithmeticExpression.Number(4)
let sum = ArithmeticExpression.Addition(five, four)
let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number(2))
print(evaluate(expression: product))



