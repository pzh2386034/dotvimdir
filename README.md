# Requirements

## Macos

```
brew install vim
echo "alias vim="/usr/local/bin/vim""
```

## YouCompleteMe

```
python3 install.py [--system-libclang] --clang-completer #only support c/c++ complete(--all for all)
cd /ycm/pluggin/dir
python3 install.py
```

"The ycmd server shut down":need to install ycm

## ripgrep

* download ripgrep\_13.0.0\_amd64.deb file

    ```
    wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
    ```

### upgrade cmake for ubuntu16.04

    ```
	sudo apt remove --purge --auto-remove cmake
	sudo apt purge --auto-remove cmake
	sudo apt update && \
	sudo apt install -y software-properties-common lsb-release && \
	sudo apt clean all
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
	sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
	sudo apt update
	sudo apt install kitware-archive-keyring
	sudo rm /etc/apt/trusted.gpg.d/kitware.gpg
	sudo apt update
	sudo apt install cmake
	```

# Commands

## tag

* mark-- m{a\_zA\_Z}

* jump-- `{a\_z} '{a\_z}; d`a--del from cur chararcter upto mark a`

## jump

* gf-- goto file under cursor;   c-w f-- goto file and open new window;

* g;--goto previous change(stack); g,--goto newer change; gi--goto last in insert mode

* c-]--jump to tag def; c-w ](g c-])--jump to tag def in new window; g]--list all def and select jump; gl--jump to reference

* */#--go next/previous of the world under the cursor cursor; g*/#--search the word under cursor in forward/backward

## file & tab

* :e %:h/appcode.c

## search

* c-p--rg file name search; ,f/,l/,a/,t/,b/,r/--search function/word/string/tag in current file; ,b--buffer file search

## quick fix(:h text-objects)

* diw--delete word; di"--del content in ""; da'-- del content in ''; ci([{:del content in () and insert; ya)/]/}:copy()/[]/{}content 
* cs"'--修改"->'; ds"--删除双引号; ysiw"--给单词加""; yss"--给整行加"; 

* <c-r> "--yank in insert mode

## register

* "%--current file name; ".--current insert test; ":--previous command line; "[0-9]--test save in 0-9 registers

* @:--exe previous command;

## bash

* :%!command--exe command and not change file content; :.!command--exe command and relace cur line; :so %--reload current file by bash

* :setlocal tags+=~/.cache/tags/*

* :sh--open ssh session within vim and exit to ret

## screen

* :tabc--关闭当前tab; :tabo--关闭所有其它tab; :tabs--查看所有打开tab; :tabp; :tabn

## Git

* :Gvdiffsplit--分屏显示本文件差异(可用于解决冲突); :G difftool -y--分屏显示所有文件差异

    * dp,do:stage/upstage trunk

`在冲突中使用Gvdiffsplit出现3个屏幕，]c, d2o, d3o`

* :G log
    
    * coo:签出到当前commit; o:分屏打开commit(git show commit); <Enter>:打开commit

* Gread, Gwrite master:filename

* :G
    
    * X--checkout 当前文件; I/P--按hunk stage本文件; [c,]c--按hunk浏览; [m,]m--按文件浏览; C--查看当前文件上一次commit
    * i--跳到next file/hunk,自动展开hunk浏览
    * cc--commit; ca/ce--amend last comm且编辑/不编辑; cw--改写上次comm; cvc/cva--comm显示所有待提交内容; cf/cF--提交(--fixup)/并且rebase; cs/cS--提交(--squash)/并且rebase
    * czz--git stash; czp/P--pop stash/不保留index
    * rebase:ri--交互式rebase; rr--继续rebase; ra--abort rebase; re--编辑base todo list

## org-mode

* <leader>hn/N--创建同级标题
* m{/}--标题上下移动; m[[/]]--subtree上下移动
* <</>>--标题级别增减; <ar/>ar--subtree级别增减
* <leader>caT--显示TODO列表; <leader>caA--显示日程表
* <leader>ct--TODO状态循环; <leader>d--快速创建TODO标签

### checkbox

* <leader>cc--切换checkbox entry状态; <leader>cn/N--新增checkbox entry

### tags

* <leader>st--新增tag; <leader>gt--搜索tag

### hylinks(need install suliveevil/utl.vim)

* gl--goto link; gyl--yank link; gil--insert new link; gn/go--next/previous link

### timestamp

* <c-x>--按年/月/日修改1; <leader>sa/i--插入日期/inactive 

## nerdcommenter 代码注释

* ,c<space>--toggle注释; ,cc--注释; ,cm--只用一组符号注释; ,aA/$--在行尾添加注释; ,cs--块注释; ,ca--切换//和/**/; ,cu取消注释

## fzf 

### ubuntu install
```
sudo apt update
sudo apt install snapd
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
sudo dpkg -i bat_0.20.0_amd64.deb
chsh -s $(which zsh)
```

### macos install
```
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
# vim use fzf 
set rtp+=/opt/homebrew/opt/fzf
brew install bat
```
* fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'

## forgit

### keymap

* gsw->git stash; gsx->git stash drop; gsa->git stash pop; gss->git stash
* gst->git status
* gshow/glo->git log 
* gsd->git diff; ga->选择git diff文件
* grb->git rebase
* gcb/o/f/t->git checkout branch/commit/file/tag; gbd->git branch -D
* grh->git reset; grc->git revert commit
* gclean->删除文件
