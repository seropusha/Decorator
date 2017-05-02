import Foundation

public typealias Decoration<T> = (T) -> Void

public func +<T:DecorationCompatible>(lhs: @escaping Decoration<T>, rhs: @escaping Decoration<T>) -> Decoration<T> {
    return { (value: T) -> Void in
        lhs(value)
        rhs(value)
    }
}

public struct Decorator<T> {
    
    let objects: [T]
}

public extension Decorator where T: DecorationCompatible {
    
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

public protocol DecorationCompatible: class {
    
    associatedtype DecorationCompatibleType
    
    var decorator: Decorator<DecorationCompatibleType> { get }
}

public extension DecorationCompatible {
    
    var decorator: Decorator<Self> {
        return Decorator(objects: [self])
    }
    
    var look: AnyHashable? {
        get {
            return objc_getAssociatedObject(self, &DecorationCompatibleRuntimeKeys.look) as? AnyHashable
        }
        set(value) {
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &DecorationCompatibleRuntimeKeys.look, value, policy)
            guard let value = value else { return }
            guard let decoration = looks[value] else { return }
            decorator.apply(decoration)
        }
    }
    
    func prepare(look key: AnyHashable, decoration value: @escaping Decoration<Self>) {
        var looks = self.looks
        looks[key] = value
        self.looks = looks
        guard let look = self.look else { return }
        self.look = look
    }
}

public extension Sequence where Iterator.Element: DecorationCompatible {
    
    var decorator: Decorator<Iterator.Element> {
        return Decorator(objects: Array<Iterator.Element>(self))
    }
}

struct DecorationCompatibleRuntimeKeys {
    static var look = "\(#file)+\(#line)"
    static var looks = "\(#file)+\(#line)"
}

extension DecorationCompatible {
    
    var looks: [AnyHashable:Decoration<Self>] {
        get {
            return objc_getAssociatedObject(self, &DecorationCompatibleRuntimeKeys.looks) as? [AnyHashable:Decoration<Self>] ?? [:]
        }
        set(value) {
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &DecorationCompatibleRuntimeKeys.looks, value, policy)
        }
    }
}
