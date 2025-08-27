# Tudum Kingdom 👑✨

> "공주님은 영화가 보고싶어..."

반짝이는 코드와 설레는 아이디어로 지어진 우리만의 영화 왕국, **Tudum Kingdom**에 오신 것을 환영합니다.

<br/>

## 🏰 왕국의 모습

우리 왕국은 아래와 같이 화려하고 신비로운 모습을 자랑합니다.

| 홈 화면 (스크롤 및 배너) | 상세 화면 (애니메이션) |
| :---: | :---: |
|  |  |
| *다양한 영화 목록을 한눈에!* | *인기 영화는 별똥별 마법과 함께!* |

<br/>

## 📌 주요 기능

* **실시간 영화 정보 제공:** TMDB API를 통해 인기 영화, 현재 상영작, 평점 높은 영화, 개봉 예정작 목록을 실시간으로 표시합니다.
* **상세 정보 확인:** 영화 포스터, 줄거리, 장르, 개봉일, 제작사 등 상세한 영화 정보를 확인할 수 있습니다.
* **동적이고 미려한 UI/UX:**
    * 화면 전환 시 `Hero` 위젯을 이용한 자연스러운 포스터 애니메이션
    * 스크롤 시 깊이감을 더하는 `SliverAppBar`의 **패럴랙스(Parallax) 효과**
    * 인기 영화 상세 페이지의 **커스텀 파티클 애니메이션** (별똥별 효과)
* **반응형 UI:** `MediaQuery`를 활용하여 다양한 디바이스 화면 크기에 대응하는 반응형 레이아웃을 구현했습니다.
* **중앙 집중식 테마 관리:** `ThemeExtension`을 활용하여 앱 전체의 색상과 폰트 스타일을 일관되게 관리합니다.

<br>

## 🏛️ 프로젝트 아키텍처

본 프로젝트는 유지보수성과 테스트 용이성을 높이기 위해 **클린 아키텍처(Clean Architecture)**를 기반으로 설계되었으며, Presentation Layer에서는 **MVVM(Model-View-ViewModel)** 패턴을 적용했습니다.

### Directory Structure

lib/
├── data/         # Data Layer: 데이터 소스 및 외부 데이터 처리
│   ├── data_source/  # API 통신 등 실제 데이터 I/O
│   ├── dto/          # Data Transfer Object (API 원본 데이터 모델)
│   └── repository/   # Repository 구현체 (DTO to Entity 변환)
│
├── domain/       # Domain Layer: 핵심 비즈니스 로직 및 규칙
│   ├── entity/       # 앱의 핵심 데이터 모델
│   ├── repository/   # Repository 인터페이스 (Domain과 Data 계층의 계약)
│   └── usecase/      # 특정 비즈니스 로직 단위
│
└── presentation/ # Presentation Layer: UI 및 상태 관리
├── home/         # 홈 화면 (View)
├── detail/       # 상세 화면 (View)
├── view_model/   # ViewModel
├── theme/        # 앱 테마 및 스타일
└── widgets/      # 공용 UI 위젯


* **Data Layer:** `Dio`를 사용하여 TMDB API와 통신하고, 응답받은 JSON 데이터를 `DTO`로 변환합니다. `Repository` 구현체는 `DataSource`로부터 `DTO`를 받아 `Domain Layer`의 `Entity`로 가공하여 전달합니다.
* **Domain Layer:** 외부의 변화에 영향을 받지 않는 순수한 비즈니스 로직을 포함합니다. `Entity`는 앱의 핵심 데이터 구조이며, `UseCase`는 특정 기능(예: '인기 영화 목록 가져오기')을 수행합니다.
* **Presentation Layer:** `Riverpod`를 사용하여 `ViewModel`을 UI에 제공합니다. `View`(Screen)는 `ViewModel`의 상태 변화를 구독(`watch`)하고, 상태에 따라 UI를 렌더링합니다. 사용자의 입력은 `ViewModel`에 전달되어 비즈니스 로직 처리를 `UseCase`에 위임합니다.

<br>

## 🛠️ 적용 기술 및 학습 내용

* **State Management:** `Riverpod`
    * `Provider`, `StateNotifierProvider`, `family` 등을 활용하여 의존성 주입(DI) 및 비동기 상태를 포함한 앱 전반의 상태를 관리했습니다.
* **Navigation:** `go_router`
    * URI 기반의 선언형 라우팅을 구현하여 화면 간 이동 및 데이터 전달 로직을 체계적으로 관리했습니다. `push`와 `go`의 차이를 이해하고 적용하여 자연스러운 내비게이션 스택을 구성했습니다.
* **Networking:** `Dio` & `flutter_dotenv`
    * `Interceptor`를 활용하여 API 요청 헤더에 인증 토큰을 일괄적으로 추가했습니다.
    * `.env` 파일을 통해 API 키를 안전하게 관리하고, `pubspec.yaml`의 `assets` 등록의 중요성을 학습했습니다.
* **Animation:**
    * **`Hero` Widget:** 화면 전환 시 공유 요소(포스터 이미지)의 자연스러운 전환 효과를 구현했습니다.
    * **`SliverAppBar` & `FlexibleSpaceBar`:** 스크롤에 따라 `AppBar`가 축소되며 배경 이미지가 움직이는 **Parallax Effect**를 구현했습니다.
    * **`AnimationController` & `StatefulWidget`:** 컨트롤러의 생명주기(`initState`, `dispose`)와 `addStatusListener`를 이용한 수동 루프를 통해 조건부 커스텀 파티클 애니메이션(별똥별 효과)을 구현했습니다.
* **Theming & Responsive UI:**
    * **`ThemeExtension`:** 앱의 커스텀 색상 시스템을 구축하여 모든 UI 요소에서 일관된 테마를 적용했습니다.
    * **`MediaQuery`:** 화면의 너비와 높이를 기준으로 위젯의 크기와 여백을 동적으로 계산하여 반응형 UI를 구현했습니다.
* **Code Convention & Etc:**
    * `const` 생성자를 적극적으로 사용하여 불필요한 위젯 리빌드를 방지하고 성능을 최적화했습니다.
    * `BuildContext`의 `extension`을 만들어 반복적인 코드(`MediaQuery.of(context)...`)를 줄이고 가독성을 향상시켰습니다.

<br>

## 🌐 사용된 API

| Method | Endpoint                                | Description                 |
| :----- | :-------------------------------------- | :-------------------------- |
| `GET`  | `/movie/popular`                        | 인기 영화 목록 조회         |
| `GET`  | `/movie/now_playing`                    | 현재 상영중인 영화 목록 조회 |
| `GET`  | `/movie/top_rated`                      | 평점 높은 영화 목록 조회    |
| `GET`  | `/movie/upcoming`                       | 개봉 예정 영화 목록 조회    |
| `GET`  | `/movie/{movie_id}`                     | 특정 영화의 상세 정보 조회  |

<br>

## 🚀 설치 및 실행 방법

1.  **Repository 복제**
    ```bash
    git clone [Repository URL]
    ```
2.  **.env 파일 생성**
    프로젝트 루트 디렉토리에 `.env` 파일을 생성하고 아래 내용을 추가합니다.
    ```
    TMDB_ACCESS_TOKEN=[YOUR_TMDB_API_ACCESS_TOKEN]
    ```
3.  **패키지 설치**
    ```bash
    flutter pub get
    ```
4.  **앱 실행**
    ```bash
    flutter run
    ```

<br>

