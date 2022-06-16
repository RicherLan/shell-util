#!/bin/bash

:<<!
当前目录下的所有webp静图，转化为png格式，并resize宽高为 width x height
!

if [[ $1 ]]; then
    path=`pwd`/$1 #指定文件夹路径
    
    pngdirpath=$path/webp2png #要创建的文件夹路径
    `mkdir $pngdirpath`
    
    results=`ls $path | grep '.webp$'` #获得所有.webp结尾的文件名
    for result in $results
    do 
        file=$path/$result #获得每个webp文件的路径
        if test -f $file #判断是否是文件
        then 
           # 将指定webp静图，转化为png格式，并resize宽高为480x720
           pngPath=$pngdirpath/${result%.webp}.png
            `dwebp -resize $2 $3 $file -o $pngPath`
        fi
    done
else
    echo 没有指定文件夹
fi