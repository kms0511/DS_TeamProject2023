# DS_TeamProject2023
<div align=center>
<table>
  <tr>
    <th align=center>프로젝트명</th>
    <th>베릴로그를 이용한 미니컬링게임</th>
  </tr>
  <tr>
    <th align=center width=30%>강의수강</th>
    <td width=70%>2023.09~12, 2023-2학기 디지털시스템</td>
  </tr>
  <tr>
    <th align=center>주요일정</th>
    <td>
     (a) 2023. 12. 12(화) : 프로젝트 검사<br>
     (b) 2023. 12. 15(금) : 조별최종보고서, 개인별자기평가보고서 제출 마감
    </td>
  </tr>
  <tr>
    <th align=center>프로젝트 수행기간</th>
    <td>
2023. 11. 23 ~ 12. 12 (약 3주)<br>
    </td>
  </tr>
  <tr>
    <th align=center>Software</th>
    <td>
Code Editor: 
<a href="https://www.xilinx.com/products/design-tools/vivado.html" target="_blank">
		<img src="https://img.shields.io/badge/Vivado-D5D66A?style=flat&logo=amd&logoColor=white"/>
</a>
<a href="[https://visualstudio.microsoft.com/ko/#vs-section](https://code.visualstudio.com/)">
		<img src="https://img.shields.io/badge/Visual Studio Code-007ACC?style=flat&logo=visualstudiocode&logoColor=white"/>
</a>
<br>
Language:
<a href="" target="_blank">
		<img src="https://img.shields.io/badge/Verilog-E01F27?style=flat&logo=v&logoColor=white"/>
</a>
    </td>
  </tr>
  <tr>
    <th align=center>Hardware</th>
    <td>
Kit: <code>Mainboard: ZedBoard</code><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://www.xilinx.com/content/dam/xilinx/imgs/prime/AES-Z7EV-7Z020-G_xlxlg.jpg" width="18%">
    </td>
  </tr>
</table>

