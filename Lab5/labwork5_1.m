clc
clear all
close all
warning('off')
a1=0.3;
a2=-0.5;
k=50;
ro(1)=1;
ro(2)=a1/(1-a2);
ro(3)=a1^2/(1-a2)+a2;
for i=4:k
    ro(i)=a1*ro(i-1)+a2*ro(i-2);
end    
figure
stem(ro);