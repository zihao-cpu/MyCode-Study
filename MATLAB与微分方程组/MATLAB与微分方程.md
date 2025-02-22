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

