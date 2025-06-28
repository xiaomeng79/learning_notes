# Mac

## 工具

  - [iterm2](https://iterm2.com/)
  - [ohmyz](https://ohmyz.sh/) oh-my-zsh插件 zsh-autosuggestion自动补全 和 zsh-syntax-highlighting语法高亮
  - [brew](https://brew.sh/)
  - [vscode](https://code.visualstudio.com/) [cursor](https://www.cursor.com/) 编辑器
  - [clashX](https://en.clashx.org/download/) [nodefree](https://clashgithub.github.io/) [oneclash](https://oneclash.githubrowcontent.com/2025/06/20250617.yaml)
  - [dbeaver](https://dbeaver.io/)
  - [tableplus](https://tableplus.com/)
  - [rustdesk](https://rustdesk.com/)
  - [microsoft-remote-desktop-for-mac](https://install.appcenter.ms/orgs/rdmacios-k2vy/apps/microsoft-remote-desktop-for-mac/distribution_groups/all-users-of-microsoft-remote-desktop-for-mac)
  - [java](https://www.azul.com/downloads/?package=jdk#download-openjdk)


## 关闭禁用 ReportCrash
 
```shell
# 关闭
launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist 
#下面是启用的方法
launchctl load -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist 
```

 

