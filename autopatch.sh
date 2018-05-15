#!/bin/bash

cat << EOF
usage:
    bash autopatch.sh param1 param2 param3
    param1--android source rootdir,no slash in the end.
    param2--patch file rootdir,no slash in the end. eg:~/src/android-7.1.1_r4/platform
    param3--branchname 
EOF

androidroot=$1
patchroot=$2
branch=$3
YEAR=$4
MONTH=$5

function gitinit
{
    cd $androidroot/$1

    tmpbranch=${branch}_googlepatch_$YEAR_$MONTH
    #git branch -D $tmpbranch
    git fetch origin $branch
    git checkout -b $tmpbranch -t origin/$branch
    git pull --rebase origin $branch
}

function gitapply
{
    cd $androidroot
    
    for patch in `find $2 -type f | sort`   # sort patch file in according to 0001,0002,...
    do
        git apply -v --directory=$1 $patch
    done
}

function gitpush
{
    cd $androidroot/$1

    git add -A
    git commit -s
    git push origin HEAD:refs/for/$branch
}

for lv1project in `ls $patchroot --ignore=manifest`
do
    gitinit $lv1project
done


cd $patchroot
for middlepath in `find . -path "./manifest" -prune -o -type f -print | xargs dirname | uniq | sort`  # in order to filter directory parameter's value for git apply.
do
    gitapply ${middlepath:2} $patchroot/${middlepath:2}
done


echo "now you may start a new shell to apply failed patch manully if needed, and then select push commit auto or not"
read -p "do you want push commit auto? (y/n) " continue


if [ $continue == "y" ]; then
    #read -p "input your git confle filename in ~/.ssh, eg: config or config.linyang " gitcfgfile
    #cp -f ~/.ssh/$gitcfgfile ~/.ssh/config

    for lv1project in `ls $patchroot --ignore=manifest`
    do
        gitpush $lv1project
    done
else
    echo "push commit manually"
fi
