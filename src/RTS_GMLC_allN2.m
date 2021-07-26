clear all;


%should put code to open file here, code to close file can go at the end
mkdir july_results_test
k = 2
fname = sprintf('july_results_test/results_n_%d.csv',k);
fk = fopen(fname,'w');
if fk<=0, error('could not open file'); end
fprintf(fk,'hour, outages, ,BO size (MW), BO size (branches)\n');
for hour = 1:2
    
    RG_ps = eval(sprintf(strcat('july_',num2str(hour))))
    %fix gencost by setting field equal to that of original RTS_GMLC.m file
    RTS_GMLC_Original = RTS_GMLC
    RG_ps.gencost = RTS_GMLC_Original.gencost
    RG_ps = mp2ps(RG_ps)
    RG_ps = updateps(RG_ps)
    RG_ps = rebalance(RG_ps)

    m = size(RG_ps.branch,1);
    all_pairs = list_of_all(m);

    n_sims = size(all_pairs,1)


    %% Code from sim_all_k2345 that writes aggregate results to a file
    
    %old code for running single hour case for varying contingencies
    %mkdir july_results_test
    %k = 2
    %fname = sprintf('july_results_test/results_n_%d.csv',k);
    %fk = fopen(fname,'w');
    %if fk<=0, error('could not open file'); end
    %fprintf(fk,'outages, ,BO size (MW), BO size (branches)\n');

    n_sims = size(all_pairs,1)
    for o = 1:n_sims
        % simulate the sequence
        fprintf('Simulating n-%d outage %d of %d\n',k,o,n_sims);
        br_outages = all_pairs(o,:);
        [isbo(o),relay_outage{o},MW_lost(o)] = dcsimsep(RG_ps,br_outages,[]);
        total_lost = MW_lost(o).rebalance + MW_lost(o).control;
        fprintf('BO size = %.2f MW\n',total_lost);
        % save to the aggregate file
        fprintf(fk,'%d,',hour);
        fprintf(fk,'%d,',br_outages);
        fprintf(fk,'%g,%g\n',total_lost,size(relay_outage,1));

        %don't save individual files for now
        % save the sequence of events to a file
        %fname = sprintf('july_results_test/k%d_july_results_%05d.csv',k,o);
        %f = fopen(fname,'w');
        %fprintf(f,'type (exogenous=0, endogenous=1), time (sec), branch number # (%.4f MW lost)\n', total_lost);
        % print the exogenous outages
        %fprintf(f,'0,1.0,%d\n',br_outages);
        %if fk<=0, error('could not open file'); end

        % print the endogenous outages
        %for i = 1:size(relay_outage,1)
            %fprintf(f,'1,%.4f,%d\n',relay_outage(i,1),relay_outage(i,2));
        %end
        %fclose(f);
    end
    
end
fclose(fk)

