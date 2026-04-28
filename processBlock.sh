# 1. 建立一个存放独立网格的文件夹
mkdir -p DECOMP_VTK

# 2. 定义字母数组（用字母命名是为了防止 ParaView 把它们当成动画的时间帧）
letters=(A B C D E F G H)

# 3. 循环进入每个 processor 文件夹，独立提取网格
for i in {0..7}
do
    echo "正在提取 processor$i 的物理网格..."
    # 针对单独的 processor 文件夹运行 foamToVTK
    foamToVTK -case processor$i -time 0 > /dev/null
    # 将提取出的内部网格复制出来，并重命名
    cp processor$i/VTK/processor${i}_0/internal.vtu DECOMP_VTK/block_${letters[$i]}.vtu
done

echo "提取大功告成！"
