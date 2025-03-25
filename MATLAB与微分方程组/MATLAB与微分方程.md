# 全导数

$$
\frac{\partial f(x,y,z)}{\partial x} ,\frac{\partial f(x,y,z)}{\partial y} ,\frac{\partial f(x,y,z)}{\partial z}
$$

```matlab
syms x y z
f = y*z*sin(x);dxf = diff(f,x)
dyf = diff(f,y)
dzf = diff(f,z)

D = jacobian( [f, f,f] , [x,y, z] )
dxf = D(1,1)
dyf = D(2,2)
dzf = D(3,3)
```

# dsolve 函数

dsolve用来求解解析解
$$
\frac{df}{dt}=f+2t;
\frac{d^2g}{dt^2}=g+sint;
\frac{d^4h}{dt^4}=t+sint;
\begin{cases}
\frac{d^2f_1}{dt^2}=t^2 & \\
 \frac{df_2}{dt}=t & 
\end{cases}
$$

```matlab
f=dsolve（'Df=f+2*t'）%求关于f的微分方程
g=dsolve（'D2g=g+sin（t）'，'g（1）=2'，'Dg（0）=1'）%求关于g的二阶微分方程
h=dsolve（'D4h=t+sin(t）·，*h(0）=1′，‘Dh(0)=2'，'D2h（0)=3，'D3h(0)=4'）%求关于h的
4阶微分方程
[f1,f2]=dsolve（D2f1=t2，Df2=t,f1（0）=1'，Df1（0）=1,f2（0）=2'）%求关于f
和f2的微分方程组

```

# ode系列函数举例

$$
y\prime\prime+4y=3sin9t
$$

ode45函数不能直接求解这个方程，用户需要把这个方程转化为一阶方程组形式从而成为矩阵形式便于计算。
$$
\begin{cases}
y_1\prime=y_2 \\
y_2\prime=3sin9t-4y_1
\end{cases}
$$
这里补充高阶微分方程的转化方法，对于n阶的微分方程用户可以考虑类似地来转化。
$$
y_1(t)，y_2(t)，y_3(t)，\ldots y_n(t) \longrightarrow y_1\prime=y_2 ，y_2\prime=y_3，y_3\prime=y_4，{y_{n-1}}\prime=y_n
$$

```matlab
function dy=tfys(t,y)
dy(1,1)=y(2)
dy(2,1)=3*sin(9*t)-4*y(1);
end

tspan=[0,5];
y0=[1,0];
[t,y]=ode45(@tfys,tspan,y0);
figure;
plot(t,y(:,1),k-）;
hold on;
set（gca,'Fontsize',12);
xlabel（'\itt',Fontsize",16);
```

$$
\begin{cases}
x_1\prime=ax_1-bx_1x_2 \\
x_2\prime=cx_1x_2-dx_2
\end{cases}\\
a=2,b=0.01 ,c=0.001,d=0.7 ,x_1(0)=300,x_2(0)=100
$$

```matlab
function dx=preyer（t,x,flag,a,b,c,d);
dx(1,1)=a*x(1)-b*x(1)*x(2);
dx(2,1)=c*x(1)*x(2)-d*x(2);
end

tspan=[0,14];
x0=[300,100];
a=2;b=0.01;c=0.001;d=0.7;
options=odeset('RelTol',1e-6);
[t,x]=ode45('preyer',tspan,x0,options,a,b,c,d);
```

$$
\begin{cases}
x_1\prime=x_2-f(t)\\
x_2\prime=x_1g(t)-x_2
\end{cases},f(t)=\begin{cases}
sin(t),&t<4\pi\\
0,&t\geq4\pi
\end{cases},g(t)=\begin{cases}
0,&t<7\pi/2\\
2cost,&t\geq7\pi/2
\end{cases}
$$

```matlab
function dx=odeppiece(t,x);
ft=0;
if t<4*pi
	ft=2*sin(t)
end
if t>3.5*pi
	gt=cos(t);
end
dx(1,1)=x(2)-ft;
dx(2,1)=x(1)*gt-x(2);

tspan=[0,20];
x0=[0,1];
[t,x]=ode23tb('odeppiece';tspan,x0);
```

# 求解隐式公式微分方程

$$
f(t,x,x\prime)=0
$$

$$
\begin{cases}
x_2\prime[x_2cos(4t)-x^3_1]-tx_1\prime x_2\prime=0\\
tsinx_2/8-2x_2x_2\prime=0
\end{cases}
$$

