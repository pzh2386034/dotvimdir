# Requirements

## YouCompleteMe

```
python3 install.py --clangd-completer #only support c/c++ complete(--clang-completer for all)
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

## search

* c-p--rg file name search; ,f/,l/,a/,t/,b/,r/--search function/word/string/tag in current file; ,b--buffer file search

## quick fix(:h text-objects)

* diw--delete word; di"--del content in ""; da'-- del content in ''; ci([{:del content in () and insert; ya)/]/}:copy()/[]/{}content 


## register

* "%--current file name; ".--current insert test; ":--previous command line; "[0-9]--test save in 0-9 registers

* @:--exe previous command;

## bash

* :%!command--exe command and not change file content; :.!command--exe command and relace cur line; :so %--reload current file by bash

* :setlocal tags+=~/.cache/tags/*

* :sh--open ssh session within vim and exit to ret
