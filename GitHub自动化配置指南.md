# GitHub Actions 自动化配置指南

## 🎯 目标
实现 Horizon 项目在 GitHub 上自动运行，无需你的电脑开机。

## 📋 前置要求

- GitHub 账号（免费）
- 项目代码（已完成配置）
- 星火 API 密钥（已配置）
- GitHub Token（已获取）

## 🚀 配置步骤

### 第1步：创建 GitHub 仓库

1. **访问 GitHub**
   - 打开浏览器，访问：https://github.com/new

2. **创建新仓库**
   - Repository name: `horizon` （或你喜欢的名字）
   - Description: `AI驱动的科技新闻聚合系统`
   - Public/Private: 选择 **Public**（如果想免费使用 GitHub Pages）
   - 不要勾选 "Add a README file"
   - 点击 **Create repository**

3. **复制仓库地址**
   - 会显示类似这样的地址：
   ```
   https://github.com/你的用户名/horizon.git
   ```
   - 复制这个地址

### 第2步：上传项目到 GitHub

在 PowerShell 中执行以下命令：

```powershell
# 1. 进入项目目录
cd D:\horizon\Horizon

# 2. 初始化 Git 仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交更改
git commit -m "Initial commit: Horizon project setup"

# 5. 设置主分支
git branch -M main

# 6. 连接到 GitHub 仓库（替换成你的仓库地址）
git remote add origin https://github.com/你的用户名/horizon.git

# 7. 推送到 GitHub
git push -u origin main
```

**如果遇到认证问题：**

```powershell
# 使用 GitHub Token 认证
# 在推送时，用户名输入：你的GitHub用户名
# 密码输入：你的GitHub Token（ghp_xxx格式）
```

### 第3步：配置 GitHub Secrets（重要！）

1. **进入仓库设置**
   - 在 GitHub 仓库页面
   - 点击顶部的 **Settings** 标签

2. **进入 Secrets 配置**
   - 在左侧菜单中找到 **Secrets and variables**
   - 点击 **Actions**

3. **添加 Secrets**

   #### 添加 SPARK_API_PASSWORD：
   - 点击 **New repository secret**
   - Name: `SPARK_API_PASSWORD`
   - Value: 你的星火 API 密钥（从 .env 文件中复制）
   - 点击 **Add secret**

   #### 添加 GITHUB_TOKEN：
   - 点击 **New repository secret**
   - Name: `GITHUB_TOKEN`
   - Value: 你的 GitHub Token（ghp_xxx格式）
   - 点击 **Add secret**

   **可选：如果你有其他 API 密钥，也可以添加：**
   - `OPENAI_API_KEY`
   - `ANTHROPIC_API_KEY`
   - `GOOGLE_API_KEY`
   - `LWN_KEY`

### 第4步：启用 GitHub Actions

1. **进入 Actions 页面**
   - 在 GitHub 仓库页面
   - 点击顶部的 **Actions** 标签

2. **启用工作流**
   - 如果看到 "I understand my workflows, go ahead and enable them"
   - 点击这个按钮启用

3. **查看工作流**
   - 你应该能看到 "Daily Horizon Summary" 工作流
   - 状态显示为 "✓" 或等待运行

### 第5步：手动触发运行（测试）

1. **手动运行工作流**
   - 在 Actions 页面
   - 点击 "Daily Horizon Summary"
   - 点击 **Run workflow** 按钮
   - 点击绿色的 **Run workflow** 确认

2. **查看运行状态**
   - 等待几分钟
   - 点击运行记录查看详细日志
   - 确认没有错误

### 第6步：设置定时运行（可选）

如果你想要每天自动运行，需要修改配置文件：

1. **编辑配置文件**
   - 在 GitHub 仓库中
   - 找到 `.github/workflows/daily-summary.yml`
   - 点击编辑按钮（铅笔图标）

2. **启用定时任务**
   - 找到这部分：
   ```yaml
   # schedule:
   #   - cron: '0 0 */2 * *'  # Runs every 2 days at 00:00 UTC
   ```
   - 修改为：
   ```yaml
   schedule:
     - cron: '0 0 * * *'  # 每天凌晨0点运行（UTC时间）
   ```

