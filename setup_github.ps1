# Horizon GitHub 自动化配置脚本
# 用于快速初始化 Git 并推送到 GitHub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Horizon GitHub 自动化配置脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在正确的目录
$currentDir = Get-Location
$expectedDir = "D:\horizon\Horizon"

if ($currentDir.Path -ne $expectedDir) {
    Write-Host "⚠️  当前目录: $currentDir" -ForegroundColor Yellow
    Write-Host "⚠️  期望目录: $expectedDir" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "是否切换到正确目录？(Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        Set-Location $expectedDir
        Write-Host "✅ 已切换到: $expectedDir" -ForegroundColor Green
    } else {
        Write-Host "❌ 请先切换到正确的目录后再运行此脚本" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# 输入 GitHub 仓库信息
Write-Host "📝 请输入你的 GitHub 信息：" -ForegroundColor Cyan
Write-Host ""

$githubUsername = Read-Host "GitHub 用户名"
$repoName = Read-Host "仓库名称 (默认: horizon)"

if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "horizon"
}

$repoUrl = "https://github.com/$githubUsername/$repoName.git"

Write-Host ""
Write-Host "📦 仓库信息：" -ForegroundColor Cyan
Write-Host "   用户名: $githubUsername" -ForegroundColor White
Write-Host "   仓库名: $repoName" -ForegroundColor White
Write-Host "   仓库地址: $repoUrl" -ForegroundColor White
Write-Host ""

$response = Read-Host "确认信息正确？(Y/N)"
if ($response -ne "Y" -and $response -ne "y") {
    Write-Host "❌ 配置已取消" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 开始配置..." -ForegroundColor Cyan
Write-Host ""

# 检查 Git 是否已安装
try {
    $gitVersion = git --version
    Write-Host "✅ Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git 未安装，请先安装 Git" -ForegroundColor Red
    Write-Host "   下载地址: https://git-scm.com/downloads" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 检查是否已经是 Git 仓库
if (Test-Path ".git") {
    Write-Host "⚠️  当前目录已经是 Git 仓库" -ForegroundColor Yellow
    $response = Read-Host "是否重新初始化？(Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        Remove-Item -Recurse -Force ".git"
        Write-Host "✅ 已删除旧的 Git 仓库" -ForegroundColor Green
    } else {
        Write-Host "⏭️  跳过初始化步骤" -ForegroundColor Yellow
    }
}

# 初始化 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "📝 初始化 Git 仓库..." -ForegroundColor Cyan
    git init
    Write-Host "✅ Git 仓库初始化完成" -ForegroundColor Green
}

Write-Host ""

# 添加所有文件
Write-Host "📝 添加文件到 Git..." -ForegroundColor Cyan
git add .

# 检查是否有文件被添加
$status = git status --short
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "⚠️  没有文件需要提交" -ForegroundColor Yellow
} else {
    Write-Host "✅ 文件已添加" -ForegroundColor Green
}

Write-Host ""

# 提交更改
Write-Host "📝 提交更改..." -ForegroundColor Cyan
git commit -m "Initial commit: Horizon project setup with Spark AI"
Write-Host "✅ 更改已提交" -ForegroundColor Green

Write-Host ""

# 设置主分支
Write-Host "📝 设置主分支..." -ForegroundColor Cyan
git branch -M main
Write-Host "✅ 主分支设置为 main" -ForegroundColor Green

Write-Host ""

# 添加远程仓库
Write-Host "📝 连接到 GitHub 仓库..." -ForegroundColor Cyan
git remote add origin $repoUrl
Write-Host "✅ 已连接到: $repoUrl" -ForegroundColor Green

Write-Host ""

# 推送到 GitHub
Write-Host "📝 推送到 GitHub..." -ForegroundColor Cyan
Write-Host "⚠️  可能需要输入 GitHub 用户名和 Token" -ForegroundColor Yellow
Write-Host "   用户名: 你的 GitHub 用户名" -ForegroundColor Yellow
Write-Host "   密码: 你的 GitHub Token (ghp_xxx 格式)" -ForegroundColor Yellow
Write-Host ""

try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ 推送成功！" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "❌ 推送失败" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 可能的原因：" -ForegroundColor Yellow
    Write-Host "   1. 仓库不存在：请先在 GitHub 上创建仓库" -ForegroundColor White
    Write-Host "   2. 认证失败：请检查用户名和 Token 是否正确" -ForegroundColor White
    Write-Host "   3. 网络问题：请检查网络连接" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 手动推送命令：" -ForegroundColor Cyan
    Write-Host "   git push -u origin main" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ 配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 下一步操作：" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 访问你的 GitHub 仓库：" -ForegroundColor White
Write-Host "   $repoUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. 配置 GitHub Secrets：" -ForegroundColor White
Write-Host "   Settings → Secrets and variables → Actions" -ForegroundColor Yellow
Write-Host "   添加以下 Secrets：" -ForegroundColor Yellow
Write-Host "   - SPARK_API_PASSWORD (你的星火 API 密钥)" -ForegroundColor White
Write-Host "   - GITHUB_TOKEN (你的 GitHub Token)" -ForegroundColor White
Write-Host ""
Write-Host "3. 启用 GitHub Actions：" -ForegroundColor White
Write-Host "   点击 Actions 标签 → 启用工作流" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. 手动触发运行（测试）：" -ForegroundColor White
Write-Host "   Actions → Daily Horizon Summary → Run workflow" -ForegroundColor Yellow
Write-Host ""
Write-Host "📚 详细配置指南请查看：" -ForegroundColor Cyan
Write-Host "   GitHub自动化配置指南.md" -ForegroundColor White
Write-Host ""
Write-Host "🎉 祝配置顺利！" -ForegroundColor Green
Write-Host ""
