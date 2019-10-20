function concatenated_sparse_coding(inputpath,fnamelist, voxelnum,tnum,iternum,segsize,lambda,dsize,outputdir)

    addpath /home/tllab/jlv/code/spams-matlab/build
    setenv('MKL_NUM_THREADS','1')
    setenv('MKL_SERIAL','YES')
    setenv('MKL_DYNAMIC','NO')  
    batchsize=5000;
    for iter=1:iternum
        fprintf('Iteration: %d\n',iter);
        for segid=1:ceil(voxelnum/segsize) 
            fprintf('  Dictionary learning Segment ID: %d\n',segid);
            Sall=[];
            for file=fnamelist
                ffile=cell2mat(file);
                        fname=[inputpath,ffile];
                        fid=fopen(fname);
                        FormatString=repmat('%f ',1,tnum);
                        rnum=rem(voxelnum,segsize)*(segid==ceil(voxelnum/segsize))+segsize*(segid<ceil(voxelnum/segsize));
                        s=cell2mat(textscan(fid,FormatString,rnum,'HeaderLines',(segid-1)*segsize));
                        fclose(fid);
                        s=s';

                        s=s-repmat(mean(s),[size(s,1) 1]);
                        s=s./repmat(std(s),[size(s,1) 1]);
                        s(s==inf)=0;
                        s(isnan(s))=0;
                        Sall=[Sall;s];


            end


            % dic learning
            size(Sall)

            param.K=dsize;  % learns a dictionary with ds elements
            param.lambda=lambda;
            param.numThreads=-1; % number of threads
            param.batchsize=batchsize;
            param.iter=ceil(size(Sall,2)/batchsize);
            param.posAlpha=true;


            fprintf('starting sparse coding.....\n');
            tic
            if (segid==1)*(iter==1)
            fprintf('first training.....\n');
            [D model]  = mexTrainDL(Sall,param);
            else
            param.D=D;
            [D model] = mexTrainDL(Sall,param,model);
            end
            

            t=toc;
            fprintf('time of computation for Dictionary Learning: %f\n',t);

        end
    end

    fname=[outputdir,'Concatenated_D.txt'];
    dlmwrite(fname,D,'\t');

    iter=1;
    fprintf('  Seperate dictionaries...');
    for file=fnamelist
       ffile=cell2mat(file);
       fname=[outputdir,ffile(1:(end-20)),'.D.txt'];
       d=D((tnum*(iter-1)+1):(tnum*(iter-1)+tnum),:);
       d=d-repmat(mean(d),[size(d,1) 1]);
       d=d./repmat(std(d),[size(d,1) 1]);
       dlmwrite(fname,d,'\t');
       c=corrcoef(d);
       fname=[outputdir,ffile(1:(end-20)),'.D.corrmat.txt'];  
       dlmwrite(fname,c,'\t');
       iter=iter+1;
    end

    %Common Lasso

    for segid=1:ceil(voxelnum/segsize) 
        fprintf('  Group Lasso Segment ID: %d\n',segid);
        Sall=[];
        for file=fnamelist
            ffile=cell2mat(file);
            
            fname=[inputpath,ffile];
            fid=fopen(fname);
            FormatString=repmat('%f ',1,tnum);
            rnum=rem(voxelnum,segsize)*(segid==ceil(voxelnum/segsize))+segsize*(segid<ceil(voxelnum/segsize));
            s=cell2mat(textscan(fid,FormatString,rnum,'HeaderLines',(segid-1)*segsize));
            s=s';

            s=s-repmat(mean(s),[size(s,1) 1]);
            s=s./repmat(std(s),[size(s,1) 1]);
            s(s==inf)=0;
            s(isnan(s))=0;
            Sall=[Sall;s];


        end


        param.mode=2;
        param.lambda=lambda;
        param.lambda2=0;
        param.numThreads=-1; % number of processors/cores to use; the default choice is -1
                        % and uses all the cores of the machine

        param.pos=true;

        fprintf('Evaluating cost function...\n');
        tic
        A=mexLasso(Sall,D,param);
        t=toc;
        fprintf('time of computation for sparsecoding: %f\n',t)
        A=full(A);
        A=A';
        A(isnan(A))=0;

        fname=[outputdir,'Common_A.txt'];
        if segid==1
           dlmwrite(fname,A,'delimiter','\t');
        else
           dlmwrite(fname,A,'-append','delimiter','\t');
        end
        
    end

    fname=[outputdir,'Common_A.txt'];
    A=load(fname);
    A=A';
    fname=[outputdir,'Common_A_T.txt'];
    dlmwrite(fname,A,'\t');

    % seperate lasso

    fprintf('  Seperate Lasso...');
    for file=fnamelist
        ffile=cell2mat(file);
       
        fname=[inputpath,ffile];

        S=load(fname);
        S=S';
        S=S-repmat(mean(S),[size(S,1) 1]);
        S=S./repmat(std(S),[size(S,1) 1]);
        S(S==inf)=0;
        S(isnan(S))=0;
        fname=[outputdir,ffile(1:(end-20)),'.D.txt'];
        D=load(fname);

        param.mode=2;
        param.lambda=lambda;
        param.lambda2=0;
        param.numThreads=-1; % number of processors/cores to use; the default choice is -1
                        % and uses all the cores of the machine

        param.pos=true;

        fprintf('Evaluating cost function...\n');
        tic
        A=mexLasso(S,D,param);
        t=toc;
        fprintf('time of computation for sparsecoding: %f\n',t)
        A=full(A);

        A(isnan(A))=0;

        fname=[outputdir,ffile(1:(end-20)),'.A.txt'];
        dlmwrite(fname,A,'\t');


    end







end
