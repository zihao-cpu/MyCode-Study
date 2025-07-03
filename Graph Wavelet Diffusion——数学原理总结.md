#  Graph Wavelet Diffusion: 数学原理总结

## 📌 任务目标
通过结构连接（Structural Connectivity, SC）预测大脑的功能连接（Functional Connectivity, FC），构建从结构到功能的映射：

$$
\hat{F} = f(S)
$$

---

## 🔶 1. 图扩散建模（Graph Diffusion）

图上每个节点 $i$ 满足扩散微分方程：

$$
\frac{dx_i(t)}{dt} = \sum_{j=1}^{N} S_{ij} x_j(t) - x_i(t)
$$

向量化为：

$$
\frac{d\mathbf{x}(t)}{dt} = -\mathcal{L} \mathbf{x}(t), \quad \mathcal{L} = I - S
$$

其中 $\mathcal{L}$ 是归一化拉普拉斯矩阵。

- $$ \mathbf{x}(t) \in \mathbb{R}^N $$：图上所有节点的状态向量（例如每个大脑区域的活动值）；
- $$ \mathcal{L} \in \mathbb{R}^{N \times N} $$：图拉普拉斯矩阵，代表图结构；
- 初始条件为：$$ \mathbf{x}(0) = \mathbf{x}_0 $$

---

## 🔶 2. 图扩散的解析解（Graph Heat Kernel）

微分方程解为：

$$
\mathbf{x}(t) = e^{-t \mathcal{L}} \mathbf{x}(0)
$$



根据谱分解性质：
$$
e^{-t \mathcal{L}} = U e^{-t \Lambda} U^T
$$
其中：
$$
e^{-t \Lambda} = \mathrm{diag}(e^{-t \lambda_1}, \ldots, e^{-t \lambda_N})
$$
因此最终解析解为：
$$
\mathbf{x}(t) = U e^{-t \Lambda} U^T \mathbf{x}(0)
$$
这表示：在谱空间中对信号进行指数缩放，然后再映射回节点空间。

如果初始条件是单位脉冲 $$ \mathbf{x}(0) = \delta_i $$，即第 $$ i $$ 个节点为 1，其余为 0，那么：
$$
\mathbf{x}_i(t) = e^{-t \mathcal{L}} \delta_i = U e^{-t \Lambda} U^T \delta_i
$$
这就是所谓的 **Graph Heat Kernel** 或 **Diffusion Kernel**，表示从第 $$ i $$ 个节点出发的信息扩散过程。



## 🔶 3. 多尺度扩散核（Node-wise Heat Kernel）

对第 $i$ 个节点脉冲输入 $\delta_i$，扩散为：

$$
x_i(t) = e^{-t \mathcal{L}} \delta_i
$$

通过谱分解：

$$
\mathcal{L} = U \Lambda U^T,\quad H(t) = \mathrm{Diag}(e^{-t \lambda_1}, \ldots, e^{-t \lambda_N})
$$

则：

$$
x_i(t) = U H(t) U^T \delta_i
$$

---

## 🔶 4. 全图扩散核拼接

将所有节点的扩散拼接为整图扩散特征：

$$
\mathbf{K} = \big\|_{i=1}^N U H(t_i) U^T \delta_i
$$

---

## 🔶 5. 特征融合与映射（Per-Vertex Linear Layer）

拼接结构连接与扩散核特征：

$$
X = [\mathbf{K} \| \mathbf{S}]
$$

应用线性映射（per-vertex linear layer）：

$$
\hat{F} = \text{pvLL}(X) = X W + b
$$

每一行预测 FC 中对应节点与其他所有节点的连接强度。

---

## 🔶 6. 优化目标

通过优化损失函数进行学习：

$$
\hat{F} = \rho \mathcal{L} \mathcal{L}(K \| S)
$$

 

##训练过程数学公式总结

###Forward Pass

1. **扩散核计算**：
   $$
   K_i = U e^{-s \Lambda} U^T \delta_i \tag{12}
   $$

2. **结构连接特征**（常量）：
   $$
   S_i = U U^T \delta_i \tag{13}
   $$

3. **拼接输入向量**：
   $$
   x_i = [K_i \| S_i] \tag{14}
   $$

4. **线性映射得到预测 FC 向量**：
   $$
   y_i = x_i W^T \tag{15}
   $$

5. **损失函数计算**（Frobenius norm）：
   $$
   \mathcal{L}_i = \sum_i \| y_i - \hat{y}_i \|_2^2 \tag{16}
   $$



###Backward Pass

6. **梯度计算**（链式法则）：
   $$
   \frac{\partial \mathcal{L}_i}{\partial s} = \frac{\partial \mathcal{L}_i}{\partial y_i} \cdot \frac{\partial y_i}{\partial x_i} \cdot \frac{\partial x_i}{\partial s} \tag{17}
   $$

7. **具体梯度表达式**：
   $$
   \frac{\partial \mathcal{L}_i}{\partial s} = -2 \sum (y_i - \hat{y}_i) W^T \Lambda x_i(s) \tag{18}
   $$

8. **梯度下降更新扩散尺度 \( s \)**：
   $$
   s^{(t+1)} = s^{(t)} - \eta \frac{\partial \mathcal{L}_i}{\partial s} \tag{19}
   $$





###总结表格

| 步骤       | 公式/内容                                    |
| -------- | ---------------------------------------- |
| **前向传播** | 计算扩散核、结构特征、拼接向量及预测 FC 向量                 |
| **损失函数** | $$ \mathcal{L}_i = \sum_i \| y_i - \hat{y}_i \|_2^2 $$ |
| **梯度计算** | 使用链式法则计算梯度：$$ \frac{\partial \mathcal{L}_i}{\partial s} = -2 \sum (y_i - \hat{y}_i) W^T \Lambda x_i(s) $$ |
| **梯度下降** | $$ s^{(t+1)} = s^{(t)} - \eta \frac{\partial \mathcal{L}_i}{\partial s} $$ |