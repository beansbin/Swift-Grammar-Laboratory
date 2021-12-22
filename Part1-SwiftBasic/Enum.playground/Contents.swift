import UIKit

/*
 스위프트의 열거형은 c언어와는 다른 특성을 가진다.
  - 각 항목이 그 자체의 고유한 값이 된다.
  - 그러나 원시 값(raw value)을 별도로 가질 수 있다.
  - 또한 연관 값을 가질 수 있다.
  - 하나의 타입으로 인정된다.
 */

//School 열거형의 선언
enum School {
    case primary        // 유치원
    case elementary     // 초등
    case middle         // 중등
    case high           // 고등
    case college        // 대학
    case university     // 대학교
    case graduate       // 대학원
}

// 한 줄에 모두 표현해줄 수도 있음.
/*
enum School {
    case primary, elementary, middle, high, college, university, graduate
}
 */

// School 열거형 변수 생성 및 값의 변경
var highestEducationLevel: School = School.university

highestEducationLevel = .graduate // == School.graduate



/*
 - 원시 값(raw value)을 가질 수 있음.
 - .rawValue를 이용해 값을 가져온다.
 - 일부 항목에만 원시 값을 지정해줄 수 있음.
  -> 열거형 타입이 string인 경우 : 항목값을 가짐
  -> 열거형 타입이 Int인 경우 : 0부터 순서대로 할당됨
 
*/
enum WeekDays: Character {
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
    case sun = "일"
}

let today: WeekDays = WeekDays.fri
print("오늘은 \(today.rawValue)요일입니다.") // 오늘은 금요일입니다.


/*
 - 열거형의 각 항목은 연관 값을 가질 수 있다.
 - 항목 모두가 연관 값을 가질 필요는 없다.
 */
enum MainDish {
    case pasta(taste: String)
    case pizza(dough: String, topping: String)
    case chicken(withSauce: Bool)
    case rice
}

var dinner: MainDish = MainDish.pasta(taste: "크림")  // 크림 파스타
dinner = .pizza(dough: "치즈크러스트", topping: "불고기") // 불고기 치즈크러스트 피자
dinner = .chicken(withSauce: true)  // 양념 통닭
dinner = .rice  // 밥

/*
 - 이외에 열거형은 항목 순회,
 - 순환 열거형,
 - 비교 가능한 열거형
 의 형태를 띌 수 있다.
 */
