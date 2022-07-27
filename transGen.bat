@echo off
set branch-clone=%1
set push=%2
clear
if [%branch-clone%] EQU []  (
    echo Enter the branch to transfer, and re-run the script.
    goto end
)
if [%push%] == [] (
    echo Provide wether to push the branch == true or false, and re-run the script.
    goto end
)
set source-repo=com.caseware.de.e.schuellermann.taxcms
set target-repo=com.caseware.de.e.generic
set replace-folder=com.caseware.de.generic.1

echo %source-repo%
echo %target-repo%

REM Downloading Source Repo
echo git clone --depth 1 --branch %branch-clone% git@bitbucket.org:DevAudicon/%source-repo%.git
git clone --depth 1 --branch %branch-clone% git@bitbucket.org:DevAudicon/%source-repo%.git

if exist %source-repo% (
echo Changing IDS
    node transfer.js
    echo %source-repo%/%source-repo%.1
    cd %source-repo%/%source-repo%.1
    DEL /Q *
    cd ../..
) else (
    echo %source-repo% does not exist.
    echo Check transGen for Git Command.
    goto end
)  


REM Downloading Target Repo
echo git clone --depth 1 git@bitbucket.org:DevAudicon/%target-repo%.git
git clone --depth 1 git@bitbucket.org:DevAudicon/%target-repo%.git
if exist %target-repo% (
    cd %target-repo%
    git checkout -b %branch-clone%
    cd ..
) else (
    echo %target-repo% does not exist.
    echo Check transGen for Git Command.
    goto end
)

cp -rf ./%source-repo%/%source-repo%.1/ ./%replace-folder%/

echo copying %source-repo%.1 to %replace-folder%
cp -rf %replace-folder% ./%target-repo%/

REM Push branch to TargeRepo
if %push%== true (
    echo pushing branch %branch-clone% to %target-repo%
    cd %target-repo% 
    git add .
    echo Transfering %branch-clone% from %source-repo% to %target-repo% .
    git commit -m "Transfering %branch-clone% from %source-repo% to %target-repo% ."
    git push origin %branch-clone% --no-verify
    cd ..
) else (
    echo Repo push == %push%
)
echo Removing %source-repo%
rm -rf %replace-folder%
rm -rfd %source-repo%

echo Removing %target-repo%
rm -rfd %target-repo%

:end
echo TransGen Completed.
ls