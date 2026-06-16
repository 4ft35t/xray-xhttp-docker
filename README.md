# xray-xhttp-docker
在 docker 中运行 xray，以 xhttp 协议传输

方便在各容器平台运行，整体方案是 vless + xhttp + CDN，容器平台的子域名在这里替代了 CDN 位置。

本项目仅是为了临时获得某个特定地区的 IP，不可作为日常使用。

在容器平台将 docker 部署到对应区域，即可活得对应地区的出口 IP。

使用 Xray，原生支持 UDP。

关键配置内容存储在 `Secrets`, 容器重启也不丢配置。

## 使用方法
### 服务端
在容器平台添加两个 `Secrets`
- `UUID` 使用 `xray uuid` 生成
- `XHTTP_PATH` 使用 `xray uuid | cut -d- -f1` 生成，__没有 /__

部署完成后即可使用。

### 客户端
- vless://<YOUR_UUID>@<YOUR_APP_HOST>:443?encryption=none&security=tls&type=xhttp&path=%2F<YOUR_XHTTP_PATH>#DOCKER_VLESS_XHTTP
- clash 格式配置
  ```yaml
    - {name: DOCKER_VLESS_XHTTP, server: <YOUR_APP_HOST>, port: 443, type: vless, uuid: <YOUR_UUID>, tls: true, xhttp-opts: {path: /<YOUR_XHTTP_PATH>, mode: auto}, network: xhttp}
  ```
  