3. **提交更改**
   - 在页面底部填写提交信息
   - 点击 **Commit changes**

**注意：**
- `cron: '0 0 * * *'` 表示每天 UTC 时间 0 点运行
- UTC 时间比北京时间晚 8 小时
- 如果要北京时间早上 8 点运行，用：`cron: '0 0 * * *'`（UTC 0点 = 北京8点）

### 第7步：启用 GitHub Pages（可选，用于展示日报）

1. **进入 Pages 设置**
   - 在仓库 Settings 页面
   - 左侧菜单找到 **Pages**

2. **配置 Pages**
   - Source: 选择 **Deploy from a branch**
   - Branch: 选择 **gh-pages**
   - Folder: `/root`
   - 点击 **Save**

3. **等待部署**
   - 几分钟后，访问：`https://你的用户名.github.io/horizon/`
   - 应该能看到生成的日报网站

## 📊 监控和管理

### 查看运行日志

1. **进入 Actions 页面**
   - 点击仓库的 **Actions** 标签

2. **查看运行记录**
   - 点击具体的工作流运行
   - 查看每个步骤的详细日志
   - 如果有错误，会显示红色

### 手动触发运行

任何时候都可以手动触发：

1. 进入 Actions 页面
2. 点击 "Daily Horizon Summary"
3. 点击 **Run workflow**
4. 选择分支（通常是 `main`）
5. 点击 **Run workflow**

## 🔧 故障排除

### 问题1：推送代码时认证失败

**解决方案：**
```powershell
# 使用 GitHub Token 进行认证
git remote set-url origin https://你的Token@github.com/你的用户名/horizon.git
git push -u origin main
```

### 问题2：Actions 运行失败

**检查步骤：**
1. 查看 Actions 日志，找到错误信息
2. 确认 Secrets 是否正确配置
3. 检查 API 密钥是否有效
4. 查看网络连接是否正常

### 问题3：定时任务不运行

**可能原因：**
- 定时任务被注释掉了（检查配置文件）
- GitHub Actions 没有启用
- 仓库是私有的（免费账号的定时任务有限制）

### 问题4：API 密钥错误

**解决方案：**
1. 重新生成 API 密钥
2. 在 GitHub Secrets 中更新
3. 重新运行工作流测试

## 💰 成本说明

### GitHub Actions 免费额度

- **公开仓库**：完全免费，无限制
- **私有仓库**：
  - 免费账号：每月 2000 分钟
  - Horizon 每次运行约 5-10 分钟
  - 每天运行一次：每月约 150-300 分钟
  - **完全够用！**

### GitHub Pages 免费额度

- **公开仓库**：完全免费，无限制流量
- **私有仓库**：每月 100GB 流量
- **完全够用！**

## 🎯 完成检查清单

配置完成后，确认以下项目：

- [ ] GitHub 仓库已创建
- [ ] 项目代码已推送到 GitHub
- [ ] SPARK_API_PASSWORD 已添加到 Secrets
- [ ] GITHUB_TOKEN 已添加到 Secrets
- [ ] GitHub Actions 已启用
- [ ] 手动运行测试成功
- [ ] （可选）定时任务已配置
- [ ] （可选）GitHub Pages 已启用

## 📱 查看结果

配置成功后，你可以：

1. **查看运行日志**
   - GitHub 仓库 → Actions 标签

2. **查看生成的日报**
   - GitHub 仓库 → data/summaries/ 目录
   - 或访问 GitHub Pages 网站

3. **设置通知**
   - GitHub Settings → Notifications
   - 选择接收 Actions 运行通知

## 🚀 下一步

配置完成后：

1. **测试运行** - 手动触发一次，确认一切正常
2. **查看结果** - 检查生成的日报质量
3. **调整配置** - 根据需要修改 `data/config.json`
4. **享受自动化** - 每天自动生成日报，无需干预

## 📚 相关资源

- GitHub Actions 文档：https://docs.github.com/en/actions
- GitHub Pages 文档：https://docs.github.com/en/pages
- Cron 表达式生成器：https://crontab.guru/

---

**配置完成后，你的 Horizon 项目将完全自动化运行！** 🎉

每天自动生成科技新闻日报，无需你的电脑开机，完全免费！
