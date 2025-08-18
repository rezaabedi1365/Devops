# Remote repository

- show remote repository
```
git remote -v
```

# add remote origin 

<img width="1246" height="869" alt="image" src="https://github.com/user-attachments/assets/02fd8073-cbbf-4fa6-bb55-33f81567f367" />
### add remote originwith https
```
mkdir project1
cd project1
git remote add origin http://10.10.12.18/pushgroup/pushproject.git
git branch -M main
git push -uf origin main
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
## git branch
```
git branch                   # نمایش شاخه‌ها
git branch <branch_name>     # ایجاد شاخه جدید
git checkout <branch_name>   # رفتن به شاخه مورد نظر
git checkout -b <branch_name> # ایجاد و رفتن به شاخه جدید همزمان
git merge <branch_name>      # ادغام شاخه با شاخه فعلی
git branch -d <branch_name>  # حذف شاخه
```
## git commit 
```
git commit -m "Commit for this change"
```

## git pull and git clone
```
git clone http://10.10.12.18/pushgroup/pushproject.git
git pull http://10.10.12.18/pushgroup/pushproject.git
```

## git push
```
git push --set-upstream <remote> <branch>
git push --set-upstream http://10.10.12.18/pushgroup/pushproject.git main
```

## git fetch
```
git fetch <remote> <branch>
git>git fetch http://10.10.12.18/pushgroup/pushproject.git main
```



--------------------------------------------------------------------------------------------------------------------------------------------
# add remote origin with SSH
* 1)Generating a new SSH key in your client system

```
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
<img width="662" height="421" alt="image" src="https://github.com/user-attachments/assets/348c5dfa-3574-46f7-a550-53c31f7fb61e" />

* 2)copy key to clipboard
- in windows
```

```
- in linux
```
cd ~/.ssh
cat id_rsa.pub
```
* 3)insert key in gitlab or github.com
- gitlab
<img width="1706" height="856" alt="image" src="https://github.com/user-attachments/assets/9313e6da-12bf-4120-af4c-584e99be0850" />



- github
  * https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
  * login to your user
  * setting > SSH and GPG keys > add New SSH Ke
    
### Verify :
```
ssh -vT git@github.com
ssh -T rezaabedi1365@github.com
```




