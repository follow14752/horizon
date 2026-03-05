#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试配置文件是否正确"""

import sys
import os
import json
from pathlib import Path

# 设置UTF-8编码
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')
    os.environ['PYTHONIOENCODING'] = 'utf-8'

def test_config():
    """测试配置文件"""
    print("=" * 50)
    print("配置文件测试")
    print("=" * 50)

    # 测试.env文件
    env_file = Path(".env")
    if env_file.exists():
        print("✅ .env 文件存在")
        with open(env_file, 'r', encoding='utf-8') as f:
            env_content = f.read()
            print("📄 .env 内容:")
            for line in env_content.split('\n'):
                if line.strip() and not line.startswith('#'):
                    # 隐藏敏感信息
                    if '=' in line:
                        key, value = line.split('=', 1)
                        if len(value) > 10:
                            value = value[:4] + '***' + value[-4:]
                        print(f"   {key}={value}")
    else:
        print("❌ .env 文件不存在")

    print()

    # 测试config.json文件
    config_file = Path("data/config.json")
    if config_file.exists():
        print("✅ config.json 文件存在")
        with open(config_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
            print("📄 config.json 配置:")
            print(f"   版本: {config.get('version')}")
            print(f"   AI提供商: {config['ai']['provider']}")
            print(f"   AI模型: {config['ai']['model']}")
            print(f"   API密钥环境变量: {config['ai']['api_key_env']}")
            if 'base_url' in config['ai']:
                print(f"   API地址: {config['ai']['base_url']}")
            print(f"   信息源数量:")
            print(f"     - GitHub: {len(config['sources'].get('github', []))}")
            print(f"     - RSS: {len(config['sources'].get('rss', []))}")
            print(f"     - Reddit: {len(config['sources'].get('reddit', {}).get('subreddits', []))}")
            print(f"   过滤阈值: {config['filtering']['ai_score_threshold']}")
            print(f"   时间窗口: {config['filtering']['time_window_hours']} 小时")
    else:
        print("❌ config.json 文件不存在")

    print()
    print("=" * 50)
    print("配置测试完成!")
    print("=" * 50)

if __name__ == '__main__':
    test_config()