```
function D=impfun(t,x,xp)
D=[xp(2)*[cos(t*4)*x(2)-x(1)^3]-xp(2)*xp(1)*t;...
t*sin(x(2))/8-xp(2)*x(2)*2];
end
```

```
tspan=[0,30]
x0=[1,1]';
xp0=[-0.2,0.4]';
[t,x]=ode15i('impfun',tspan.xo.xp0);
```

# 边值问题

# 时滞微分方程


$$
\begin{cases}
\frac{d}{dt} x_1(t) = 0.5 \cdot x_3(t - \tau_3) + 0.5 \cdot x_2(t) \cdot \cos(6) \\
\frac{d}{dt} x_2(t) = 0.3 \cdot x_1(t - \tau_1) + 0.7 \cdot x_3(t) \cdot \sin(t) \\
\frac{d}{dt} x_3(t) = x_2(t) + \cos(2t)
\end{cases}
$$


```matlab
function dx=ddeffun2(t,x,lags)
x1d=lags(:,1);
x3d=lags(:,2);
dx=[0.5*x3d(1)+0.5*x(2)*cos(6);...
    0.3*x1d(1)+0.7*x(3)*sin(t);...
    x(2)+cos(2*t)];
end
lags=[1,3];
history=[0,0,1];
tspan=[0,8];
sol2=dde23('ddeffun2',lags,history,tspan);


```

# 复杂高阶微分方程的变换与求解

## 含有最高阶导数二次方的微分方程

