clear all;
RG_ps = mp2ps(RTS_GMLC)
RG_ps = updateps(RG_ps)
RG_ps = rebalance(RG_ps)

m = size(RG_ps.branch,1);
all_pairs = list_of_all(m);

n_sims = size(all_pairs,1)

for o = 1:10
    fprintf('Simulating outage %d of %d\n',o,n_sims);
    br_outage = all_pairs(o,:);
    [isbo(o),relay_outage{o},MW_lost(o)] = dcsimsep(RG_ps,br_outage,[]); %#ok<SAGROW>
    total_lost = MW_lost(o).rebalance + MW_lost(o).control;
    fprintf('BO size = %.2f MW\n',total_lost');
end


save n_minus_2_results;


%% save the results in a file
cd july_results;
load n_minus_2_results;

for o = 1:n_sims
    % type, time, component number
    fname = sprintf('july_results_%03d.csv',o)
    f = fopen(fname,'w');
    fprintf(f,'type (exogenous=0, endogenous=1), time (sec), branch number # %.4f MW lost\n', MW_lost(o));
    % print the exogenous outages
    fprintf(f,'0,1.0,%d\n',all_pairs(o,1));
    fprintf(f,'0,1.0,%d\n',all_pairs(o,2));
    % print the endogenous outages
    for i = 1:size(relay_outage{o},1)
        fprintf(f,'1,%.4f,%d\n',relay_outage{o}(i,1),relay_outage{o}(i,2));
    end
    fclose(f);
end
cd ..


