%dialogue box
function [r1,r2,Epsilon,Cutoff,Ch1,Ch2 ]=DofC_Parameter
prompt = ({'Threshold Radius','DBSCAN Radius:',...
    'min Neighbor:','Number per Cluster Cutoff','Ch1','Ch2'});
dlg_title = 'Enter DBSCAN Parameter';
num_lines = 1;
def = {'50','20','3','10','1','2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Answer=cellfun(@str2num, answer);
r1=Answer(1);
r2=Answer(2);
Epsilon=Answer(3);
Cutoff=Answer(4);
Ch1=Answer(5);
Ch2=Answer(6);
