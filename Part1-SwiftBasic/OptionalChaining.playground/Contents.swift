import UIKit

/*
 옵셔널 체이닝
  : 옵셔널을 반복 사용한 형태에서 값을 가져오거나 호출할 때 사용하는 일련의 과정
 */

// 1. 옵셔널 체이닝
// : 중첩된 옵셔널 중 하나라도 값이 존재하지 않으면 nil을 반환
// 옵셔널 체이닝의 반환 값은 옵셔널
// 그러나 강제 추출한 경우의 반환 값은 옵셔널이 아님.

// 예시 코드에 필요한 클래스들
// 사람의 주소정보 표현 설계
class Room {    // 호실
    var number: Int             // 호실 번호

    init(number: Int) {
        self.number = number
    }
}

class Building {    // 건물
    var name: String           // 건물이름
    var room: Room?       // 호실정보

    init(name: String) {
        self.name = name
    }
}

struct Address {    // 주소
    var province: String        // 광역시/도
    var city: String            // 시/군/구
    var street: String          // 도로명
    var building: Building?     // 건물
    var detailAddress: String?  // 건물 외 상세주소
    
    init(province: String, city: String, street: String) {
        self.province = province
        self.city = city
        self.street = street
    }
    
    func fullAddress() -> String? {
        var restAddress: String? = nil
        
        if let buildingInfo: Building = self.building {
            
            restAddress = buildingInfo.name
            
        } else if let detail = self.detailAddress {
            restAddress = detail
        }
        
        if let rest: String = restAddress {
            var fullAddress: String = self.province
            
            fullAddress += " " + self.city
            fullAddress += " " + self.street
            fullAddress += " " + rest
            
            return fullAddress
        } else {
            return nil
        }
    }
    
    func printAddress() {
        if let address: String = self.fullAddress() {
            print(address)
        }
    }
}

class Person {  // 사람
    var name: String            // 이름
    var address: Address?       // 주소
    
    init(name: String) {
        self.name = name
    }
}

// yagom 인스턴스 생성
let yagom: Person = Person(name: "yagom")


// 옵셔널 체이닝 문법
let yagomRoomViaOptionalChaining: Int? = yagom.address?.building?.room?.number  // address 정보가 없으므 nil을 반환
/*
let yagomRoomViaOptionalUnwraping: Int = yagom.address!.building!.room!.number  // 강제 할당 하는 경우 런타임 오류 발생!!
*/


// 옵셔널 바인딩과 옵셔널 체이닝의 사용
if let roomNumber: Int = yagom.address?.building?.room?.number {
    print(roomNumber)
} else {
    print("Can not find room number")
}

// 옵셔널 체이닝을 통한 값 할당
yagom.address?.building?.room?.number = 505
print(yagom.address?.building?.room?.number)    // nil


// 옵셔널 체이닝을 통한 메서드 호출
yagom.address?.fullAddress()?.isEmpty   // false
yagom.address?.printAddress()           // 충청북도 청주시 청원구 충청대로 곰굴


// 2. 빠른 종료(guard)
// : if 구문과 유사하게 Bool 타입의 값으로 동작하는 기능
// * else 구문이 필수 - 상위 코드 블록을 종료하는 코드가 필수(return, break, continue, throw..)
// -> 즉, 특정 블록 내부에 속해있지 않으면 사용 불가능

// 예외사항만을 처리하고 싶은 경우 유용
// if 구문을 사용한 코드
for i in 0...3 {
    if i == 2 {
        print(i)
    } else {
        continue
    }
}

// guard 구문을 사용한 코드
for i in 0...3 {
    guard i == 2 else {
        continue
    }
    print(i)
}

// 옵셔널 바인딩으로도 활용 가능
// : if 구문과 다르게 값이 있는 경우 guard 이후 코드에서 옵셔널 바인딩된 상수 값 사용 가능
func greet(_ person: [String: String]) {
    guard let name: String = person["name"] else {
        return
    }
    
    print("Hello \(name)!")
    
    guard let location: String = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    
    print("I hope the weather is nice in \(location).")
}

var personInfo: [String: String] = [String: String]()
personInfo["name"] = "Jenny"

greet(personInfo)
// Hello Jenny!
// I hope the weather is nice near you.

personInfo["location"] = "Korea"

greet(personInfo)
// Hello Jenny!
// I hope the weather is nice in Korea.


// 쉼표(,)를 이용해 구체적인 조건 추가 가능(쉼표 == &&)
func enterClub(name: String?, age: Int?) {
    guard let name: String = name, let age: Int = age, age > 19, name.isEmpty == false else {
        print("You are too young to enter the club")
        return
    }
    
    print("Welcome \(name)!")
}

enterClub(name: "Joo Young", age: 30)
// Welcome Joo Young!

