# Version control system (vcs) 
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/6455c93f-d8e1-4d94-8acc-d172af790592)

-----------------------------------------------------------------
## git state

* 1- unstage ( untracked files)
    ```
    git init
    ```
    ![image](https://github.com/rezaabedi1365/Devops/assets/117336743/3c2ab70e-8a9e-4425-9d91-755f8dc5196b)

* 2- staged 
    ```
    git add File_Name
    git add *
    ```
    ![image](https://github.com/rezaabedi1365/Devops/assets/117336743/8ac3ffac-cf53-492a-a531-7dfb57fda439)


* 3- working
    ```
    git commit -m Commit_Name
    ```
    ![image](https://github.com/rezaabedi1365/Devops/assets/117336743/c4e51818-d42d-4a69-84a7-85faeec49892)


## Verify:
```
git status
git log
```

 
---------------------------------------------------------------------
# git Configuration 

* 1-System 
  - /etc/gitconfig 
    ```
    git config --system user.name "Reza Abedi"
    git config --system user.email r.abedi@faradis.net
    ```
        
* 2-User 
  - ~/.gitconfig 
    ```
    git config --global user.name "Reza Abedi"
    git config --global user.email r.abedi@faradis.net
    ```
* 3-Project
  - My_projcet/.git/config
    ```
    git config --local user.name "Reza Abedi"
    git config --local user.email r.abedi@faradis.net
    ```
## Verify:
```
git config --list
``` 
  
----------------------------------------
 * local repository
      - git config
      - git init
      - git add
      - create Difrent Project 
      - git branch 
      - git checkout 
      - git Head 
      - git Clean 
      - git reset/revert/restore 
      - gitignore 
      - tree-ish 
      - git stash 


* remote repository
      - git remote 
      - git pull 
      - git push 

 
