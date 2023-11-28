function ETestA=Subset_Accuracy(Test_label,Test_Final)

   Exact_Test_Accuracy=0;
   [no_of_test,~]=size(Test_label);
   for i=1:no_of_test
        if isequal(Test_label(i,:),Test_Final(i,:))
              Exact_Test_Accuracy = Exact_Test_Accuracy+1;
        end
    end
    ETestA=(Exact_Test_Accuracy/no_of_test);
end