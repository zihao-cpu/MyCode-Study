# 基于传播矩阵的随机游走嵌入方法（Step 1–3：构建图 → 随机游走 → 序列生成）

##  背景简介

给定每个被试的大脑传播矩阵：

$$
P \in \mathbb{R}^{n \times n}
$$

其中：

- $$ P_{i,j} $$表示从节点  i  到节点  j 的信息传播步数；
- 矩阵非对称，代表传播具有方向性；
- 步数越小表示传播越快。

目标是将这种结构信息转化为节点嵌入向量，通过：

- Step 1：构建传播图边权为 $$ \frac{1}{P_{i,j}} $$；
- Step 2：进行带概率的随机游走（Weighted Random Walk）；
- Step 3：采样序列供 Word2Vec 等模型训练。

---

##  Step 1：构建有向加权图

```python
import numpy as np
import networkx as nx

def build_directed_graph_from_matrix(P):
    """
    将传播矩阵 P 转换为有向图，其中边权为传播能力的倒数（1/P）。
    """
    G = nx.DiGraph()
    num_nodes = P.shape[0]
    for i in range(num_nodes):
        for j in range(num_nodes):
            if i != j and np.isfinite(P[i, j]) and P[i, j] > 0:
                weight = 1.0 / P[i, j]  # 越小步数 → 越高跳转概率
                G.add_edge(i, j, weight=weight)
    return G
```

## Step 2：定义带概率的随机游走函数



```python
import random

def weighted_random_walk(G, start_node, walk_length):
    """
    从 start_node 出发进行一条长度为 walk_length 的随机游走。
    跳转概率由边权重归一化而来。
    """
    walk = [start_node]
    while len(walk) < walk_length:
        cur = walk[-1]
        neighbors = list(G.successors(cur))
        if not neighbors:
            break
        weights = np.array([G[cur][nbr]['weight'] for nbr in neighbors], dtype=np.float64)
        probs = weights / weights.sum()
        next_node = np.random.choice(neighbors, p=probs)
        walk.append(next_node)
    return [str(n) for n in walk]

```

## Step 3：批量生成所有节点的随机游走序列

```python
def generate_weighted_random_walks(G, num_walks=10, walk_length=10):
    """
    对每个节点进行 num_walks 次随机游走，总共返回 num_walks × num_nodes 条路径。
    """
    walks = []
    nodes = list(G.nodes())
    for _ in range(num_walks):
        random.shuffle(nodes)
        for node in nodes:
            walk = weighted_random_walk(G, node, walk_length)
            walks.append(walk)
    return walks
```



## Step 4：基于 Word2Vec 训练节点嵌入

目标：将游走序列输入 Word2Vec，训练每个节点的向量表示。

### 本质思想（Skip-Gram 模型）

- 将随机游走路径视为“句子”；
- 节点作为“词”，用邻域预测目标节点；
- 本质是优化如下目标：

$$
\max \sum_{v \in V} \sum_{u \in \mathcal{N}_w(v)} \log \Pr(u \mid v)
$$

其中 $$ \mathcal{N}_w(v) $$ 为窗口大小 $$ w $$ 内的邻居。

```python
from gensim.models import Word2Vec

def learn_node_embeddings(walks, embedding_dim=64, window_size=5, workers=4, epochs=5):
    """
    使用 Word2Vec 训练节点嵌入。
    """
    model = Word2Vec(
        sentences=walks,
        vector_size=embedding_dim,
        window=window_size,
        min_count=0,
        sg=1,  # 使用 skip-gram
        workers=workers,
        epochs=epochs
    )
    return model

model = learn_node_embeddings(walks, embedding_dim=64)
embedding_matrix = np.array([model.wv[str(i)] for i in range(len(model.wv))])
```



























