# 线性回归模型与 BIC 推导

## 1. 线性回归模型

考虑线性回归模型：

$$
y = X\beta + \varepsilon, \quad \varepsilon \sim \mathcal{N}(0, \sigma^2 I_n)
$$

其中：
- $$y \in \mathbb{R}^n$$：观测值  
- $$X \in \mathbb{R}^{n \times k}$$：自变量矩阵  
- $$\beta$$：回归系数  
- $$\varepsilon$$：噪声，独立同分布的高斯分布  

---

## 2. 似然函数

在高斯噪声假设下，单个样本的概率密度为：

$$
p(y_i \mid x_i, \beta, \sigma^2) 
= \frac{1}{\sqrt{2\pi\sigma^2}} \exp\!\left(-\frac{(y_i - x_i^T\beta)^2}{2\sigma^2}\right)
$$

由于 $$y_1, \dots, y_n$$ 独立同分布 (i.i.d.)，联合似然函数为：

$$
L(\beta, \sigma^2) 
= \prod_{i=1}^n p(y_i \mid x_i, \beta, \sigma^2)
= (2\pi\sigma^2)^{-n/2} \exp\!\left(-\frac{1}{2\sigma^2}(y - X\beta)^T(y - X\beta)\right)
$$

这里：

$$
(y - X\beta)^T(y - X\beta) = \text{RSS}
$$

即残差平方和。

---

## 3. 对数似然函数

取对数：

$$
\ln L(\beta, \sigma^2) 
= -\frac{n}{2}\ln(2\pi) - \frac{n}{2}\ln(\sigma^2) - \frac{1}{2\sigma^2}(y - X\beta)^T(y - X\beta)
$$

---

## 4. 最大似然估计 (MLE)

- 对 $$\beta$$ 最大化，得到普通最小二乘解 (OLS)：

$$
\hat{\beta} = (X^TX)^{-1}X^Ty
$$

- 对 $$\sigma^2$$ 最大化，得到：

$$
\hat{\sigma}^2 = \frac{\text{RSS}}{n}
$$

---

## 5. 代入对数似然

将 $$\hat{\sigma}^2$$ 代入：

$$
\ln L(\hat{\beta}, \hat{\sigma}^2) 
= -\frac{n}{2}\ln(2\pi) - \frac{n}{2}\ln\!\left(\frac{\text{RSS}}{n}\right) - \frac{n}{2}
$$

---

## 6. BIC 推导

BIC 定义为：

$$
\text{BIC} = -2\ln L(\hat{\beta}, \hat{\sigma}^2) + k\ln(n)
$$

代入对数似然得到：

$$
\text{BIC} = n \ln\!\left(\frac{\text{RSS}}{n}\right) + k\ln(n) + C
$$

其中常数 $$C$$ 与模型比较无关，可以忽略。

---

## 7. 常用形式

$$
\text{BIC} = n \ln\!\left(\frac{\text{RSS}}{n}\right) + k \ln(n)
$$

---

✅ **总结**  
- BIC 的第一项来源于对数似然函数与残差平方和 RSS 的关系；  
- 第二项 $$k \ln(n)$$ 是复杂度惩罚项；  
- 在模型选择时，选择 **BIC 最小的模型**。