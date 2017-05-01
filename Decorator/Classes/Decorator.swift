import Foundation

typealias Decoration<T> = (T) -> Void

struct Decorator<T> {
    
    let object: T
    
    func apply(_ decorations: Decoration<T>...) -> Void {
        decorations.forEach({ $0(object) })
    }
}

protocol DecoratorCompatible {
    
    associatedtype DecoratorCompatibleType
    
    var decorator: Decorator<DecoratorCompatibleType> { get }
}

extension DecoratorCompatible {
    
    var decorator: Decorator<Self> {
        return Decorator(object: self)
    }
}
