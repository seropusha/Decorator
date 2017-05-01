import Foundation

public typealias Decoration<T> = (T) -> Void

public struct Decorator<T> {
    
    let object: T
    
    public func apply(_ decorations: Decoration<T>...) -> Void {
        decorations.forEach({ $0(object) })
    }
}

public protocol DecoratorCompatible {
    
    associatedtype DecoratorCompatibleType
    
    var decorator: Decorator<DecoratorCompatibleType> { get }
}

public extension DecoratorCompatible {
    
    var decorator: Decorator<Self> {
        return Decorator(object: self)
    }
}
