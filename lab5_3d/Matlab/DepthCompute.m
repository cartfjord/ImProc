function [ DepthMap] = DepthCompute (disp, B, f )
    disp(disp == 0) = 1;
    DepthMap = f*B./disp;
end
