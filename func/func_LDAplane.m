function [w, f, b, fTrain, fTest] = func_LDAplane (data, label, test)

% Estimate the vector w normal to the linear discriminant hyperplane
% data is the matrix: each row is one data point, each column is one
% feature (dimension) of the data
%
% Note: currently, this program supports muliti classification, label has
% to be adjcent integer numbers (e.g. [0 1 2 ...k] for k classes)



% sorting matrix
w=[];
f=[];
b=[];
fTrain=[];
fTest=[];

data=data';
featNum=size(data,1);
dataNum=size(data,2);

for Nclass=min(label):max(label)

    covB=[];
    covW=[];
    mui=[];
    classLabel=(label==Nclass);

    for k=0:1
        % Load digits
        x=data(:,find(classLabel==k));
        eval(['x',num2str(k),'=x;']);

        %mean
        mui(:,end+1)=mean(x,2);
    end

    mu=mean(mui,2);

    %covariance
    covW=0;
    covB=0;
    for k=0:1
        eval(['x=x',num2str(k),';']);
        for n=1:size(x,2)
            covW=covW+(x(:,n)-mui(:,k+1))*(x(:,n)-mui(:,k+1))';
        end
    end
    covW=covW/dataNum;

    %normal vector to Hyperplane
    classW=-inv(covW)*diff(mui,1,2);

    %offset
    prior=0;
    %prior=log(size(x0,2)/size(x1,2));
    classB=1/2*sum(mui,2)'*inv(covW)*diff(mui,1,2)+prior;

    %projecting and offseting (this computes vote)
    fTestClass=-(test*classW+classB);
    fTrainClass=-(data'*classW+classB);
    
    %offseting
    classF=fTestClass;    
    
    
    %Output into sorting matrix
    w(:,end+1)=classW;
    f(:,end+1)=classF;
    b(:,end+1)=classB;
    fTrain(:,end+1)=fTrainClass;
    fTest(:,end+1)=fTestClass;



end

% Classify by taking votes
[dummy f]=max(f,[],2);
f=f+min(label)-1;


return