
it = 1; % start index for iterator

while(it <= 20) % setting number of CSI files
    
ARR_1 = zeros(1,30);
ARR_2 = zeros(1,30);
ARR_3 = zeros(1,30);
ARR_OUT = zeros(4900,90);

k = 1;
t = 1; 

% File address Setting
csvAddress = sprintf('%s%d%s', '/home/kimyonghwan/2019_Final/src/matlab_converter/190528_Dataset2/csv/190528_2_walking',it,'.dat');
strt = sprintf('%s%d%s', '/home/kimyonghwan/2019_Final/src/matlab_converter/190528_Dataset2/190528_2_walking',it,'.dat');

csi_trace = read_bf_file(strt);
disp(strt);
while(k <= 4900)

csi_entry = csi_trace{t};
csi = get_scaled_csi(csi_entry);

A = abs(csi);

i = 1;
while(i<=30)
   
    ARR_1(i) = A(:,1,i);
    ARR_2(i) = A(:,2,i);
    ARR_3(i) = A(:,3,i);
    i = i + 1;
    
end

ARR_FINAL = [ARR_1,ARR_2,ARR_3];
ARR_OUT(k,:) = ARR_FINAL;

k = k + 1;
t = t + 1;
end

% Convert .dat to .csv
string = sprintf('%s%s', csvAddress, '.csv');
csvwrite(string , ARR_OUT);
it = it + 1;

end


