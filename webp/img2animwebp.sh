#!/bin/bash

:<<!
当前目录下的所有png，转化为webp格式，并resize宽高为 width x height
!

if [[ $1 ]]; then
    path=`pwd`/$1 #指定png的文件夹路径
    
    animwebpdirpath=$path/animwebp #要创建的文件夹路径
    `mkdir $animwebpdirpath`
    
    results=`ls $path | grep '.png$'` #获得所有.png结尾的文件名
    i=0
    inputimgpaths=""
    for result in $results
    do 
        file=$path/$result #获得每个png文件的路径
        if test -f $file #判断是否是文件
        then 
            i=$(($i+1))
            if ($i==1)
            then
                inputimgpaths="$file"
            else 
                inputimgpaths="$inputimgpaths $file"
            fi
            # if ($i >= $2)
            #  break
        fi
    done
    # 将多个png图片，转化为webp动图
    echo $inputimgpaths
    `img2webp -loop 0 -lossy $inputimgpaths -o $animwebpdirpath/output_anim.webp`
else
    echo 没有指定文件夹
fi
