import Foundation
import PlaygroundSupport

extension PlaygroundValue {
  
  ///Extrai string de um dicionario pv
  public func stringFromDict(withKey key: String) -> String? {
    if case .dictionary(let dict) = self,
      let value = dict[key],
      case .string(let str) = value {
      return str
    }
    return nil
  }
  
  //Extrai double pv de um dicionario pv
  public func integerFromDict(withKey key: String) -> Int? {
    if case .dictionary(let dict) = self,
      let value = dict[key],
      case .integer(let num) = value {
      return num
    }
    return nil
  }
  
  ///Extrai double de pv
  public func toInteger() -> Int?{
    if case .integer(let num) = self{
      return num
    }
    return nil
  }
  
  
  ///Extrai string de pv
  public func toString() -> String?{
    if case .string(let string) = self{
      return string
    }
    return nil
  }

}


extension Array {
  func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
    var set = Set<T>() //the unique list kept in a Set for fast retrieval
    var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
    for value in self {
      if !set.contains(map(value)) {
        set.insert(map(value))
        arrayOrdered.append(value)
      }
    }
    
    return arrayOrdered
  }
}