<img src="https://github.com/kms0511/DS_TeamProject2023/assets/148463076/51bd7bde-5b62-4176-90a1-f07a83e671ef" width="70%">
</div>
<!--2023년 2학기 명지대학교 디지털시스템 2조 고명성, 김영찬, 송윤석-->
<!--![image](https://github.com/kms0511/DS_TeamProject2023/assets/148463076/51bd7bde-5b62-4176-90a1-f07a83e671ef)-->

# 게임 방법
(키패드는 PMOD C에 PMOD KYPD모듈을 연결하여 사용)
#### 키패드 조작:
- START
  - key_pulse 1 : 세트 시작
- stone
  - key_pulse 2 : 스톤의 위치 및 스핀방향 선택
  - key_pulse 3 : 스톤에 가할 힘 선택
- sweeping
  - key_pulse A : 직진 방향으로 스위핑 동작
  - key_pulse B : 스핀 방향으로 스위핑 동작
- NEXT GAME
  - key_pulse D : NEXT GAME? 출력 시, 다음 세트의 게임 진행 선택 (점수이어하기)
  - key_pulse F  : NEXT GAME? 출력 시, 게임 세트 및 점수 reset 

# 프로젝트 설명
1. 각 세트의 첫 플레이어는 키패드1 을 눌러 세트를 시작한다.<p>
2. 세트가 시작되면 순서에 맞는 스톤이 대기장소에서 시작라인으로 텔레포트 되며, 좌우 왕복이동을 시작한다.
	- 이 때, 키패드2를 눌러 시작 위치와 스핀방향을 확정하게 된다.
	- 시작위치는 멈춘 그 자리이며, 스핀방향은 멈출 때 이동하고 있던 방향으로 정해진다.<p>
3. 위치 및 스핀방향 설정이 끝나면, 하단의 파워게이지의 지시계가 좌우 왕복이동을 시작한다.
	- 하늘-연두-노랑-주황-빨강 순으로 파워 약 -> 강 이며, 키패드 3을 눌러 지시계를 멈추고, 지시계가 멈춘 위치가 스톤에 가해질 힘이다.<p>
4. 힘 설정까지 완료되고 나면 약 1초뒤 자동으로 스톤이 설정된 값으로 이동을 시작한다.
	- 이 때, 키패드 A를 연타하면 직진방향의 속력의 감소가 늦어지고 ( 빠를 때에는 해도 차이가 없다) B를 연타하면 스핀방향으로 방향이 조금 변화한다.
	- 단, 브룸이 실제로도 속력을 증가시키는 것이 아닌, 마찰력을 감소시킨다는 점과 같이, 정지상태에서는 작동하지 않으며, 또한 일정횟수 사용되었다면 더이상 효과가 없다.<p>
5. 스톤은 이동하며 벽에 부딪히면 튕겨 나오고, 다른 스톤과 충돌할 경우, 충돌 방향에 따라 다르게 튕겨 나온다.<br>수직충돌의 경우에는 정지하게된다.<p>
6. 위의 조작방법을 이용하여 표적의 중심에 가까우면서, 자신의 팀의 스톤이 순서대로 최대한 전부 이어지게 하는 것이 게임의 승리 방법이다.

# 작동영상
<div align=center>
	
https://youtu.be/kMXLUSBVb8M<br>
  [![Video Label](http://img.youtube.com/vi/kMXLUSBVb8M/0.jpg)](https://youtu.be/kMXLUSBVb8M?t=0s)
</div>

## 충돌 및 점수 알고리즘 영상
<div align=center>
	
https://youtu.be/TDfz1sOkxdo<br>
  [![Video Label](http://img.youtube.com/vi/TDfz1sOkxdo/0.jpg)](https://youtu.be/TDfz1sOkxdo?t=0s)
</div>

# 역할분담
<div align=center>
<table>
    <tr align=center>
        <th width=10%></th>
        <th width=90%>프로젝트 기여<br><a href="https://github.com/kms0511/DS_TeamProject2023/tree/main/TeamProject/2023TeamProject.srcs/sources_1/new" target="_blank">CodeFolder</a></th>
    </tr>
    <tr>
        <th align=center><a href="https://github.com/kms0511"><code>kms0511</code></a><br>(팀장)</th>
        <td>
            <ul>
                <li><code>keypad.v</code> 키패드 조작</li>
                <li><code>graph_mod.v</code> 컬링 경기장 레이아웃 제작</li>
                <li><code>stone.v</code> 게이지 바 및 방향설정</li>
                <li><code>graph_mod.v</code> 게임 스테이트 머신</li>
				<ul>
					<li>스톤에 대한 스테이트 머신</li>
					<li>스톤을 전부 던진 후의 전체 게임 스테이트 머신 – 3세트 게임으로 제한</li>
				</ul>
                <li><code>stone.v</code> 스톤 방향 및 속도 알고리즘</li>
                <li><code>graph_mod.v</code> 색상 parameter 추가</li>
                <li>구동 영상 제작</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th align=center><a href="https://github.com/KimTeddy"><code>KimTeddy</code></a></th>
        <td>
            <ul>
                <li><code>scoring.v</code> <code>ranker.v</code> <code>distance_t.v</code> 컬링 점수 규칙에 따른 점수 계산 알고리즘</li>
                <li><code>top.v</code> 색상 12BIT 확장</li>
                <li><code>graph_mod.v</code> 색상 값 parameter화</li>
                <li><code>circle.v</code> 기하학을 적용한 원 그리기 모듈</li>
                <li><code>graph_mod.v</code> 전체 게임 스테이트 부분 수정</li>
                <li><code>graph_mod.v</code> 타겟(과녁) 디자인</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th align=center><a href="https://github.com/HidenSong"><code>HidenSong</code></a></th>
        <td>
            <ul>
                <li><code>stone.v</code> 스톤 및 브룸 디자인</li>
                <li><code>stone.v</code> 브룸 작동 및 가속, 감속 알고리즘</li>
                <li><code>graph_mod.v</code> 텍스트 출력</li>
                <li>팀원에게 컬링 점수 규칙 알려줌</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th>공통</th>
        <td>
            <ul>
                <li>최종보고서 작성</li>
            </ul>
        </td>
    </tr>
</table>
</div>
