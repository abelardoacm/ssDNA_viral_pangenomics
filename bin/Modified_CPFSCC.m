%This script is a slightly modified version of CPFSCC.m from https://github.com/YaulabTsinghua/The-central-moments-and-covariance-vector-of-cumulative-Fourier-Transform-power-and-phase-spectra/tree/399d912e958a5074db8476a9b24236692e3ddd09
%Original publication: Pei, S., Dong, R., He, R. L., & Yau, S. S.-T. (2019). Large-Scale Genome Comparison Based on Cumulative Fourier Power and Phase Spectra: Central Moment and Covariance Vector. Computational and Structural Biotechnology Journal, 17, 982–994. https://doi.org/10.1016/j.csbj.2019.07.003
T_r=fastaread('input.fasta');
n0=size(T_r,1);
N=cell(4,1);
A=zeros(1,n0);
tic
for d=1:n0
    n=size(T_r(d).Sequence,2);
    M=zeros(4,n);
    N{1}=strfind(upper(T_r(d).Sequence),'A');
    N{2}=strfind(upper(T_r(d).Sequence),'C');
    N{3}=strfind(upper(T_r(d).Sequence),'G');
    N{4}=strfind(upper(T_r(d).Sequence),'T'); 
    M(1,N{1})=1;
    M(2,N{2})=1;
    M(3,N{3})=1;
    M(4,N{4})=1;
    F=fft(M')';
    P=abs(F).^2;
    ang=angle(F);
    ang(ang<0)=ang(ang<0)+2*pi;
    t=sum(M,2);
    for k=2:n
    ang(:,k)=sum(ang(:,max(k-1,1):k),2);
    P(:,k)=sum(P(:,max(k-1,2):k),2);    
    end
    A(1:4,d)=sum(P(:,2:n),2)/(n-1);
    A(5:8,d)=sum(abs(P(:,2:n)-A(1:4,d)*ones(1,n-1)),2)/n;
    A(9:12,d)=sum((P(:,2:n)-A(1:4,d)*ones(1,n-1)).^2,2)./(n^2*(t*n-t.^2));
    A(13,d)=sum(abs(P(1,2:n)-A(1,d)).*abs(P(2,2:n)-A(2,d)))/(n^2*(t(1)+t(2))*(n-(t(1)+t(2))/2)/2);
    A(14,d)=sum(abs(P(1,2:n)-A(1,d)).*abs(P(3,2:n)-A(3,d)))/(n^2*(t(1)+t(3))*(n-(t(1)+t(3))/2)/2);
    A(15,d)=sum(abs(P(1,2:n)-A(1,d)).*abs(P(4,2:n)-A(4,d)))/(n^2*(t(1)+t(4))*(n-(t(1)+t(4))/2)/2);
    A(16,d)=sum(abs(P(2,2:n)-A(2,d)).*abs(P(3,2:n)-A(3,d)))/(n^2*(t(2)+t(3))*(n-(t(2)+t(3))/2)/2);
    A(17,d)=sum(abs(P(2,2:n)-A(2,d)).*abs(P(4,2:n)-A(4,d)))/(n^2*(t(2)+t(4))*(n-(t(2)+t(4))/2)/2);
    A(18,d)=sum(abs(P(3,2:n)-A(3,d)).*abs(P(4,2:n)-A(4,d)))/(n^2*(t(3)+t(4))*(n-(t(3)+t(4))/2)/2);
    A(19:22,d)=sum(ang(:,2:n),2)/(n-1); 
    A(23,d)=sum(abs(ang(1,2:n)-A(19,d)).*abs(ang(2,2:n)-A(20,d)))/(n^2*(t(1)+t(2))*(n-(t(1)+t(2))/2)/2);
    A(24,d)=sum(abs(ang(1,2:n)-A(19,d)).*abs(ang(3,2:n)-A(21,d)))/(n^2*(t(1)+t(3))*(n-(t(1)+t(3))/2)/2);
    A(25,d)=sum(abs(ang(1,2:n)-A(19,d)).*abs(ang(4,2:n)-A(22,d)))/(n^2*(t(1)+t(4))*(n-(t(1)+t(4))/2)/2);
    A(26,d)=sum(abs(ang(2,2:n)-A(20,d)).*abs(ang(3,2:n)-A(21,d)))/(n^2*(t(2)+t(3))*(n-(t(2)+t(3))/2)/2);
    A(27,d)=sum(abs(ang(2,2:n)-A(20,d)).*abs(ang(4,2:n)-A(22,d)))/(n^2*(t(2)+t(4))*(n-(t(2)+t(4))/2)/2);
    A(28,d)=sum(abs(ang(3,2:n)-A(21,d)).*abs(ang(4,2:n)-A(22,d)))/(n^2*(t(3)+t(4))*(n-(t(3)+t(4))/2)/2);
end
toc
%save('Fourier_accu_Geminiviridae.mat','A');
writematrix(A)
