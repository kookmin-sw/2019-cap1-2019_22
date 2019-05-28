
i = 1;

T = [];
V = [];


while(i<5000)

    
csi_trace = read_bf_file('/home/kimyonghwan/linux-80211n-csitool-supplementary/netlink/190528_cases_situp.dat');
csi_entry = csi_trace{i};
csi = get_scaled_csi(csi_entry);

csi_trace2 = read_bf_file('/home/kimyonghwan/linux-80211n-csitool-supplementary/netlink/190528_cases_down.dat');
csi_entry2 =  csi_trace2{i};
csi2 = get_scaled_csi(csi_entry2);

csi_trace3 = read_bf_file('/home/kimyonghwan/linux-80211n-csitool-supplementary/netlink/190528_cases_sit.dat');
csi_entry3 =  csi_trace3{i};
csi3 = get_scaled_csi(csi_entry3);

csi_trace4 = read_bf_file('/home/kimyonghwan/linux-80211n-csitool-supplementary/netlink/190528_cases_walk.dat');
 csi_entry4 =  csi_trace4{i};
csi4 = get_scaled_csi(csi_entry4);

csi_trace5 = read_bf_file('/home/kimyonghwan/linux-80211n-csitool-supplementary/netlink/190528_cases_walk.dat');
csi_entry5 =  csi_trace5{i};
csi5 = get_scaled_csi(csi_entry5);

A = abs(csi);
%A = angle(csi);
%B = db(A);
B = A;
C2 = abs(csi2);
C3 = abs(csi3);
C4 = abs(csi4);
C5 = abs(csi5);

C = cat(3,V,B);
T = cat(3,T,V,B);

 
 %subplot(4,1,1);
 %plot(squeeze(T).');
 
 %xlim([0, 4000]);
 %ylim([-10 ,30]);
 %legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
 %xlabel('Subcarrier index');
 %ylabel('SNR [dB]');
 
  
 subplot(3,1,1);
 
 
 plot(squeeze(C2).');
 
 ylim([0 ,30]);
 %legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
 xlabel('Subcarrier index');
 ylabel('SNR [dB]');
 

 
 subplot(3,1,2);
 
 
 plot(squeeze(C3).');
 
 ylim([0 ,30]);
 %legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
 xlabel('Subcarrier index');
ylabel('SNR [dB]');
 

  subplot(3,1,3);
 
 
 plot(squeeze(C4).');
 
 ylim([0 ,30]);
 %legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
 xlabel('Subcarrier index');
ylabel('SNR [dB]');
 

  %subplot(4,1,4);
 
 %plot(squeeze(C5).');
 
 %ylim([0 ,30]);
 %legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
 %xlabel('Subcarrier index');
%ylabel('SNR [dB]');
 
 pause(0.01);
 
 V = B;
 
 
 
 hold on;
 cla reset;
 
 i = i + 1;

end

