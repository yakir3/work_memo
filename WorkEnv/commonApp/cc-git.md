```shell
git reset --hard HEAD^ 回退上一个版本
HEAD^^ 两个版本
HEAD~10 10个版本
fd301d 指定版本
git reflog 每次执行命令
git checkout -- file 撤销修改区回到最新版本
git reset HEAD file 撤销添加暂存区回到修改区 撤销add，回到修改区
git rm 删除文件
.gitignore 忽略提交到git
git remote add origin git@github.com:phpyakir/testgit 关联github远程库
git push -u origin master 推送到远程库
git remote -v 查看所有远程库信息
git config --global alias.test "command" 别名
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git branch dev
git tag v1.0 dsv34dsdv 根据版本号打标签
git push origin v1.0 推送标签版本到远程库
git push origin --tags 一次性全部推送所有表桥
git tag -d v0.9 本地删除标签
git push origin :refs/tags/v0.9 远程删除标签
git checkout -b dev 创建并合并分支
git branch dev 创建分支
git branch -d dev 删除分支
git merge dev 合并dev分支到当前分支，fast-forward模式 新版本git
git merge --no-ff -m "merge with no-ff" dev 删除分支后保留合并记录
git log --graph --pretty=oneline --abbrev-commit 查看分支记录
git stash 储存当前工作
git stash list git stash pop 恢复工作并删除 == git stash apply + git stash drop
git cherry-pick 4c805e2 复制某一个特定提交到当前分支 既可在master分支上修复bug后，在dev分支上可以“重放”这个修复过程，也可以在dev分支上修复bug，然后在master分支上“重放”
git checkout -b dev origin/dev 创建本地分支管理远程dev分支
git push origin dev 推送dev分支到远程dev分支
git branch --set-upstream-to=origin/dev dev 关联本地和远程dev分支
git pull 拉取远程dev分支合并到本地
```
