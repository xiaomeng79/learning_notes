## Wget

#### 下载一个全部的网站内容

```bash
wget \
     --recursive \
     --no-clobber \
     --page-requisites \
     --html-extension \
     --convert-links \
     --restrict-file-names=windows \
     --domains www.zuiyou.tv \
     --no-parent \
         http://www.zuiyou.tv/
         
```