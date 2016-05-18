%dialogue box
function [r1,r2,Epsilon,Cutoff ]=DBSCAN_Parameter
prompt = ({'Threshold Radius','DBSCAN Radius:',...
    'min Neighbor:','Number per Cluster Cutoff'});
dlg_title = 'Enter DBSCAN Parameter';
num_lines = 1;
def = {'50','20','3','10'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
Answer=cellfun(@str2num, answer);
r1=Answer(1);
r2=Answer(2);
Epsilon=Answer(3);
Cutoff=Answer(4);
