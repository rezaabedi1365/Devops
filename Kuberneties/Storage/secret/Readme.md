# Secret

```
kubectl create secret generic literal-secret \
--from-literal=username=admin \
--from-literal=passwork=123456aA 
```

```
apiVersion: v1
kind: secret
metadata:
  name: mysql-secret
type:
data:
  username: admin
  password: 123456aA

```

verify:
```
kubectl get secret
```



![image](https://github.com/user-attachments/assets/23440d25-5106-4a07-9d40-6d0ff9ddf100)


![image](https://github.com/user-attachments/assets/6550e4c5-9b80-4849-8508-3382986cdf88)




![image](https://github.com/user-attachments/assets/938fd883-7568-409b-afcb-5c6d28c500a8)
