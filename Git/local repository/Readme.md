# local repository
* git config
* git init
* git add
* git reset
  - soft 
    ```
    git reset --soft
    ```
  - hard
    ```
    git reset --hard
    ```
  - mixed
    ```
    git reset --mixed
    ```
  - verify:
    ```
    cat .git/HEAD
    cat .git/refs/heads/master
    ```
* git revert
* git restore
* git Clean
    ```
    git clean –n 
    git clean -i    ( show menu for clean) 
    git clean –f   (Delete untrack file from working directoory)
    ```
* git .ignore
    create .ignore file
    ```
    touch .ignore
    echo >>  file2 ./.gitignore
    echo >>  ./dir2 ./.gitignore
    ```
* git branch 
* git checkout 
* git Head 
 
      
* gitignore 
* tree-ish 
* git stash 
