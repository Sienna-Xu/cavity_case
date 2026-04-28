#!/bin/bash

echo "1. 清理历史数据..."
rm -rf processor* DECOMP_VTK log.*

echo "2. 生成网格 (约需几十秒，请稍候)..."
blockMesh > log.blockMesh

echo "3. 区域分解..."
decomposePar -force > log.decomposePar

echo "4. 提取各节点网格用于 ParaView 拓扑可视化..."
bash processBlock.sh > log.vtkExtract 

echo "5. 启动 MPI 并行计算..."
mpirun -np 8 icoFoam -parallel > log.icoFoam

echo "-----------------------------------"
echo "计算完成！性能评估结果如下："
grep "ExecutionTime" log.icoFoam | tail -n 1 | awk '{print "纯计算时间 (ExecutionTime): "$3" s\n总墙钟时间 (ClockTime): "$7" s\n通信与I/O开销评估: "$7-$3" s"}'
echo "-----------------------------------"