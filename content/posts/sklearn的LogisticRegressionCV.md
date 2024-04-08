---
title:  sklearn的LogisticRegressionCV
date: 2024-04-08
---


```python
from sklearn.linear_model import LogisticRegressionCV

lr = LogisticRegressionCV(Cs=C_RANGE, cv=5, scoring="neg_log_loss")
lr.fit(X_train_full, y_train_full)
lr.scores_
```

LogisticRegressionCV的求解器中基本都会用到warm-start，既下一次的拟合过程中，参数会被上一次的拟合过程影响。这是它速度快的原因。这也解释了为什么上面的代码和下面的代码跑出来的结果不一样：

```python
ll=[]
for C in C_RANGE:
    lm = LogisticRegressionCV(Cs=[C], cv=5, scoring="neg_log_loss")
    lm.fit(X_train_full, y_train_full)
    ll.append(lm.scores_[1])
print(ll)
```
当然，使用第一个C值拟合时的结果是一样的，因为这时候warm-start并没有”上一轮“。



参数列表中加入 `solver="liblinear"` 可以让上面两种方法达成同样的结果，但是这种求解器没有热启动，所以fit过程非常慢。