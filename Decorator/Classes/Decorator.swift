import Foundation

public typealias Decoration<T> = (T) -> Void

public struct Decorator<T> {
    
    let objects: [T]
}

public extension Decorator where T: DecoratorCompatible {
    
    @discardableResult
    func apply(_ decorations: Decoration<T>...) -> Decorator<T> {
        objects.forEach({ object in
            decorations.forEach({ decoration in
                decoration(object)
            })
        })
        return self
    }
    
    @discardableResult
    static func +(decorator: Decorator, decoration: @escaping Decoration<T>) -> Decorator {
        decorator.apply(decoration)
        return decorator
    }
}

public protocol DecoratorCompatible: class {
    
    associatedtype DecoratorCompatibleType
    
    var decorator: Decorator<DecoratorCompatibleType> { get }
}

public extension DecoratorCompatible {
    
    var decorator: Decorator<Self> {
        return Decorator(objects: [self])
    }
}

public extension Array where Element: DecoratorCompatible {
    
    var decorator: Decorator<Element> {
        return Decorator(objects: self)
    }
}
