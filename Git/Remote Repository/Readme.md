# Remote repository
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/77fd84f5-1f13-4e26-a58a-e7c8c3230a98)
## git config
```
git config --global github.user YOUR_USERNAME
git config --global github.token YOURTOKEN
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

