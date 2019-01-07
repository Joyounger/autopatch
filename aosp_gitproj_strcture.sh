#!/bin/bash

cat << EOF
usage:
    bash autopatch.sh
EOF

androidroot=$1
patchroot=$2
branch=$3
YEAR=$4
MONTH=$5

tmpbranch=${branch}_googlepatch_${YEAR}_${MONTH}
cd $patchroot
for middlepath in `find . -path "./manifest" -prune -o -type f -print | xargs dirname | uniq | sort`  # in order to filter directory parameter's value for git apply.
do
    # git init
    cd $androidroot/${middlepath:2}
    git fetch origin $branch
    git checkout -b $tmpbranch -t origin/$branch
    git pull --rebase origin $branch

    # git apply
    for patch in `find $patchroot/${middlepath:2} -type f | sort`   # sort patch file in according to 0001,0002,...
    do
        git apply -v $patch
    done

done


echo "now you may start a new shell to apply failed patch manully if needed, and then select push commit auto or not"
read -p "do you want push commit auto? (y/n) " continue


if [ $continue == "y" ]; then
    #read -p "input your git confle filename in ~/.ssh, eg: config or config.linyang " gitcfgfile
    #cp -f ~/.ssh/$gitcfgfile ~/.ssh/config

    for middlepath in `find . -path "./manifest" -prune -o -type f -print | xargs dirname | uniq | sort`
    do
        # git push
        cd $androidroot/${middlepath:2}
        git add -A
        git commit -s
        git push origin HEAD:refs/for/$branch
    done
else
    echo "push commit manually"
fi
