function [data, data1, M,  m, n,b, mask]=load_data(data_number)
switch data_number
    case 1
        load 'dataHYDICE2'
        data=DataTest2;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            s1=sub_data-min(sub_data(:));
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
            q=data(:,:,i);
        end
        data1=reshape(data, M, b);
        load 'maskHYDICE';
        mask = reshape(mask, 1, M);
    case 2
        load 'dataMoffett'
        data=aa;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        load 'maskMoffett'
        mask = reshape(bb, 1, M);
    case 3
        load 'CRi2'
        data=X;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        load 'maskCRi'
        mask = reshape(maskCRi, 1, M);
    case 4
        load 'dataPavia4'
        data=PaviaCenter;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        load 'maskPavia4'
        mask = reshape(mask, 1, M);
    case 5
        load 'abu-airport-1' 
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);  
    case 6
        load 'dataIndian'
        data=A1;
        [m, n, b]=size(data);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        M=m*n;
        data1=reshape(data, M, b);  
        load 'maskIndian'
        mask = reshape(A, 1, M);
    case 7
        load 'abu-beach-1'    
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);
    case 8
        load 'abu-urban-4'    
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);  

    case  9
        load 'abu-airport-1'   
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);  
    case  10
        load 'Plane_data1';
        data_o=Plane;
        data=Plane;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(PlaneGT, 1, M);
    case  11
        load 'abu-airport-4'   
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M); 
    case  12
        load 'abu-airport-2'    
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M); 
    case  13
        load 'San_Diego'  
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);
    case 14
        load 'MUUFL'
        data_o=data;
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(mask, 1, M);
    case 15
        load abu-urban-2.mat
        [m, n, b]=size(data);
        M=m*n;
        for i=1:b
            sub_data=data(:,:,i);
            s1=sub_data-min(sub_data(:));
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(map, 1, M);

    case 16
        load Hohai_camouflage.mat
        data=Hohai_camouflage;
        [m, n, b]=size(data);
        M=m*n;
        for i=1:b
            sub_data=data(:,:,i);
            s1=sub_data-min(sub_data(:));
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(mask, 1, M);
        
  case 17
       load 'Hohai Coin'
        [m, n, b]=size(data);
        M=m*n;
        data2=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data1=reshape(data, M, b);
        mask = reshape(mask, 1, M);
end