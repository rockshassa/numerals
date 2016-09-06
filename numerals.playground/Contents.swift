//: Playground - noun: a place where people can play

extension String {
    /*
     This is a computed property that parses a string of roman numerals into an integer value
     */
    var romanValue:Int{
        get {
            var total = 0
            var numerals = [Numeral]()
            
            for char in self.characters{
                numerals.append(char.numeral)
            }
            
            print(numerals)
            
            let components = numerals.components()
            
            var idx = 0
            while idx < components.count {
                
                let currentComponent = components[idx]
                
                if idx+1 < components.count {
                    let nextComponent = components[idx+1]
                    
                    /*
                     If the current component weighs more than the next, then the current component is additive
                     If it weighs less, than it will be subtractive
                     
                     eg.
                     currentComponent = [ .I , .I , .I ] has a weight of 1
                     
                     nextComponent = [ .V ] has a weight of 5
                     
                    */
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
    }
}

/*
 A convenience initializer for Numeral instances
 */
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
//TODO: explicitly say that this extension only applies to arrays with generic type [Numeral]
    
    
    /*
     splits a list of numerals into its component parts, returning a 2-dimensional array
     
     eg.
     
     input
     [ .I, .I, .I, .V, .X ]
     
     output
     [
      [ .I, .I, .I],
      [ .V],
      [ .X]
     ]
     
    */
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

//MARK:- convenience extensions

extension String {
    
    /*
     These subscript extensions are for convenience, since swift 2.x does not yet have an
     easy way to access characters by index.
     essentially lets me do:
     
     let char = "some string"[1]
     
     assert(char == "o")
     */
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

//MARK:- An enum representing a "digit" in a roman numeral
enum Numeral : Int {
    case I = 1
    case V = 5
    case X = 10
    case L = 50
    case C = 100
    case D = 500
    case M = 1000
}

//tests
assert("XVIII".romanValue==18)
assert("IX".romanValue==9)
assert("XXIV".romanValue==24)
assert("DCCCXC".romanValue==890)
assert("XCIX".romanValue==99)


