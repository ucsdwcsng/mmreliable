% probing_overhead.m

% Note for Raghav: Put TS38.xx?
Nlist = [8, 16, 32, 64, 128, 256];
ssb = 0.5; %ms
csirs = 0.125; %ms
num_refinement_per_ssb = 3;

ssbbased = 2*log2(Nlist)*ssb;

beam2 = 3*csirs * num_refinement_per_ssb;
beam3 = 5*csirs * num_refinement_per_ssb;

probe_all = [ssbbased;repmat(beam3,1,length(Nlist)); repmat(beam2,1,length(Nlist))];

figure(1); clf;
bar(probe_all.');
xticklabels(categorical(Nlist))
ylabel('Probing overhead (ms)')
xlabel('Number of antennas')
leg=legend('Vanilla 5G NR', 'mmReliable 3-beam', 'mmReliable 2-beam');
grid on;
set(leg,'fontsize',14, 'location', 'northwest');
set(gca, 'fontsize',16);
% set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 3]) % Use 6,4 or 6,3 or 6,5 judiciously depending on space in the paper (2fig/column or 1fig/column)

wannasave=0;
if(wannasave)
saveas(gcf,[pwd,'/figures/probing_overhead.png']) 
% !pdfcrop figures/probing_overhead.pdf figures/probing_overhead.pdf 
end

