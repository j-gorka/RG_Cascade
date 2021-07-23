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



