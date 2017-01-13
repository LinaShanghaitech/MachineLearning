function y = soft(b,tau)
%This is the soft-thresholding operator
    dims=length(b);
    y=zeros(dims,1);
    for i=1:dims
        if b(i)>tau
            y(i)=b(i)-tau;
        else if b(i)<-tau
                y(i)=b(i)+tau;
            else
                y(i)=0;
            end
        end
                
    end
  
    
    
    