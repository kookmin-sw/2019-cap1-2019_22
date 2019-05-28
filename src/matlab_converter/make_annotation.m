
it = 1;
annotation = sprintf('%s', 'walking');

while(it <= 20) 

    %ARR_OUT = strings([4900,1]);
    
    strt = sprintf('%s%s%d%s', '/home/kimyonghwan/2019_Final/src/matlab_converter/190528_Dataset2/csv/annotation_', annotation, it,'.dat.csv');
    fid = fopen(strt,'wt');
    k = 1;
    while(k < 4901)
        fprintf(fid,'%s\n',annotation);
        
        k = k + 1;
    end
    
    it = it + 1;
    fclose(fid);
end


