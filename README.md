# TDD_JuiceMaker🥤
### [기존의 UIKit 프로젝트](https://github.com/horeng2/3.ios-juice-maker)를 MVVM + RxSwift + TDD 방식으로 새롭게 구현한 프로젝트입니다.
### 주요 기능 
주스 주문, 주문  재고 차감, 과일 재고 관리 등

### 키워드
- RxSwift
- MVVM
- TDD
- UnitTest
- Input/Output

## 프로젝트 목적
- MVVM + RxSwift를 직접 적용해보며 학습
- 테스트 주도 개발 방식 경험
<br/>

---

## 💡 기능
### 주스 주문
- 주스 주문 버튼을 통해 주문할 수 있습니다.

![Simulator Screen Recording - iPhone 13 - 2022-09-06 at 17 03 34](https://user-images.githubusercontent.com/87305744/188597359-3287e74f-da00-4be0-b70c-a9ddd1b59c28.gif)

<br/>

- 과일은 주스에 필요한 개수만큼 차감됩니다.
- 재고가 부족할 경우 주문이 불가하며 알림 메세지가 발생합니다.

![Simulator Screen Recording - iPhone 13 - 2022-09-06 at 17 03 54](https://user-images.githubusercontent.com/87305744/188597700-ca4a67c6-a74a-4646-8ff8-a5a759265a6a.gif)


### 재고 관리
- 과일의 재고를 Stepper를 통해서 관리할 수 있습니다.

![Simulator Screen Recording - iPhone 13 - 2022-09-06 at 17 04 11](https://user-images.githubusercontent.com/87305744/188597738-4b4a67c4-f27f-49c2-86ce-bbfaef9dfcec.gif)
<br/>
<br/>

---

## 💡 고민점
### RxBlocking의 사용
- RxTest: 옵저버블에 시간 개념을 주입하여 원하는 시간에 방출되는 이벤트를 검증
- RxBlocking: 옵저버블의 특정시간 내의 이벤트 방출만을 검증

시간의 흐름에 따라 방출되는 이벤트를 검증하는 RxTest보다는, 단순히 방출되는 이벤트만을 검증하는 RxBlocking이 적합하다고 판단하여 이를 이용한 테스트를 진행했습니다.
<br/>

### Stream의 방향과 방식
초반 구현에는 ViewModel과 UseCase에서 옵저버블을 구독하고 새롭게 생성해서 전달하는 방식의 코드가 존재했습니다. 스트림이 중간에서 끊기는 이러한 방식은 프로젝트 규모가 커질 경우 가독성이 떨어질 수 있고, 흐름이 중간에 유실될 가능성도 있다고 판단했습니다. 

이에 하나의 스트림은 한번만 소비되도록 유의하며, 한방향으로 끊어지지 않는 흐름이 유지되도록 리팩토링 했습니다.
<br/>

### retry
현재 코드에서는 재고가 부족할 때 에러가 발생하는데, 옵저버블에서 에러가 방출되어도 스트림이 종료되지 않도록 `retry`연산자를 사용했습니다. 에러가 방출 된 후 `dipose`하고 다시 `subscribe`가 호출되어서 스트림을 계속 이어나갈 수 있도록 구현했습니다.
<br/>
<br/>

## 💡 Trouble Shooting
### skip(1)
EditViewModel에서 바인딩을 할 때의 stepperValue는 초기상태, 즉 0이기 때문에 재고값에 0이 업데이트 되는 문제가 있었습니다.
이를 해결하기 위해 아래의 시도를 했습니다.

1. Output에 현재의 재고값을 담는 딕셔너리 타입의 프로퍼티 currentStock을 추가
2. transform에서 현재 재고값을 currentStock 프로퍼티에 담아 Output을 통해서 [Fruit: Double] 형태로 뷰에 전달
    
다만, 위와 같은 방식은 뷰모델에서 옵저버블을 소비하는 방식이기 때문에 `skip(1)` 오퍼레이터를 사용하여 첫번째 이벤트는 무시하도록 구현하여 해결했습니다.
<br/>
<br/>

---

## 💡 프로젝트를 통한 학습결과
### TDD의 장점과 테스트 코드의 필요성을 직접 경험
프로젝트를 진행하며 느낀 TDD의 장점은 다음과 같습니다.
- 한가지 기능만을 테스트하는 코드를 먼저 작성하기 때문에 코드의 역할, 기능 분리가 수월해진다.
- Low Level의 코드부터 작성하기 때문에 기능을 구현하며 발생하는 관련 메소드 리팩토링 비용이 감소한다.
- 실제 코드를 수정하지 않고 다양한 상황을 테스트해볼 수 있다.
- 디버깅이 수월하다.

TDD의 단점으로는 개발 소요 시간이 증가한다 라고 알고 있는데, 퀄리티보다 빠른 결과물이 필요한 상황이라면 적합하지 않을 수 있다고 느꼈습니다.

하지만 디버깅에 소요되는 시간과 노력을 단축시킬 수 있다는 점에서, 디버깅에 자주 마주치는 초보 개발자일수록 테스트 코드를 통해 작업의 효율을 크게 올릴 수 있을 것이라고 생각했습니다.
<br/>

### UIKit + MVC로 진행한 동일 프로젝트와의 차이점 
장점
- 비즈니스 로직을 뷰모델이 관리하기 때문에 뷰의 재사용성이 좋다.
- 뷰와 비즈니스 로직이 분리되기 때문에 테스트에 용이하다.
- 한번의 구독과 다양한 오퍼레이터의 사용으로 코드가 깔끔해진다.

단점
- 옵저버블의 흐름이 한번에 보이기 어려울 수 있다.
- 메모리 관리에 더 유의해야한다.

비동기 네트워킹을 하는 앱에서 더 확실한 장점을 발휘할 수 있는 방식이라고 생각했습니다. 통신이 연결된 뒤 끊어지기 전까지 흐름을 유지하며 데이터를 가공하는 것에 적합한 방식일 것 같습니다.
또한 다양한 오퍼레이터를 적절한 상황에서 사용할 수 있도록 더 많은 공부와 경험이 필요하다고 느꼈습니다. 
