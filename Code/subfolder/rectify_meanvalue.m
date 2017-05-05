function [ mean_value_correct] = rectify_meanvalue( mean_value,sub_mean_value,facial_landmarks,factor,k)
%if there is head rotiating, we need to judge which sub region should be
%used for successive calculation
%%% facial_landmarks 27 higher or not than 18/ 36 higher or not than 32/ 49
%%% higher or not than 55
%%% distance between facial_landmarks 28  40  43
%%% distance between facial_landmarks 32 34 36
%%% distance between facial_landmarks 49 52 55

mean_value_correct = mean_value;

d_28_40 = distance(facial_landmarks(28,:),facial_landmarks(40,:));
d_28_43 = distance(facial_landmarks(28,:),facial_landmarks(43,:));
d_34_32 = distance(facial_landmarks(32,:),facial_landmarks(34,:));
d_34_36 = distance(facial_landmarks(34,:),facial_landmarks(36,:));
d_52_49 = distance(facial_landmarks(49,:),facial_landmarks(52,:));
d_52_55 = distance(facial_landmarks(52,:),facial_landmarks(55,:));



if ((facial_landmarks(27,2)> factor*facial_landmarks(18,2)) & (facial_landmarks(36,2)> factor*facial_landmarks(32,2)) & (facial_landmarks(55,2)> factor*facial_landmarks(49,2))) | ((d_28_40>factor*d_28_43)&(d_34_32>factor*d_34_36)&(d_52_49>factor*d_52_55))
    %%this indicate that the subject turn right, use sub reigon 1
    disp(['subject turns right, use sub reigon 1']);
    mean_value_correct = sub_mean_value{1}(k,:);
elseif ((factor*facial_landmarks(27,2)< facial_landmarks(18,2))&(factor*facial_landmarks(36,2)< facial_landmarks(32,2))&(factor*facial_landmarks(55,2)<facial_landmarks(49,2))) | ((factor*d_28_40<d_28_43)&(factor*d_34_32<d_34_36)&(factor*d_52_49<d_52_55))
    disp(['subject turns left, use sub reigon 2']);
    mean_value_correct = sub_mean_value{2}(k,:);
end





end



