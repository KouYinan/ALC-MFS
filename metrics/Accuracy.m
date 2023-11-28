function Acc=Accuracy(Test_label,Test_Final)

   Accuracy=0;
   [no_of_test,~]=size(Test_label);
   
   for i=1:no_of_test
       intr=Test_label(i,:).*Test_Final(i,:);
       union=Test_label(i,:)+Test_Final(i,:);
       union(union==2)=1;
       Accuracy=Accuracy+(sum(intr)/sum(union));
   end
    Acc=(Accuracy/no_of_test);
end