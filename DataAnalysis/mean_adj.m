function A_adj = mean_adj(A,Xavg,Yavg)

    A_adj(:,1) = Xavg;
    A_adj(:,2) = interp1(A(:,1),A(:,2),Xavg);
    A_adj(:,2) = A_adj(:,2) - ...
        mean( excludeNaN(A_adj(:,2)) ) + mean (Yavg);

end