
i = 1;

T = [];
V = [];
A1 = zeros(1,3,30);
csi_trace = csvread('/home/kimyonghwan/2019_Final/src/matlab_converter/190528_Dataset2/csv/190528_empty1.dat.csv',0,1,[0,1,10000,90]);
csi_trace2 = read_bf_file('/home/kimyonghwan/2019_Final/src/matlab_converter/190528_Dataset2/190528_empty1.dat');
while(i<1000)

A1(:,1,:) = csi_trace(i,1:30);
A1(:,2,:) = csi_trace(i,31:60);
A1(:,3,:) = csi_trace(i,61:90);

csi_entry2 =  csi_trace2{i};
csi2 = get_scaled_csi(csi_entry2);

B = A1;
C1 = abs(csi2);
C2 = abs(csi2);

C = cat(3,V,B);
T = cat(3,T,V,B);


subplot(2,1,1);
plot(squeeze(T).');

xlim([0, 1000]);
ylim([-10 ,30]);
legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
xlabel('Subcarrier index');
ylabel('SNR [dB]');


subplot(2,1,2);


plot(squeeze(C2).');

ylim([0 ,30]);
legend('Rx Antenna A', 'Rx AntennaB', 'Rx Anttenna C');
xlabel('Subcarrier index');
ylabel('SNR [dB]');

pause(0.01);

V = B;

hold on;
cla reset;

i = i + 1;

end


