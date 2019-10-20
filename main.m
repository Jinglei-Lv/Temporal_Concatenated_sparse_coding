clear all

addpath /home/tllab/jlv/code/spams-matlab/build

setenv('MKL_NUM_THREADS','1')
setenv('MKL_SERIAL','YES')
setenv('MKL_DYNAMIC','NO')

%%% Prepare the fMRI signal file list used for sparse coding%%
fnamelist={};
inputpath='/home/Shared/Miller_Liu/Lutein_OA/pre-process/Whole_b_signals/'
ids=load('../ids.txt');
for tid=[1 2]
    for i=ids'
        fname=[num2str(i),'_time',num2str(tid),'_whole_b_signals.txt'];
        fnamelist=[fnamelist,fname];
    end
end

voxelnum=230381  % voxel number in the fMRI 
iternum=10       % The learning iteration
segsize=20000    % files will be segmented before concatenation which will reduce memory consuming. Here segment size is defined
tnum=108         % Time points number
lambda=1.5       % Sparsity parameter
dsize=50         % dictionary size
outputdir='./output/'  % output directiory
tic
concatenated_sparse_coding(inputpath,fnamelist, voxelnum,tnum,iternum,segsize,lambda,dsize,outputdir);
t=toc;
fprintf('time of computation : %f\n',t);
