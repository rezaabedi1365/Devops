

## git remote
```
git remote -v
```
### add remote origin with https
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
