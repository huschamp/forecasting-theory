function a=draw(x,y,y1)
    subplot(2,1,1);
    a=plot(x,y,'r.');
    hold on
    plot(x,y1,'b-','LineWidth',2);
    hold off
    subplot(2,1,2);
    plot(x,y-y1,'b.');