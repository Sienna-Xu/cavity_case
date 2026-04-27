#!/bin/bash

# 清理历史运行数据
rm -rf processor*
rm -rf postProcessing
rm -f log.*

# 1. 生成网格
echo "Generating mesh..."
blockMesh > log.blockMesh

# 2. 区域分解
echo "Decomposing domain..."
decomposePar -force > log.decomposePar

# 3. 提取核数
CORES=$(grep "numberOfSubdomains" system/decomposeParDict | tr -dc '0-9')

# 4. 运行并行计算
echo "Running icoFoam in parallel on $CORES cores..."
mpirun -np $CORES icoFoam -parallel > log.icoFoam

echo "Done! Check log.icoFoam for ExecutionTime and ClockTime."