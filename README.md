# DS_TeamProject2023
 2023년 2학기 명지대학교 디지털시스템 2조 고명성, 김영찬, 송윤석

 베릴로그를 이용한 미니컬링게임.

 ![image](https://github.com/kms0511/DS_TeamProject2023/assets/148463076/51bd7bde-5b62-4176-90a1-f07a83e671ef)



 
게임 방법 (키패드는 PMOD C에 PMOD KYPD모듈을 연결하여 사용)

키패드 조작:

key_pulse 1 : 세트 시작

key_pulse 2 : 스톤의 위치 및 스핀방향 선택

key_pulse 3 : 스톤에 가할 힘 선택

key_pulse A : 직진 방향으로 스위핑 동작

key_pulse B : 스핀 방향으로 스위핑 동작

key_pulse D : NEXT GAME? 출력 시, 다음 세트의 게임 진행 선택 (점수이어하기)

key_pulse F  : NEXT GAME? 출력 시, 게임 세트 및 점수 reset 


각 세트의 첫 플레이어는 키패드1 을 눌러 세트를 시작한다.
세트가 시작되면 순서에 맞는 스톤이 대기장소에서 시작라인으로 텔레포트 되며, 좌우 왕복이동을 시작한다. 이 때, 키패드2를 눌러 시작 위치와 스핀방향을 확정하게 된다. 시작위치는 멈춘 그 자리이며, 스핀방향은 멈출 때 이동하고 있던 방향으로 정해진다.
위치 및 스핀방향 설정이 끝나면, 하단의 파워게이지의 지시계가 좌우 왕복이동을 시작한다. 하늘-연두-노랑-주황-빨강 순으로 파워 약 -> 강 이며, 키패드 3을 눌러 지시계를 멈추고, 지시계가 멈춘 위치가 스톤에 가해질 힘이다.
힘 설정까지 완료되고 나면 약 1초뒤 자동으로 스톤이 설정된 값으로 이동을 시작한다. 이 때, 키패드 A를 연타하면 직진방향의 속력의 감소가 늦어지고 ( 빠를 때에는 해도 차이가 없다) B를 연타하면 스핀방향으로 방향이 조금 변화한다.  단, 브룸이 실제로도 속력을 증가시키는 것이 아닌, 마찰력을 감소시킨다는 점과 같이,  정지상태에서는 작동하지 않으며, 또한 일정횟수 사용되었다면 더이상 효과가 없다.
스톤은 이동하며 벽에 부딪히면 튕겨 나오고, 다른 스톤과 충돌할 경우, 충돌 방향에 따라 다르게 튕겨 나온다.  수직충돌의 경우에는 정지하게된다.
위의 조작방법을 이용하여 표적의 중심에 가까우면서, 자신의 팀의 스톤이 순서대로 최대한 전부 이어지게 하는 것이 게임의 승리 방법이다.

작동영상: https://youtu.be/kMXLUSBVb8M

충돌 및 점수 알고리즘 영상: https://youtu.be/TDfz1sOkxdo

