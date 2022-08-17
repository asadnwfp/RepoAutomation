@echo off
echo "TransGen Starting"
 branchClone=$1
 push=$2
clear
mkdir test
cp transfer.js ./test/
cd test

if [ -z "$branchClone" ]  
then
    echo Enter the branch to transfer, and re-run the script.
    exit 1
fi
if [ -z "$push" ] 
then
    echo Provide wether to push the branch == true or false, and re-run the script.
    exit 1
fi
 
 targetRepo=com.caseware.de.e.generic
 targetRepo1=com.caseware.de.generic.1
 sourceRepo=com.caseware.de.e.schuellermann.taxcms
 sourceRepo1=com.caseware.de.e.schuellermann.taxcms.1

echo $sourceRepo
echo $targetRepo

# Downloading Source Repo
if [ ! -d $sourceRepo ]
then
    echo git clone --depth 1 --branch $branchClone git@bitbucket.org:DevAudicon/$sourceRepo.git
    git clone --depth 1 --branch $branchClone git@bitbucket.org:DevAudicon/$sourceRepo.git
fi

if [ -d $sourceRepo ]
then
    echo Changing IDS
    node transfer.js
    echo $sourceRepo/$sourceRepo1
    cd $sourceRepo/$sourceRepo1
    rm -v *.*
    cd ../..
else
    echo $sourceRepo does not exist.
    echo Check transGen for Git Command.
    exit 1
fi


# Downloading Target Repo
if [ ! -d $targetRepo ]
then
    echo git clone --depth 1 git@bitbucket.org:DevAudicon/$targetRepo.git
    git clone --depth 1 --branch $branchClone git@bitbucket.org:DevAudicon/$targetRepo.git
fi

if [ -d $targetRepo ]
then
    cd $targetRepo
    # git checkout -b $branchClone
    # git fetch
    # git checkout $branchClone
    cd ..
else 
    echo $targetRepo does not exist.
    echo Check transGen for Git Command.
    exit 1
fi

echo copying $sourceRepo1 to $targetRepo1
cp -rf ./$sourceRepo/$sourceRepo1/ ./$targetRepo/$targetRepo1/


# Push branch to TargeRepo
if [ "$push" = true ]
then
    echo $push
    echo pushing branch $branchClone to $targetRepo
    # cd $targetRepo 
    # git add .
    # echo Transfering $branchClone from $sourceRepo to $targetRepo .
    # git commit -m "Transfering $branchClone from $sourceRepo to $targetRepo ."
    # git push origin $branchClone --no-verify
    # cd ..
else 
    echo Repo push == $push
fi
echo Removing $sourceRepo
# rm -rf $replaceFolder
# rm -rfd $sourceRepo

echo Removing $targetRepo
# rm -rfd $targetRepo

echo TransGen Completed.
ls