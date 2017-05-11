
test_method1 = saveMat(:,:,1);
test_method2 = saveMat(:,:,2);
test_method3 = saveMat(:,:,3);

index = 1:15;
figure('NumberTitle', 'off', 'Name', 'VDR');
plot(index, test_method1(1,:),'r-v',index, test_method2(1,:), 'b-*',index, test_method3(1,:),'g-o');
figure('NumberTitle', 'off', 'Name', 'VDER');
plot(index, test_method1(2,:),'r-v',index, test_method2(2,:), 'b-*',index, test_method3(2,:),'g-o');
figure('NumberTitle', 'off', 'Name', 'CORRECT');
plot(index, test_method1(3,:),'r-v',index, test_method2(3,:), 'b-*',index, test_method3(3,:),'g-o');
