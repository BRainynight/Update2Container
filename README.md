這是一個小小的實驗，目的是對付有多個邊緣裝置需要同步更新的情況。

1. 由於某些原因，使用 `docker swarm` 不實際，且由於在開發階段，希望能盡量減低 build 的次數，卻能夠時時更新。

2. 使用資料卷(volume) 只能將修改的 source code 掛在當前的機子上，沒辦法擴展到其他機子。

3. dockerhub 自動更改 tag 名稱需要付費版。除非每次 upload 新的 image 時都特別去把舊的拉下來改名稱，或是直接覆寫(但顯然這個作法很恐怖)。
不想要每次改 code 都要重新 build image ，要進去每一台邊緣裝置修改 docker-compose.yml 很麻煩。

當然另外一個想法是用 docker 官方教學提過得資料卷容器，但這裡偷懶一點：每次開 continer 的時候都先把當前最新的 source code clone 下來。



## Dockerfile
```Dockerfile
# ... 建置環境省略

WORKDIR ~/Desktop
COPY docker-start.sh docker-start.sh
RUN chmod +x docker-start.sh

ENTRYPOINT ["./docker-start.sh"] # 用腳本的方式執行 git clone，才不會把這層寫死在 image 裡面
CMD ["python",  "Update2Container/hello.py"]
```

而 `docker-start.sh` 如下：
```sh
#!/bin/bash
git clone https://github.com/BRainynight/Update2Container.git
exec "$@" # 不啟用新的 shell, 在當前 shell 執行, 並且局部設置的 variable 在命令結束後依然有效 https://www.jianshu.com/p/ca012415cd5f
```
