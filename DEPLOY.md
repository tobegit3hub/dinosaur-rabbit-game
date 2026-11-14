# EdgeOne 海外区部署

## 线上地址

- 项目域名：<https://dinosaur-rabbit-overseas-xyxukpxs.edgeone.dev>
- 项目：`dinosaur-rabbit-overseas`
- 项目 ID：`makers-alelgyrrkazs`
- 加速区域：**全球可用区（不含中国大陆）**，即 overseas
- 控制台：<https://console.cloud.tencent.com/edgeone/pages/project/makers-alelgyrrkazs>

## 重要：国内访问 401 是预期行为

EdgeOne 的 `*.edgeone.dev` 项目域名在**中国大陆网络**访问时会返回
`401 UNAUTHORIZED`，需要系统生成的 3 小时预览链接；非中国大陆网络可直接访问。
这是海外区项目域名的访问规则，不代表部署失败。

后续绑定自己的域名后，用自定义域名作为稳定入口；海外区（不含中国大陆）
绑定未备案域名**不要求 ICP 备案**。如果主要用户在境内且要求稳定速度，
仍建议备案并使用中国大陆/全球（含中国大陆）区域。

## 重新部署

```bash
cd ~/docs/family/qianqian/qianyu_use_ai/dinosaur-rabbit
./deploy-overseas.sh
```

不要直接执行 `edgeone makers deploy .`：CLI 会把当前目录名一起打进 zip，
站点会变成 `/dinosaur-rabbit/index.html`，根路径返回 404。脚本会生成一个
`index.html` 位于根目录的 zip 再上传。

## 后续绑定未备案域名

1. 打开上面的控制台链接，进入项目的 **域名管理**。
2. 点击 **添加自定义域名**，填入根域名或子域名。
3. 按弹窗提示在域名注册商处添加 **归属权验证** 记录。
4. 再添加弹窗给出的 **CNAME** 记录，指向 EdgeOne 分配的接入目标。
5. 在 EdgeOne 配置 HTTPS 证书（可用免费证书），等待状态变为已生效。

海外区添加域名不需要备案；CNAME 的具体目标值以控制台弹窗为准。
