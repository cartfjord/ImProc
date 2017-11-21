function [ disp ] = Matching( imL,imR, dmax, WinSize )
    %size of the image
    [N, M, P]=size(imL);
    %convert the stereo pair to double
    imL=double(imL);
    imR=double(imR);
    % initialize the disparity map
    disp=zeros(N,M);
    %select the window for block matching
    win=(WinSize-1)/2;       
        for i=1+win:1:N-win
            for j=1+win:1:M-win
            % to initialize the dissimilarity for (i,j) position 
             error=inf;
             %process by increasing disparity 
               for d=0:1:dmax
                  %compute Cost from Sum absolute Diffrences(SAD) for each d value  
                  %initialize Cost from Sum absolute Diffrences (SAD)
                  SAD=0;
                    for k=-win:1:win
                      for l=-win:1:win
                        if ((j-d+l)>=1)             
                            % compute Cost from Sum absolute
                            % Diffrences(SAD)                           
                            for c = 1:3
                                SAD = SAD + abs(imL(i + k, j + l, c) - imR(i + k, j + l - d, c));
                            end                  
                        end
                      end
                    end
                  %to change disp to d value  having the least dissimilarity
                  if (SAD<error)
                     error = SAD;
                     disp(i,j) = d;                    
                  end 
                end
            end 
        end