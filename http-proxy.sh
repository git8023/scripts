#!/bin/bash

RED='\e[31m'
NC='\e[0m' # No Color

log_e(){
  # 打印红色错误日志
  echo -e "[E] $RED$1$NC"
}

fn_show_proxy() {
  echo "--- 当前代理状态 ---"
  if [ -z "$http_proxy" ]; then
    echo "当前未设置任何代理"
  else
    echo "http_proxy: $http_proxy"
    echo "https_proxy: $https_proxy"
    # echo "NO_PROXY: $NO_PROXY"
  fi
  echo "----------------------"
}

fn_set_proxy() {
  # 临时循环，用于在设置界面内进行操作
  local loop=true
  while $loop; do
      clear
      echo "
--- 代理设置 ---
1. 查看当前配置
0. 返回主菜单
      "
      # 设置默认值，并让用户在提示中看到
      local def_url="http://192.168.1.106:1234"
      read -r -p "> 输入编号或代理地址(默认$def_url)：" opt

      # 如果用户输入为空，则使用默认值
      local input_value=${opt:-$def_url}

      case $input_value in
        1)
          clear
          fn_show_proxy
          sleep 1
          ;;

        0)
          # 返回主菜单
          loop=false
          ;;

        *)
          # 设置代理并退出循环
          local proxy_server=$input_value
          export http_proxy="$proxy_server"
          export https_proxy="$proxy_server"
          export HTTP_PROXY="$proxy_server"
          export HTTPS_PROXY="$proxy_server"
          
          clear
          echo "✅ 代理设置成功！"
          fn_show_proxy
          sleep 1.5
          loop=false
          ;;
      esac
  done
  # 退出 fn_set_proxy 后，回到主菜单
  fn_main
}

fn_unset_proxy() {
  echo "正在取消代理..."
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset NO_PROXY
  unset no_proxy

  clear
  if [ -z "$http_proxy" ]; then
    echo "✅ 所有代理已成功取消"
  else
    log_e "⚠️ 取消代理失败，请手动检查!"
  fi
  sleep 1
  fn_main
}


fn_main() {
  echo "
========================
http代理脚本 - v0.1
  - 使用方法
    source ./http_proxy.sh
    . ./http_proxy.sh
  - 注意
    代理设置仅当前会话有效
------------------------
1. 设置代理
2. 取消代理
3. 查看代理

0. 退出
========================
"
  read -r -p "> 输入编号:" opt

  # 由于使用了 source 运行脚本，用 return 退出函数即可
  case $opt in
    1)
      fn_set_proxy
      ;;

    2)
      fn_unset_proxy
      ;;

    3)
      clear 
      fn_show_proxy
      sleep 1.5
      fn_main
      ;;

    0)
      echo "Bye!"
      # 退出 fn_main 函数 (使用 source 脚本的正确退出方式)
      return 0
      ;;

    *)
      clear
      log_e "⚠️ 选项'$opt'无效!"
      sleep 1
      fn_main
      ;;
  esac
}

# 脚本启动时，调用主函数
fn_main