$$
[y^{n}(t)]^2=f(t,y(t),y^\text'(t), \ldots,y^{n-1}(t))
$$

$$
x_1(t)=y(t),x_2(t)=y^\text'(t),\ldots,x_n(t)=y^{n-1}(t)
$$

$$
例子：(y^\text{''}(t))^2=4(ty^\text'(t)-y(t))+2y^\text'(t)+1
$$

$$
x_1(t)=y(t),x_2(t)=y^\text'(t)\\x^\text'(t)=\left[ \begin{array}{c} x_2(t)\\-\sqrt{4(tx_2(t)-x_1(t))+2x_2(t)+1}  \end{array} \right]
$$

```matlab
ff=odeset;ff.AbsTol=1e-8;ff.RelTol=1e-8;
f=@(t,x)[x(2);sqrt(4*(t*x(2)-x(1))+2*x(2)+1)];
[t1,x1]=ode45(f,[0,1],[0;0.1,ff]);x1=real(x1(:,1));
[t2,x2]=ode45(f,[0,1],[0;0.1],ff);
x2=real(x2(:,1))

```

## 含有最高阶导数的非线性运算


$$
(y^\text{''}(t))^3+3y^\text{''}(t)\text siny(t)+3y^\text'siny^ \text{''}(t)=e^{-3t}\\y(0)=1,y^\text'(0)=-1
$$

$$
设：x_1(t)=y(t),x_2(t)=y^\text'(t),p(t)=y''(t)
$$

$$
化简：p^3(t)+3p(t)sinx_1(t)+3x_2(t)sinp(t)-e^{-3t}=0\\
\bf{x}^\text '(t)=\left[ \begin{array}{c} x_2(t)\\p(t)\end{array}\right]
$$

```matlab
function dx=c4exode1(t,x)
f=@(p)p^3+3*p*sin(x(1))+3*x(2)*sin(p)-exp(-3*t);
ff=optimset;ff.Tolx=eps;ff.TolFun=eps;
p=fsolve(f,x(1),ff);df[x(2);p];
ff=odeset;ff.AbsTol=100*eps;ff.RelTol=100*eps;
[t,x]=ode45(@c4exode1,[0,4],[1;-1],ff);
```

# 矩阵型微分方程

$$
MX''(t)+CX'(t)+KX(t)=F\mu(t)
$$

M,C,K是$$n*n$$ 的矩阵 X,F是$$n*1$$ 的列向量

引入:$$x_1(t)=X(t),x_2(t)=X'(t),则x^\text'_1=x_2(t),x^\text'_2(t)=X''(T)$$



#Neural mass model

**为什么将复数分解为实部和虚部？**

复数变量 $$  z_i = x_i + j y_i $$ 中，$$ x_i $$ 是实部，$$ y_i $$ 是虚部。复数的操作通常涉及到它的模和幅角，或者直接在实部和虚部之间进行计算。在你的方程中，复数的出现通常意味着这两个部分（实部和虚部）都需要独立地演化，进而影响整个系统的动态。

**你的方程中有复数项：**

$$\frac{dz_i}{dt} = \left( a_i + j \omega_i - |z_i|^2 \right) z_i + \sigma_{in} \xi_i$$

其中 $$ |z_i|^2 = x_i^2 + y_i^2$$ 是复数 $$z_i $$ 的模的平方，$$j $$ 是虚数单位。因此，复数的演化不仅仅影响实部，还影响虚部。

**复数求解的步骤通常是：**

1. **分解复数为实部和虚部**：复数 $$ z_i $$ 可以写为 $$ z_i = x_i + j y_i $$，其中 $$ x_i $$ 和 $$ y_i $$ 是实部和虚部。
2. **分别求解实部和虚部**：将原方程中的复数 $$ z_i $$ 代入 $$ z_i = x_i + j y_i $$ 后，我们得到两个新的方程：一个描述实部 $$ x_i $$，另一个描述虚部 $$ y_i $$。
3. **使用数值方法求解**：这些新方程是普通的实数微分方程，可以使用标准的数值方法（如 `ode45`）进行求解。

在 MATLAB 中，复数被自动处理，但为了方便操作和理解，我们将复数方程分解成两个实数方程，并用实数求解方法进行求解。这样可以确保每一部分的物理意义更加清晰，同时可以利用现有的数值解法。

**数值解法的步骤：**

1. **分解复数变量**：在 MATLAB 中，我们将复数变量分解为实部和虚部，分别处理。即 $$ z_i $$ 被表示为实部 $$ x_i  $$ 和虚部 $$ y_i $$。
2. **定义方程**：根据给定的微分方程，分别对实部和虚部编写对应的方程。
3. **使用 `ode45` 求解**：通过 MATLAB 的 `ode45` 函数来数值求解这些方程。
4. **合并结果**：求解完成后，得到的实部和虚部可以组合成复数解。

$$\frac{dy_i}{dt} = (a_i - x_i^2 - y_i^2) y_i + \omega_i x_i + g \sum_{j=1}^N W_{ij} (y_j - y_i) \sigma_{in} \xi_i$$

$$\frac{dx_i}{dt} = (a_i - x_i^2 - y_i^2) x_i + \omega_i y_i + g \sum_{j=1}^N W_{ij} (x_j - x_i) \sigma_{in} \xi_i$$

```matlab
% Define parameters
N = 10; % Number of variables
a = rand(1, N); % Vector of a_i constants
omega = rand(1, N); % Vector of omega_i constants
g = 1; % Coupling constant
sigma_in = 0.1; % Noise standard deviation
W = rand(N, N); % Weight matrix (randomly initialized)
xi = randn(1, N); % Random noise term

% Define the system of differential equations
% xi and yi are the vectors containing x_i(t) and y_i(t) values

dxdt = @(t, z) [(a - z(1:N).^2 - z(N+1:2*N).^2) .* z(1:N) - omega .* z(N+1:2*N) + g * W * (z(1:N) - z(1:N)') + sigma_in * xi';
                (a - z(1:N).^2 - z(N+1:2*N).^2) .* z(N+1:2*N) + omega .* z(1:N) + g * W * (z(N+1:2*N) - z(N+1:N)') + sigma_in * xi'];

% Time vector
tspan = [0 100]; % Time range

% Initial conditions for x_i and y_i
x0 = zeros(N, 1);
y0 = zeros(N, 1);
z0 = [x0; y0]; % Initial state vector

% Solve the system of equations
[t, z] = ode45(@(t, z) dxdt(t, z), tspan, z0);

% Extract the solutions for x_i and y_i
x = z(:, 1:N);
y = z(:, N+1:end);

% Plot the results
figure;
subplot(2, 1, 1);
plot(t, x);
xlabel('Time');
ylabel('x_i(t)');
title('Solution for x_i(t)');
legend(arrayfun(@(i) sprintf('x_%d(t)', i), 1:N, 'UniformOutput', false));

subplot(2, 1, 2);
plot(t, y);
xlabel('Time');
ylabel('y_i(t)');
title('Solution for y_i(t)');
legend(arrayfun(@(i) sprintf('y_%d(t)', i), 1:N, 'UniformOutput', false));

```

