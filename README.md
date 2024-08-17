# 💡 Topic

- 길거리 음식 가게 위치 및 정보 공유 플랫폼
- 이용자와 정보를 공유하며 만드는 동네 길거리 음식 지도
- 포털 사이트에 검색해도 나오지 않는 길거리 음식점 위치를 사용자들이 등록
- 길거리 음식점에 대한 이미지와 리뷰를 사용자들이 추가할 수 있는 기능 제공
- 사용자들 간 채팅 기능을 제공하며 채팅창에서 개인이 즐겨 찾기 한 음식점을 공유

# 📝 Summary

겨울에 친구와 붕어빵이 생각나 동네 곳곳을 뒤져 봤지만, 허탕을 친 경험이 있었는데 문득 돌아다니며 동네 곳곳에 존재하는 길거리 음식점을 기록해서 생각날 때마다 찾아가면 좋겠다는 생각이 들어 시작한 서비스입니다. 처음에는 소수의 인원이 사용할 목적으로 개발을 진행했지만, 주변 반응들이 좋아 기능과 서비스를 확장하고 있으며 지금도 계속 개발을 진행하고 있는 프로젝트입니다.
# ⭐️ Key Function

- **로그인**
    - 구글 로그인, 이메일 로그인을 지원
    - 이메일 로그인 진행시 프로필 이미지를 저장할 수 있으며 중복된 아이디 또는 암호 규칙에 어긋나는 경우 오류 메세지를 제공함
    - 처음 로그인에 성공했을 경우 **자동 로그인 기능**을 제공함
- **길거리 음식점 등록**
    - 매장 등록 시 지도를 터치하면 마커가 생성됨과 동시에 해당 위치에 주소를 보여줌
    - 가게 이름, 가게 형태, 결제 방식, 출몰 시기, 메뉴 카테고리 기능을 제공함
    - 결제방식, 출몰 시기, 메뉴 카테고리는 다중 선택이 가능하고 취소가 가능함
    - 가게 등록 페이지에서 현재 위치를 지도에 마커로 확인 가능함
- **길거리 음식 지도**
    - 화면 하단에 리스트 형태로 정보를 제공하며 가게 이름, 가게 위치, 리뷰, 판매하는 음식의 아이콘을 제공함
    - 현재 사용자 위치에서 길거리 음식점까지의 거리를 제공함
    - 리스트를 swipe 할 시 변경된 음식점의 위치로 카메라를 이동
    - 길거리 음식점에서 판매하는 음식 리스트를 해시태그로 제공함
- **사용자 간 채팅 기능 제공**
    - 상대방과 실시간 대화가 가능한 채팅 기능을 제공
    - 상대방의 프로필 사진과 메세지를 읽음 유무를 확인할 수 있는 기능을 제공함
    - 갤러리와 카메라를 통해 이미지를 전송하는 기능 제공
    - DB에 저장된 사용자의 맛집 즐겨 찾기 리스트를 가져오고 채팅방에 공유가 가능함
    - 채팅 리스트에서 사용자 간 가장 마지막에 보낸 메세지를 확인할 수 있는 기능 제공
    - `scrollController` 를 사용해 페이지 scroll 조정 기능 구현
    
- 마이 페이지
    - 사용자의 프로필 이미지와 아이디를 제공함
    - 사용자가 즐겨 찾기로 추가한 가게를 리스트 형태로 제공함
    - 사용자가 직접 등록한 가게를 리스트 형태로 제공함
    - **참여도를 위해 미션 기능**을 추가함
    - **미션을 완료 할 시** 토스트 메시지를 제공하고 마이페이지에 칭호를 확인할 수 있음

# 🤚🏻 Part

- **개인 프로젝트 (기획, 개발, 디자인 등)**

# 💡 Learned

- 프로젝트 진행 중 인스턴스(객체)를 변경해야하는 상황에 `freezed_annotation` 활용하였으며  copy, copyWith를 사용해 문제를 해결하는 경험을 함
- 평소 학습이 부족하다 생각이 들었던 `firebase` 를 더 깊이 공부하고 활용하는 경험을 함
- `fireStorage` 에 저장되는 다량의 이미지들의 용량을 줄이는 문제를 해결해야 헀으며 이는 `flutter_image_compress`를 사용해 이미지를 압축해 저장하는 방식으로 용량을 줄여 문제를 해결한 경험이 있음.
- `geolocator`를 사용해 사용자의 위치를 불러왔으나 위치를 불러오는 시간이 길어 null오류를 발생시키는 문제가 발생했으며 이는 `FutureBuilder` 와`StreamBuilder`,`loading_animation_widget`를 사용해 문제를 해결함
- UI UX에 대해 깊이 고민하는 시간을 가졌으며 길거리 음식 지도와 길거리 음식 리스트를 함께 보여주며 매초마다 리스트가 전환되는 효과를 주기 위해 `carousel_slider`를 활용하는 경험을 함
- `go_router`를 사용해 router를 관리하는 방법을 익힘
- 생산성과 코드의 간결함을 위해 `velocity_x` 를 적극 활용함

  # 📷 Screenshot

## 📷 로그인 및 회원가입 페이지

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/99357982-9b7a-4247-99ef-234d3d7982f2/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/0eac2156-e9a7-4037-a353-6ce828f00a0e/Untitled.jpeg)

## 📷 메인 페이지

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/e5de7dda-7887-43ce-b86d-f929b0b95ecf/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/029ae52a-cabc-4f52-a81e-aeae260a7d8e/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/a11e7382-816e-4901-ad4b-035946be5e9e/Untitled.jpeg)

![Screenshot_20240424_191318.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/7d735aa7-cfd0-4489-ba27-3abc77a67d1d/Screenshot_20240424_191318.jpg)

## 📷 채팅 페이지, 마이 페이지

![1.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/9b906f83-b6c9-4885-a46f-f6b6a7cd9163/1.jpg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/46e71430-9506-4a38-8df7-5fc2c530a9a1/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/85014382-8b93-4600-843b-a09c65150257/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/919dd54b-1e56-4634-993d-03eccff6dddc/Untitled.jpeg)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/8d4555d8-efeb-48b6-9107-95cf98ed5402/Untitled.jpeg)

![2.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/86169fb8-5603-46a3-85c1-e2da7e460ba3/c665337e-14bd-42b3-a4b8-f74a22d98034/2.jpg)
