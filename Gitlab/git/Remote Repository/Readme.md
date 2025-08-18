# Remote repository

- show remote repository
```
git remote -v
```

### add remote origin with https
<img width="1246" height="869" alt="image" src="https://github.com/user-attachments/assets/02fd8073-cbbf-4fa6-bb55-33f81567f367" />

```
git remote add origin https://gitlab.com/username/project.git
```
- change remote origin address
```
git remote set-url origin https://gitlab.com/username/project.git
```

### add remote origin with ssh
```
git remote add origin git@gitlab.com:username/project.git
```
- change remote origin address
```
git remote set-url origin git@gitlab.com:username/project.git
```

### Remove remote origin
```
git remote remove origin
```

### git commit and git push
```
git commit -m "Commit for this change"
git push origin branch-name
```




* 1)Generating a new SSH key

```
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
* 2)copy key to clipboard
```
cd ~/.ssh
ls
cat id_rsa.pub
```
* 3)insert key to github.com
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
  - login to your user
  - setting > SSH and GPG keys > add New SSH Ke
    
### Verify :
```
ssh -vT git@github.com
ssh -T rezaabedi1365@github.com
```
--------------------------------------


--------------------------------------------------------
* git remote
  ```
  git remote
  ```
* git remote add
  ```
  git remote add
  ```
* git remote rm
  ```
  git remote rm
  ```
* git pull
  ```
   git pull git@github.com:rezaabedi1365/Devops.git
  ```
* git fetch
  - git fetch <remote> <branch>
  ```
  git fetch
  ```
* git merge
  ```
  git merge
  ```
* git push 
  ```
  git push --set-upstream git@github.com:rezaabedi1365/Devops.git masterl 
  ```

