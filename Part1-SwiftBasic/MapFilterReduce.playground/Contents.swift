import UIKit

/*
 맵, 필터 리듀스
  : 고차함수의 일종(함수를 매개변수로 갖는 함수)
 */

// 1. 맵(map) : 기존 데이터를 변형
// 컨테이너의 각각의 값을 -> 전달받은 함수에 적용 후 -> 새로운 컨테이너에 생성 후 반환
// 배열, 딕셔너리, 세트, 옵셔널 등에 사용 가능

// for-in 구문과 map 메서드의 비교
let numbers: [Int] = [0, 1, 2, 3, 4]

var doubledNumbers: [Int] = [Int]()
var strings: [String] = [String]()

// for 구문 사용
for number in numbers {
    doubledNumbers.append(number * 2)
    strings.append("\(number)")
}

print(doubledNumbers)   // [0, 2, 4, 6, 8]
print(strings)          // ["0", "1", "2", "3", "4"]


// map 메서드 사용
doubledNumbers = numbers.map({ (number: Int) -> Int in
    return number * 2
})
strings = numbers.map({ (number: Int) -> String in
    return "\(number)"
})

print(doubledNumbers)   // [0, 2, 4, 6, 8]
print(strings)          // ["0", "1", "2", "3", "4"]


// 클로저 표현의 간략화
// 매개변수 및 반환 타입 생략
doubledNumbers = numbers.map({ return $0 * 2 } )
print(doubledNumbers)   // [0, 2, 4, 6, 8]

// 반환 키워드 생략
doubledNumbers = numbers.map({ $0 * 2 } )
print(doubledNumbers)   // [0, 2, 4, 6, 8]

// 후행 클로저 사용
doubledNumbers = numbers.map { $0 * 2 }
print(doubledNumbers)   // [0, 2, 4, 6, 8]


// 2. 필터 : 컨테이너 내부의 값을 걸러서 추출
// 매개변수로 전달되는 함수의 반환 타입은 Bool -> 새로운 컨테이너에 포함될 항목이면 true
let evenNumbers: [Int] = numbers.filter { (number: Int) -> Bool in
    return number % 2 == 0
}
print(evenNumbers)  // [0, 2, 4]

let oddNumbers: [Int] = numbers.filter{ $0 % 2 == 1 }
print(oddNumbers)   // [1, 3, 5]


// 맵과 필터 메서드의 연계 사용
let mappedNumbers: [Int] = numbers.map{ $0 + 3 }

let evenNumbers2: [Int] = mappedNumbers.filter { (number: Int) -> Bool in
    return number % 2 == 0
}
print(evenNumbers2)  // [4, 6, 8]

// mappedNumbers를 굳이 여러 번 사용할 필요가 없다면 메서드를 체인처럼 연결하여 사용할 수 있음.
let oddNumbers2: [Int] = numbers.map{ $0 + 3 }.filter{ $0 % 2 == 1 }
print(oddNumbers2)   // [3, 5, 7]


// 3. 리듀스 : 컨테이너 내부의 콘텐츠를 하나로 합하는 기능을 실행
// 1) 연산값을 반환하는 형태
// 2) 반환하지 않고 inout 매개변수로 받아 내부에서 계산하는 형태

// 1) 연산값을 반환하는 형태
let numbers2: [Int] = [1, 2, 3]

// 초깃값이 0이고 정수 배열의 모든 값을 더함.
var sum: Int = numbers2.reduce(0, { (result: Int, next: Int) -> Int in
    print("\(result) + \(next)")
    // 0 + 1
    // 1 + 2
    // 3 + 3
    return result + next
})

print(sum)  // 6

// 초깃값이 0이고 정수 배열의 모든 값을 뺀다.
let subtract: Int = numbers2.reduce(0, { (result: Int, next: Int) -> Int in
    print("\(result) - \(next)")
    // 0 - 1
    // -1 - 2
    // -3 - 3
    return result - next
})

print(subtract) // -6

// 초깃값이 3이고 정수 배열의 모든 값을 더한다.
let sumFromThree: Int = numbers2.reduce(3) {
    print("\($0) + \($1)")
    // 3 + 1
    // 4 + 2
    // 6 + 3

    return $0 + $1
}

print(sumFromThree)     // 9

// 초깃값이 3이고 정수 배열의 모든 값을 뺀다.
var subtractFromThree: Int = numbers2.reduce(3) {
    print("\($0) - \($1)")
    // 3 - 1
    // 2 - 2
    // 0 - 3
    return $0 - $1
}

print(subtractFromThree)    // -3

// 문자열 배열을 reduce(_:_:) 메서드를 이용해 연결시킨다.
let names: [String] = ["Chope", "Jay", "Joker", "Nova"]

let reducedNames: String = names.reduce("yagom's friend : ") {
    return $0 + ", " + $1
}

print(reducedNames) // "yagom's friend : , Chope, Jay, Joker, Nova"


// 2) 반환하지 않고 inout 매개변수로 받아 내부에서 계산하는 형태

// 초깃값이 0이고 정수 배열의 모든 값을 더함.
// 첫 번째 리듀스 형태와 달리 클로저의 값을 반환하지 않고 내부에서 직접 이전 값을 변경한다는 점이 다르다.
sum = numbers2.reduce(into: 0, { (result: inout Int, next: Int) in
//    0 + 1
//    1 + 2
//    3 + 3
    print("\(result) + \(next)")
    result += next
})

print(sum)  // 6

// 초깃값이 3이고 정수 배열의 모든 값을 뺍니다.
// 첫 번째 리듀스 형태와 달리 클로저의 값을 반환하지 않고 내부에서 직접 이전 값을 변경한다는 점이 다릅니다.
subtractFromThree = numbers2.reduce(into: 3, {
    print("\($0) - \($1)")
    // 3 - 1
    // 2 - 2
    // 0 - 3
    $0 -= $1
})

print(subtractFromThree)    // -3
