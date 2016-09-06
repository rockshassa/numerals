//: Playground - noun: a place where people can play

//MARK:- convenience extensions

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
    
    var romanValue:Int{
        get {
            return parse(self)
        }
    }
}


extension Character{
    var numeral:Numeral {
        get {
            switch self {
            case "I": return .I
            case "V": return .V
            case "X": return .X
            case "L": return .L
            case "C": return .C
            case "D": return .D
            case "M": return .M
            default:
                assertionFailure()
                return .X
            }
        }
    }
}


extension Array {
    func components()->[[Numeral]]{
        var components = [[Numeral]]()
        var currentComponent = [Numeral]()
        let len = self.count
        var idx:Int = 0
        while idx < len {
            
            let currentNumeral = self[idx] as! Numeral
            
            if currentComponent.count == 0{
                currentComponent.append(currentNumeral)
            } else if let first = currentComponent.last where currentNumeral == first {
                currentComponent.append(currentNumeral)
            } else {
                components.append(currentComponent)
                currentComponent = [Numeral]()
                currentComponent.append(currentNumeral)
            }
            
            idx += 1
            
            if !(idx < len){
                components.append(currentComponent)
            }
        }
        return components
    }
    
    func intValue()->Int{
        let f = self.first as! Numeral
        return f.rawValue * self.count
    }
    
    func weight()->Int {
        let f = self.first as! Numeral
        return f.rawValue
    }
}

//MARK:- An enum representing a roman numeral

enum Numeral : Int {
    case I = 1
    case V = 5
    case X = 10
    case L = 50
    case C = 100
    case D = 500
    case M = 1000
}


func parse(numeralString:String)->Int{
    
    var total = 0
    var numerals = [Numeral]()
    
    for char in numeralString.characters{
        numerals.append(char.numeral)
    }
    
    print(numerals)
    
    let components = numerals.components()
    
    var idx = 0
    while idx < components.count {
        
        let currentComponent = components[idx]
        
        if idx+1 < components.count {
            let nextComponent = components[idx+1]
            if currentComponent.weight() > nextComponent.weight() {
                total += currentComponent.intValue()
            } else {
                total -= currentComponent.intValue()
            }
        } else {
            total += currentComponent.intValue()
        }
        
        idx += 1
    }
    
    print(components)
    return total
}

assert("XVIII".romanValue==18)
assert("IX".romanValue==9)
assert("XXIV".romanValue==24)
assert("DCCCXC".romanValue==890)
assert("XCIX".romanValue==99)


