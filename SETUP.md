# 环境配置记录

> 日期:2026-08-28 · 机器:macOS Darwin 24.6 (arm64, Apple Silicon)
> 目标:1) 让 dsh 摆脱终端手工启动,后台常驻、开机/崩溃自启;2) 用 `~/wks` 统一管理 vim / tmux / zsh 配置

---

## 1. dsh 服务托管(launchd)

### 背景

原需求是 systemd,但 **macOS 没有 systemd**,等价物是 **launchd**(`launchctl`)。两者能力对照:

| 需求 | systemd | launchd |
|---|---|---|
| 开机/登录自启 | `[Install] WantedBy=multi-user.target` | `RunAtLoad = true` |
| 崩溃自动重启 | `Restart=always` | `KeepAlive = true` |
| 防崩溃循环 | `StartLimitIntervalSec` | `ThrottleInterval = 5` |
| 用户态服务 | `systemctl --user` | `gui/<uid>` 域(LaunchAgent) |
| 系统级服务 | systemctl | `system/` 域(LaunchDaemon) |

采用 **LaunchAgent**(`~/Library/LaunchAgents`):登录即启、以当前用户运行、无需 sudo。域写法 `gui/$(id -u)` 即 `gui/501`(当前用户 UID)。

### 涉及文件

| 路径 | 作用 |
|---|---|
| `~/Library/LaunchAgents/com.dsh.web.plist` | launchd 服务定义(`RunAtLoad` + `KeepAlive` + `ThrottleInterval 5`) |
| `~/dsh-web.sh` | 启动包装脚本:设 PATH → `cd` 仓库根 → `node --import tsx/esm apps/cli/src/bin.ts web --no-open` |
| `~/Library/Logs/dsh-web.log` / `dsh-web.error.log` | 标准输出/错误日志 |
| `~/.dsh/dsh-web-service.sh` | 日常管理脚本 |

要点:`--no-open` 防止后台服务启动时弹浏览器;默认监听 `127.0.0.1:3080`;凭据在 `~/.dsh/.credentials.yaml`,launchd 以同用户运行即可读取。

### 命令速查

```bash
# 注册并启动(登录自启 + 崩溃自动重启)
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.dsh.web.plist

# 查看状态 / 强制重启 / 停止卸载
launchctl print gui/$(id -u)/com.dsh.web
launchctl kickstart -k gui/$(id -u)/com.dsh.web
launchctl bootout gui/$(id -u)/com.dsh.web

# 日志
tail -f ~/Library/Logs/dsh-web.log
```

或用管理脚本:

```bash
~/.dsh/dsh-web-service.sh {setup|start|status|check|restart|stop|logs|crash-test}
```

> 注:浏览器访问 `http://127.0.0.1:3080` 正常;裸 `curl` 返回 401 是认证质询,属正常现象。

---

## 2. Vim(wks/dotvimdir)

### 安装方式:符号链接

```bash
ln -s /Users/zeuspan/wks/dotvimdir ~/.vim
ln -s /Users/zeuspan/wks/dotvimdir/dotvimrc ~/.vimrc
```

旧 `~/.vim` 已备份为 `~/.vim.bak-<时间戳>`(仅含 .netrwhist)。

### 插件

```bash
vim -es -u ~/.vimrc -c 'PlugInstall --sync' -c 'qa!'   # vim-plug 全量安装
```

已装 43 个插件(vim-plug 默认目录 `~/.vim/plugged`),主要:YouCompleteMe、LeaderF、fugitive、vim-orgmode、ultisnips、ale、gutentags、fzf.vim 等。

### 编译状态

| 组件 | 状态 | 说明 |
|---|---|---|
| YCM 核心 | ✅ 已编译 | `ycm_core.cpython-314-darwin.so`,`python3 install.py --clang-completer`;Python 3.14 可用 |
| YCM 降级 1 | ⚠️ setuptools 缺失 | 文件监听走 kqueue(稍慢,功能正常);想用 fsevents 需在 venv 装 setuptools 后重跑 install.py |
| YCM 降级 2 | ⚠️ regex 模块未编译 | 回退内置 `re`,功能正常 |
| LeaderF C 扩展 | ⚠️ 未编译 | 回退纯 Python 匹配(可用);如需加速:解决 setuptools 后 vim 内 `:LeaderfInstallCExtension` |
| fzf / bat / rg / cmake | ✅ | brew 安装(fzf 0.74.3 / rg 15.2.0 / bat 0.26.1 / cmake 4.4.3) |

验证:无头加载 `vim -es -u ~/.vimrc -c 'qall'` 应 exit 0、无报错。

---

## 3. Tmux(wks/dottmux)

```bash
ln -s /Users/zeuspan/wks/dottmux/dottmux.conf ~/.tmux.conf
ln -s /Users/zeuspan/wks/dottmux/dottmux.conf.local ~/.tmux.conf.local
```

- 基于 gpakosz/oh-my-tmux;tmux 3.7c(brew,需 ≥2.1)
- 验证:`tmux new-session -d -s test && tmux show-options -g prefix && tmux kill-session -t test`,应输出 `prefix C-a`
- 常用键:`<prefix> e` 编辑 .local、`<prefix> r` 重载、`<prefix> m` 鼠标开关
- 可选:macOS 剪贴板增强 `brew install reattach-to-user-namespace`(配置自动检测)

---

## 4. Zsh + Powerlevel10k

```bash
ln -s /Users/zeuspan/wks/dottmux/dotzshrc ~/.zshrc
ln -s /Users/zeuspan/wks/dottmux/dotp10k.zsh ~/.p10k.zsh
```

- zsh 为默认 shell;插件管理用 **antigen**(`~/wks/antigen/antigen.zsh` → `bin/antigen.zsh`)
- 主题:antigen theme romkatv/powerlevel10k + `~/.p10k.zsh` 个性化
- ⚠️ **首次开新终端较慢(几分钟)**:antigen 需联网克隆 ~15 个插件与 p10k 到 `~/.antigen/bundles/`,一次性行为
- `~/.fzf.zsh` 不存在时第 285 行静默跳过,不影响使用
- ⚠️ `~/.zshrc` 是符号链接:任何"向 .zshrc 追加"的工具(fzf install、pyenv init 等)会直接写入 wks 仓库
- `$ch`(openbmc 构建路径)在 dotzshrc 第 224 行,仅相关 alias 调用时生效

---

## 5. 沙箱/权限备注

本机调试环境的文件沙箱(workspace-write)会拦截以下操作,需在**用户自己的终端**执行或显式批准全权限:

- `brew install ...`(写 `/opt/homebrew`,工作区之外)
- `tmux` 启动验证(fork 进程被禁)
- 同理,launchctl 装载服务也可在用户终端执行

---

## 附:整体验证清单

```bash
# dsh 服务
launchctl print gui/$(id -u)/com.dsh.web | grep state    # running
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:3080   # 401(正常)

# vim
vim -es -u ~/.vimrc -c 'qall' && echo OK

# tmux
tmux new-session -d -s t && tmux show-options -g prefix && tmux kill-session -t t

# zsh(新开终端)
zsh -n ~/.zshrc && echo OK   # 语法检查;完整加载需新终端触发 antigen 首次克隆
```
