https://medium.com/@mucahitkumlay/kubernetes-install-with-ansible-7dbd958584e5



```
git clone https://gitlab.com/mucahitkumlay/ansible.git && cd ansible 
chmod +x start.sh && ./start.sh
```

```
ansible-playbook -i hosts master.yml && 
ansible-playbook -i hosts worker.yml &&
ansible-playbook -i hosts docker.yml &&
ansible-playbook -i hosts kubernetes.yml
```
