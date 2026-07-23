#!/usr/bin/env python3
import sys
import openrazer.client

def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("set", "get"):
        print(f"用法:")
        print(f"  {sys.argv[0]} get           查看当前 DPI")
        print(f"  {sys.argv[0]} set <DPI值>    设置 DPI，例如: {sys.argv[0]} set 800")
        sys.exit(1)

    # 连接 OpenRazer 守护进程
    devman = openrazer.client.DeviceManager()
    mice = [d for d in devman.devices if d.type == "mouse"]

    if not mice:
        print("没找到雷蛇鼠标，请确认：")
        print("  - openrazer-daemon 已启动")
        print("  - 鼠标已插入")
        sys.exit(1)

    if sys.argv[1] == "get":
        for mouse in mice:
            if hasattr(mouse, "dpi"):
                dpi = mouse.dpi
                if isinstance(dpi, (list, tuple)) and len(dpi) == 2:
                    if dpi[0] == dpi[1]:
                        print(f"{mouse.name}: 当前 DPI 为 {dpi[0]}")
                    else:
                        print(f"{mouse.name}: 当前 DPI 为 X={dpi[0]}, Y={dpi[1]}")
                else:
                    print(f"{mouse.name}: 当前 DPI 为 {dpi}")
            else:
                print(f"{mouse.name}: 不支持 dpi 属性，跳过")

    elif sys.argv[1] == "set":
        if len(sys.argv) != 3:
            print(f"用法: {sys.argv[0]} set <DPI值，例如 800>")
            sys.exit(1)

        try:
            dpi = int(sys.argv[2])
        except ValueError:
            print(f"错误: DPI 必须是整数，收到 '{sys.argv[2]}'")
            sys.exit(1)

        for mouse in mice:
            if hasattr(mouse, "dpi"):
                mouse.dpi = [dpi, dpi]
                print(f"{mouse.name}: DPI 已设为 {dpi}")
            else:
                print(f"{mouse.name}: 不支持 dpi 属性，跳过")

if __name__ == "__main__":
    main()

