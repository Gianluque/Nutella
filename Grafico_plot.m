k=100;
x=[1:k];
s=k;
ch1_plot=zeros(1,k);
ch2_plot=zeros(1,k);
    figure
    plot(x,ch1_plot,x,ch2_plot);
   
while s
    ch1_plot = circshift(ch1_plot,1);
    ch2_plot = circshift(ch2_plot,1);
    
    ch1_plot(1)=uint8(randi(k));
    ch2_plot(1)=uint8(randi(k));
    plot(x,ch1_plot,x,ch2_plot);
    grid on
    set(gca,'xtick',[0:10:k])
    set(gca,'ytick',[0:10:k])
    
    yticklabels({})%sin valores en los ejes
    xticklabels({})
    drawnow update
    %pause(0.09)
    
   s=s-1; 
end