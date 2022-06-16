#!/bin/bash

:<<!
sh hello.sh ./haha 480 720
./haha: webp所在的文件夹
!


dirpath="" # 文件夹绝对路径
handledstaticwebpDirpath="" # 经过宽高处理过的图片文件夹

if [[ $1 ]]; then
    path=`pwd`/$1 
    results=`ls $path | grep '.webp$'` #获得所有.webp结尾的文件名
    for result in $results
    do 
        file=$path/$result #获得每个webp文件的路径
        if test -f $file #判断是否是文件
        then 
            dirpath=$path/${result%.webp} #要创建的文件夹路径
            staticwebppath=$dirpath/staticwebp
            handledstaticwebpDirpath=$dirpath/handledstaticwebp
            
            # pngpath=$dirpath/png
            # jpgpath=$dirpath/jpg
            `mkdir $dirpath`
            `mkdir $staticwebppath`
            `mkdir $handledstaticwebpDirpath`
            
            # `mkdir $pngpath`
            # `mkdir $jpgpath`
            i=0
            while(($i>=0))
            do
                i=$(($i+1))

                webpframe=$staticwebppath/$i.webp
                `webpmux -get frame $i $file -o $webpframe`


                if (test -f $webpframe) #判断是否已经获取到所有帧了
                then #用webp生成png图片
                    handledstaticwebppath=$handledstaticwebpDirpath/$i.webp
                    `dwebp -resize $2 $3 $webpframe -o $handledstaticwebppath`
                    # pngframe=$pngpath/${result%.webp}$i.png
                    # jpgframe=$jpgpath/${result%.webp}$i.jpg
                    # `dwebp $webpframe -o $pngframe`
                    # `dwebp $webpframe -o $jpgframe`
                else 
                    if (($i == 1)) #如果第一帧有生成，则说明是动态webp，如果第一帧没有生成则说明不是动态webp
                    then #不是动态webp文件时，删除创建的文件夹
                        `rm -r $dirpath`
                    fi
                    break
                fi
            done
            break
        fi
    done
else
    echo 没有指定文件夹
fi


echo $handledstaticwebpDirpath
 results=`ls -lhtrc $handledstaticwebpDirpath | grep '.webp$'` #获得所有.webp结尾的文件名
    i=0
    inputimgpaths=""
    for result in $results
    do 
        file=$handledstaticwebpDirpath/$result #获得每个webp文件的路径
        if test -f $file #判断是否是文件
        then 
            i=$(($i+1))
            if (($i == 1))
            then
                inputimgpaths="$file"
            else 
                inputimgpaths="$inputimgpaths $file"
            fi
            # 指定要用前n张图片制作webp
            # if ($i >= $2)
            #  break
        fi
    done
    # 将多个图片，转化为webp动图
    # echo $inputimgpaths
    `img2webp -loop 0 -lossy $inputimgpaths -o $dirpath/output_anim.webp`