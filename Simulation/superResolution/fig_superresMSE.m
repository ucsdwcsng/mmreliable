% fig_superresMSE

load('figures/MSEfiles.mat')%,'MSEavg','MSEavg_pow');


figure(2);clf;
semilogy(tauListRel*1e9,MSEavg_pow(1,:).','linewidth',2)
grid on;hold on;
semilogy(tauListRel*1e9,MSEavg(1,:).','linewidth',2)


xlabel('Relative ToF (ns)'); ylabel('MSE of power estimate')
ll=legend('w/o super-resolution','w/ super-resolution');

set(ll,'fontsize',18);

set(gca,'fontsize',18)
set(ll,'location','best');
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 4])

SAVE_FIGS=0;
if(SAVE_FIGS)
    input('superres folder?')
    saveas(gcf,[pwd,'/figures/superresMSE.bmp'])
    saveas(gcf,[pwd,'/figures/superresMSE.png'])
    saveas(gcf,[pwd,'/figures/superresMSE.pdf'])
    !pdfcrop figures/superresMSE.pdf figures/superresMSE.pdf
end