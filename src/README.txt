소스 코드를 보관하는 폴더 
소스 코드 빌드 시, 필요한 파일은 일반적으로 lib 폴더를 생성하여 보관한다.

src 하위 폴더는 아래 조건 하에서 자유롭게 관리한다. 
	-동일한 소스 코드를 여러 폴더로 중복 관리하지 않는다. 
	-소스 코드 버전별로 폴더를 생성하지 않는다. 
	-직접 작성한 소스 코드만이 유지되도록 한다. 
	
1. CSI 신호 송신, 수신 방법

	1-1. 시스템 구축
	 시스템 설치 과정 
	 버전: ubuntu 14.04.02 LTS

	 sudo apt-get update
	 sudo apt-get upgrade
	 sudo apt-get install git
	 sudo apt-get install gcc make linux-headers-$(uname -r) git-core
	 CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
	 git clone https://github.com/dhalperi/linux-80211n-csitool.git
	 cd linux-80211n-csitool
	 git checkout ${CSITOOL_KERNEL_TAG}
	 cd ..
	 git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git
	 sudo apt-get install libpcap-dev
	 git clone https://github.com/dhalperi/lorcon-old.git
	 cd linux-80211n-csitool
	 make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules
	 sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install
	 sudo depmod
	 cd ..
	 for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done
	 sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
	 sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode
	 make -C linux-80211n-csitool-supplementary/netlink
	 cd lorcon-old
	 ./configure
	 make
	 sudo make install
	 cd linux-80211n-csitool-supplementary/injection
	 Make

	1-2. Injection mode(패킷을 보내는 방법)
	 setup_injecttest2.sh가 있는 폴더에서 sudo bash setup_injecttest2.sh
	 sudo ./ Link\ to\ random_packets (총 패킷량) (한번에 보낼 패킷량) 1 (딜레이)

	1-3. Monitor mode(패킷을 받는 방법)
	 setup_monitor_csitest.sh가 있는 폴더에서 sudo bash setup_monitor_csitest.sh
	 Supplementary/netlink 에서 sudo ./log_to_file (파일명)

위의 과정을 거쳐 패킷을 송신, 수신이 완료되면 파일명(.dat를 붙여서 생성하는 것을 권고)을 가진 binary 파일이 생성됩니다.
이 *.dat파일을 MATLAB을 이용해 csv파일로 변환하는 과정을 거칩니다.

2. MATLAB Code 사용법
	
	2-1. read-bf-file.m
	 convertCSV.m, Pridiction.py 코드에서 사용되는 파일로, 직접적으로 컴파일하지 않고 사용만 되는 코드입니다.
	 .dat 확장자로 지정된 binary file의 내용을 읽는 코드입니다.
	
	2-2. convertCSV.m
	 1번 과정에서 얻은 CSI정보가 저장된 .dat 파일을 .csv 파일로 바꾸는 역할을 하는 파일입니다.
	 매트랩에서 구동하며 만들어낸 데이터 파일 개수만큼 경로를 지정해서 사용하면 됩니다.
	
	2-3. CSVreader.m
	 csv파일의 값들이 어떤 형태를 이루는지 그래프로 나타내는 코드입니다.
	 매트랩에서 구동하며 경로를 지정해서 사용하면 됩니다.
	 
	2-4. make_annotation.m
	 학습 과정에서 labeling을 위해 주석을 만드는 파일입니다.
	 매트랩에서 구동하며 csv파일들에 이름에 맞추어 경로를 지정해서 사용하면 됩니다.

이후 python 코드를 사용합니다. python3.6, anaconda3, Pycharm 환경에서 사용하였습니다.
주의할 점으로, Pridiction.py 코드에서 matlab.engine을 import 시킬 때에 Pycharm Setting에서 interpreter 목록에 없습니다. 이는 MathWorks 페이지(https://kr.mathworks.com/help/matlab/matlab-engine-for-python.html)를 참고하여 세팅하시길 바랍니다.

 3. Python Code 사용법
 	3-1. make_train_input.py
	 2-2에서 만든 csv파일들을 가져와서 tensorflow에서 학습하기 위한 input들로 합치는 코드입니다.
	 이 코드를 가장 먼저 실행해 input file들을 만들어야 합니다.
 	3-2. crossvali_input.py
	 이 코드는 3-3 trainer.py에 import되는 코드입니다.
	 trainer.py에서 학습을 진행할 때, make_train_input.py에서 받은 데이터를 crossvali 검증을 거치기 위한 데이터로 바꾸는 역할을 합니다.
 	3-3. trainer.py
	 tensorflow 기계학습을 진행하는 코드입니다.
	 training_iter와 k_fold를 조절해서 학습 횟수를 조정할 수 있습니다.
	 학습시에 시간 소모가 상당해서 GTX2070 GPU를 CUDA 기술을 사용해서 처리하였습니다. CPU를 사용할 때와 약 10배 가량의 속도 차이가 났습니다.
 	3.4. prediction.py
	 학습된 데이터를 기반으로 예측을 수행하는 코드입니다.
	 이 코드는 matlab.engine을 사용해 read_bf_file.m 파일의 기능을 사용하므로, 2번 matlab코드들과 같은 폴더 내에서 구동이 이루어져야 합니다.
	 

모든 준비가 끝났으면 prediction.py 파일을 실행시키고, CSI신호를 보내 실시간으로 예측하도록 하면 됩니다.
