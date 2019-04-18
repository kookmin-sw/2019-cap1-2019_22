<div align="center">
<p><img src="/doc/Images/MDW.PNG"></p>
</div>
<br/>

https://github.com/kookmin-sw/2019-cap1-2019_22

### 1. 프로젝트 소개
 저희 M.Fi 팀은 WiFi CSI를 이용하여 사람의 동작 감지 서비스인 MDW(Motion Detecting WiFi)를 만드는 프로젝트 입니다.<br/>
현재의 CCTV와 같은 광학적 감지장비는 시각적 제약이 있는 상황에서는 성능을 모두 발휘하기 어려울 뿐만 아니라 사생활<br/>
침해라는 부작용을 가지고 있습니다. 반면 CSI를 이용한 감지 시스템은 WiFi 채널의 변화를 감지하여 사람의 상태를 파악하는<br/>
기술이므로 시각적 제약이 없을 뿐 아니라 사생활 침해가 적다는 장점을 가지고 있습니다.<br/>


### 2. 소개 영상

<p align="center">
<a href="https://www.youtube.com/embed/gBwz4oIDKAg"><img height="566" width="574" src="/doc/Images/MDW.PNG"></a>
</p>

### 3. 팀 소개

팀명: M.Fi(Motion Fi)
<br/>
<br/>
팀장: 안재관<br/>
E-Mail: ggstork@gmail.com<br/>

팀원: 김상원<br/> 
E-Mail: gini0723@gmail.com<br/>

팀원: 김용환<br/>
E-Mail: brightface@hanmail.net<br/>

팀원: 이종호<br/>
E-Mail: asqqwww1@gmail.com<br/>

### 4. 사용법
<div align="center">
<p><img src="/doc/Images/RockPro64.jpg"></p>
</div>
<br/>
 RockPro64를 이용하여 모듈을 소형합니다.</br>

<div align="center">
<p><img src="/doc/Images/aws.jpg"></p>
</div>
<br/>
AP 에서 사람의 움직임이 감지되면 AWS(Amazoon Web Service) 로 알람을 전송합니다.</br>
AWS 에서 알람을 수신 받으면 이 알람을 사용자의 Application 로 전송합니다.</br>
이때 AWS는 Node.js 를 이용해서 개발합니다.</br>

<div align="center">
<p><img src="/doc/Images/flutter.jpg"></p>
</div>
<br/>
이때 알람을 수신받는 Application은 Flutter 를 이용해서 개발합니다.</br>
언어는 Dart를 사용할 예정입니다.</br>

 
 


### 5. 기타

### Abstract
Team 'M.Fi' is using 'WiFi CSI' to make 'Motion Dectecting WiFi' called 'MDW'.<br/>
Nowdays the device like 'CCTV' that based on optical, is can not working well when it have some visual restriction.
And it also has side effect, like Privacy infringement.
So we condsider different way of monitoring system. That was 'MDW'.
We use two access point to recognize 'CSI'.
The 'CSI' mean 'Channel State Information'. That include Wifi signal information such as amplitude, phase, and SNRdb.
Using this way, system can detecting humen's movement.
And because of it was based on radio signal , it have no side effect. Also free from the optical limit.<br/>

 User can know what happend in his own place at the outside of there. SO the user can use this system to prevent some danger stituation. And in emergency situation user can react fast and clearly.

