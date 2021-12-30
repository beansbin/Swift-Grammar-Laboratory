import UIKit

/* 클로져
 : 일정 기능을 하는 코드를 하나의 블록으로 모아놓은 것
 * 함수는 클로저의 한 형태
 * 클로저의 표현은 매우 다양함.
 * 클로저 표현 방법(함수 형태x, 블록 형태o)
    1) 기본 클로저
    2) 후행 클로저
 * 클로저의 형태 및 특징
    1) 클로저 표현 간소화
    2) 값 획득
    3) 탈출 클로저
    4) 자동 클로저
 */

/* ****************************************
 - 클로저의 표현 방법
 * ****************************************/

// 1. 기본 클로저(클로저의 기본 표현)
/*
{ (매개변수들) -> 반환 타입 in
    ..code..
}
 */
// sorted(by:) 메서드에 클로저 전달
// backwards(first:second:) 함수 대신에 sorted(by:) 메서드의 전달인자로 클로저를 직접 전달.
let names: [String] = ["wizplan", "eric", "yagom", "jenny"]
let reversed: [String] = names.sorted (by: { (first: String, second: String) -> Bool in
    return first > second
})
print(reversed)     // ["yagom", "wizplan", "jenny", "eric"]

// 2. 후행 클로저
// : 함수의 마지막 전달인자로 위치하는 클로저는 소괄호를 닫은 후 작성 가능
// 다중 후행 클로저 사용 가능
let reversed2: [String] = names.sorted() { (first: String, second: String) -> Bool in
   return first > second
}

// sorted(by:) 메서드의 소괄호까지 생략 가능.
let reversed3: [String] = names.sorted { (first: String, second: String) -> Bool in
   return first > second
}


func doSomething(do: (String) -> Void,
                onSuccess: (Any) -> Void,
                onFailure: (Error) -> Void) {
   // do something...
}

// 다중 후행 클로저의 사용 : 첫 번째 클로저의 전달인자 레이블은 생략
doSomething { (someString: String) in
   // do closure
} onSuccess: { (result: Any) in
   // success closure
} onFailure: { (error: Error) in
   // failure closure
}



/* ****************************************
 - 클로저의 형태 및 특징
 * ****************************************/

// 1. 클로저 표현 간소화
// 1-1. 문맥을 이용한 타입 유추
// 클로저의 매개변수 타입과 반환 타입을 생략하여 표현할 수 있음.
let reversed4: [String] = names.sorted { (first, second) in
    return first > second
}

// 1-2. 단축 인자 이름
// 매개변수 이름을 $0 형태로 변경해 사용 가능
// in 사용x
let reversed5: [String] = names.sorted {
    return $0 > $1
}

// 1-3. 암시적 반환 표현
// 반환 값을 갖고 코드가 한 줄이라면, return 키워드 생략 가능
let reversed6: [String] = names.sorted { $0 > $1 }

// 1-4. 연산자 함수
// 함수는 클로저의 일종이므로, 연산자 함수는 매개변수에 들어갈 수 있음.
let reversed7: [String] = names.sorted(by: >)


// 2. 값 획득
// 클로저는 주변 문맥의 상수, 변수를 획득해 저장할 수 있음.
// 즉, 정의된 상수, 변수가 더 이상 존재하지 않아도 저장된 값을 클로저 내부에서 접근 가능함.
// 즉, 클로저는 참조 타입이다.
func makeIncrementer(forIncrement amount: Int) -> (() -> Int) {
    // () -> Int : 함수 객체를 반환한다는 의미
    
    var runningTotal = 0
    func incrementer() -> Int { // 별개로 존재할 수 없음
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// incrementByTwo 상수에 함수 할당
let incrementByTwo: (() -> Int) = makeIncrementer(forIncrement: 2) // 해당 클로저가 runningTotal의 값을 획득한 것. 상수에 클로저의 참조를 할당(깂x)

let first: Int = incrementByTwo()   // 2
let second: Int = incrementByTwo()  // 4
let third: Int = incrementByTwo()   // 6


// 3. 탈출 클로저 : @escaping
// 함수의 전달인자로 전달한 클로저가 함수 종료 이후에 호출되는 경우의 클로저, 함수를 탈출한다.
// 기본적으로는 비탈출 클로저
// 탈출 클로저 조건
// 1) 함수 외부로 다시 전달되어 사용할 수 있을 때
// 2) 외부 변수에 저장하는 경우
// ex. 비동기 함수의 completion handler
// 탈출 조건이 명확한데 @escapig을 명시해주지 않으면 컴파일 오류 발생
var completionHandlers: [() -> Void] = [] // () ->  Void

// 탈출 클로저를 매개변수로 갖는 함수
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

typealias VoidVoidClosure = () -> Void

let firstClosure: VoidVoidClosure = {
    print("Closure A")
}

let secondClosure: VoidVoidClosure = {
    print("Closure B")
}

// first와 second 매개변수 클로저는 함수의 반환 값으로 사용될 수 있으므로 탈출 클로저.
func returnOneClosure(first: @escaping VoidVoidClosure, second: @escaping VoidVoidClosure, shouldReturnFirstClosure: Bool) -> VoidVoidClosure {
    // 전달인자로 전달받은 클로저를 함수 외부로 다시 반환하기 때문에 함수를 탈출하는 클로저.
    return shouldReturnFirstClosure ? first : second
}

// 함수에서 반환한 클로저가 함수 외부의 상수에 저장되었음.
let returnedClosure: VoidVoidClosure = returnOneClosure(first: firstClosure, second: secondClosure, shouldReturnFirstClosure: true)

returnedClosure()   // Closure A


var closures: [VoidVoidClosure] = []

// closure 매개변수 클로저는 함수 외부의 변수에 저장될 수 있으므로 탈출 클로저.
func appendClosure(closure: @escaping VoidVoidClosure) {
    
    // 전달인자로 전달받은 클로저가 함수 외부의 변수 내부에 저장되므로 함수를 탈출함.
    closures.append(closure)
}

// 타입 내부 메서드의 매개변수 클로저에 @escaping을 명시적으로 사용하는 경우 타입 내부 값에 접근할 때는 self가 필수. (비탈출 클로저는 선택)
func functionWithNoescapeClosure(closure: VoidVoidClosure) {
    closure()
}

func functionWithEscapingClosure(completionHandler: @escaping VoidVoidClosure) -> VoidVoidClosure {
    return completionHandler
}


class SomeClass {
    var x = 10
    
    func runNoescapeClosure() {
        // 비탈출 클로저에서 self 키워드 사용은 선택 사항.
        functionWithNoescapeClosure { x = 200 }
    }
    
    func runEscapingClosure() -> VoidVoidClosure {
        // 탈출 클로저에서는 명시적으로 self를 사용해야 함.
        return functionWithEscapingClosure { self.x = 100 }
    }
}

let instance: SomeClass = SomeClass()
instance.runNoescapeClosure()
print(instance.x)   // 200

let returnedClosure2: VoidVoidClosure = instance.runEscapingClosure()
returnedClosure2()
print(instance.x)   // 100


// 4. 자동 클로저
// 함수의 전달인자로 전달하는 표현을 자동으로 변환해주는 클로저
// 전달 인자를 갖지 않음
// 자동 클로저를 호출하는 함수를 구현하는 일은 드물 것.
var customersInLine = ["YoangWha", "SangYong", "SungHun", "HaMi"]

// 자동 클로저 매개변수에 String값 할당 -> 매개변수가 없는 String값 반환 클로저로 변환
func serveCustomer(_ customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serveCustomer(customersInLine.removeFirst()) // "Now serving YoangWha!"

