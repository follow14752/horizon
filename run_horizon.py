#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Horizon启动脚本 - 解决Windows编码问题"""

import sys
import os

# 设置UTF-8编码
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')
    os.environ['PYTHONIOENCODING'] = 'utf-8'

# 导入并运行主程序
if __name__ == '__main__':
    from src.main import main
    main()
