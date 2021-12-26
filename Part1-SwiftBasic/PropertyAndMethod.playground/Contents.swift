import UIKit

var greeting = "Hello, playground"

/*
 1. 프로퍼티
  - 저장 프로퍼티 : 인스턴스 변수, 상수
  - 연산 프로퍼티
  - 타입 프로퍼티 : 클래스 변수, 상수
*/

// 1) 저장 프로퍼티
struct CoordinatePoint {
    var x: Int = 0    // 저장 프로퍼티와 기본값 0
    var y: Int = 0     // 저장 프로퍼티와 기본값 0
}

// 1-1) 지연 저장 프로퍼티(lazy var)
// : 인스턴스가 초기화(생성)될 때 값이 할당되는 프로퍼티
// : 옵셔널은 값이 필요없는 경우,
// : 상수는 인스턴스 생성 이전에 할당해야하므로 용도가 다르다.
class Position {
    lazy var point: CoordinatePoint = CoordinatePoint()
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

let yagomPosition: Position = Position(name: "yagom")
// 이 코드를 통해 point 프로퍼티로 처음 접근할 때 point 프로퍼티의 CoordinatePoint가 생성된다.

print(yagomPosition.point)  // x: 0, y: 0


// 2) 연산 프로퍼티
// : 값을 저장하는 것이 아니라 연산을 위한 프로퍼티
// : getter, setter의 역할을 함
// : setter만 따로 구현 불가능 (getter는 가능)
// : 클래스, 구조체, 열거형에 정의 가능
struct CoordinatePoint2 {
    var x: Int  // 저장 프로퍼티
    var y: Int  // 저장 프로퍼티
    
    // 대칭 좌표
    var oppositePoint: CoordinatePoint2 {    // 연산 프로퍼티
        // 접근자
        get {
            return CoordinatePoint2(x: -x, y: -y)
        }
        
        // 설정자
        set(opposite) {
            x = -opposite.x
            y = -opposite.y
        }
    }
    // 하나의 프로퍼티에 getter, setter가 모여있어 어떤 역할인지 명확하게 표현됨
    // 설정자 매개변수 이름은 newValue로 대체 가능
}

var yagomPosition2: CoordinatePoint2 = CoordinatePoint2(x: 10, y: 20)

// 현재 좌표
print(yagomPosition)    // 10, 20

// 대칭 좌표, 프로퍼티이므로 .연산자로 접근
print(yagomPosition2.oppositePoint)  // -10, -20

// 대칭 좌표를 (15, 10)으로 설정하면
yagomPosition2.oppositePoint = CoordinatePoint2(x: 15, y: 10)

// 현재 좌표는 -15, -10으로 설정됨.
print(yagomPosition2)    // -15, -10



// 2-2) 프로퍼티 감시자(Property Observers)
// : 프로퍼티의 값이 새로 할당될 때마다 호출
// : 저장 프로퍼티, 연산 프로퍼티에서 구현 가능
class Account {
    var credit: Int = 0 {
        willSet { // 변경될 프로퍼티 값
            print("잔액이 \(credit)원에서 \(newValue)원으로 변경될 예정입니다.")
        }
        
        didSet { // 변경되기 전 프로퍼티 값
            print("잔액이 \(oldValue)원에서 \(credit)원으로 변경되었습니다.")
        }
    }
}

let myAccount: Account = Account()

// print: 잔액이 0원에서 1000원으로 변경될 예정입니다.
myAccount.credit = 1000
// print: 잔액이 0원에서 1000원으로 변경되었습니다.


// 3) 타입 프로퍼티
// : 클래스 변수에 해당하는 개념, 인스턴스의 공용 값을 정의할 때 유용
// : 타입 이름만으로 프로퍼티 접근 및 사용 가능
// : 저장 타입 프로퍼티, 연산 타입 프로퍼티 정의 가능

class AClass {
    
    // 저장 타입 프로퍼티
    static var typeProperty: Int = 0
    
    // 저장 인스턴스 프로퍼티
    var instanceProperty: Int = 0 {
        didSet {
            // Self.typeProperty는
            // AClass.typeProperty와 같은 표현입니다
            Self.typeProperty = instanceProperty + 100
        }
    }
    
    // 연산 타입 프로퍼티
    static var typeComputedProperty: Int {
        get {
            return typeProperty
        }
        
        set {
            typeProperty = newValue
        }
    }
}

AClass.typeProperty = 123

let classInstance: AClass = AClass()
classInstance.instanceProperty = 100

print(AClass.typeProperty)  // 200
print(AClass.typeComputedProperty)  // 200




/*
 2. 메서드
 : 스위프트는 구조체와 열거형도 메서드를 가질 수 있다!
  - 인스턴스 메서드
  - 타입 메서드
*/

// 1. 구조체, 열거형의 메서드
// : 값 타입이므로 mutating 키워드로 자신의 프로퍼티 값을 수정하는 것을 표시함
struct LevelStruct {
    var level: Int = 0 {
        didSet {
            print("Level \(level)")
        }
    }
    
    mutating func levelUp() {
        print("Level Up!")
        level += 1
    }
    
    mutating func levelDown() {
        print("Level Down")
        level -= 1
        if level < 0 {
            reset()
        }
    }
    
    mutating func jumpLevel(to: Int) {
        print("Jump to \(to)")
        level = to
    }
    
    mutating func reset() {
        print("Reset!")
        level = 0
    }
}


var levelStructInstance: LevelStruct = LevelStruct()
levelStructInstance.levelUp()        // Level Up!
// Level 1
levelStructInstance.levelDown()      // Level Down
// Level 0
levelStructInstance.levelDown()      // Level Down
// Level -1
// Reset!
// Level 0
levelStructInstance.jumpLevel(to: 3)   // Jump to 3
// Level 3


// 2. 타입 메서드
// : static으로 정의하면 상속 후 메서드 재정의 불가능
// : class로 정의하면 가능
class A2Class {
    static func staticTypeMethod() {
        print("AClass staticTypeMethod")
    }
    
    class func classTypeMethod() {
        print("AClass classTypeMethod")
    }
}

class B2Class: A2Class {
    /*
     // 오류 발생!! 재정의 불가!
     override static func staticTypeMethod() {
     
     }
     */
    override class func classTypeMethod() {
        print("BClass classTypeMethod")
    }
}

A2Class.staticTypeMethod()   // AClass staticTypeMethod
A2Class.classTypeMethod()    // AClass classTypeMethod
B2Class.classTypeMethod()    // BClass classTypeMethod

