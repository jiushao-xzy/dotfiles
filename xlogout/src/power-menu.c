#include <gtk/gtk.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

// 电源操作定义
typedef struct {
    const char *label;     // 按钮ID (用于CSS)
    const char *icon;      // 图标名称
    const char *command;   // 执行的命令
    const char *text;      // 显示文本
} PowerAction;

static const PowerAction actions[] = {
    {"shutdown", "system-shutdown", "systemctl poweroff", "关机"},
    {"reboot", "system-reboot", "systemctl reboot", "重启"},
    {"suspend", "media-playback-pause-symbolic", "systemctl suspend", "挂起"},
    {"logout", "system-log-out", "uwsm stop", "登出"},
    {"lock", "system-lock-screen", "hyprlock", "锁定"},
    {"cancel", "window-close", "", "取消"}
};

// 执行命令并退出
static void execute_command(const char *command) {
    if (command && *command) {
        pid_t pid = fork();
        if (pid == 0) {
            // 在子进程中执行命令
            execl("/bin/sh", "sh", "-c", command, NULL);
            _exit(EXIT_FAILURE); // execl失败时退出
        } else if (pid > 0) {
            // 父进程等待子进程完成
            int status;
            waitpid(pid, &status, 0);
        }
    }
    gtk_main_quit();
}

// 按钮点击处理
static void button_clicked(GtkWidget *widget, gpointer data) {
    const int index = GPOINTER_TO_INT(data);
    execute_command(actions[index].command);
}

// 键盘事件处理
static gboolean key_press_event(GtkWidget *widget, GdkEventKey *event, gpointer data) {
    GtkGrid *grid = GTK_GRID(data);
    GtkWidget *focus = gtk_window_get_focus(GTK_WINDOW(widget));
    
    if (!focus) return FALSE;
    
    int index = GPOINTER_TO_INT(g_object_get_data(G_OBJECT(focus), "index"));
    int row = index / 3;
    int col = index % 3;
    
    // 处理键盘导航
    switch (event->keyval) {
        // Vim键位
        case GDK_KEY_h: case GDK_KEY_H: col = (col - 1 + 3) % 3; break;
        case GDK_KEY_j: case GDK_KEY_J: row = (row + 1) % 2; break;
        case GDK_KEY_k: case GDK_KEY_K: row = (row - 1 + 2) % 2; break;
        case GDK_KEY_l: case GDK_KEY_L: col = (col + 1) % 3; break;
        
        // 方向键
        case GDK_KEY_Left:  col = (col - 1 + 3) % 3; break;
        case GDK_KEY_Down:  row = (row + 1) % 2; break;
        case GDK_KEY_Up:    row = (row - 1 + 2) % 2; break;
        case GDK_KEY_Right: col = (col + 1) % 3; break;
        
        // 激活按钮
        case GDK_KEY_Return: case GDK_KEY_space:
            gtk_button_clicked(GTK_BUTTON(focus));
            return TRUE;
            
        // 退出
        case GDK_KEY_Escape:
            gtk_main_quit();
            return TRUE;
            
        default: return FALSE;
    }
    
    // 计算新位置并聚焦
    int new_index = row * 3 + col;
    GtkWidget *new_focus = gtk_grid_get_child_at(grid, col, row);
    if (new_focus) gtk_widget_grab_focus(new_focus);
    
    return TRUE;
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);
    
    // 创建主窗口
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "电源菜单");
    gtk_window_set_default_size(GTK_WINDOW(window), 500, 300);
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
    gtk_window_set_resizable(GTK_WINDOW(window), FALSE);
    
    // 创建网格布局 (2行 x 3列)
    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 15);
    gtk_grid_set_column_spacing(GTK_GRID(grid), 15);
    gtk_grid_set_row_homogeneous(GTK_GRID(grid), TRUE);
    gtk_grid_set_column_homogeneous(GTK_GRID(grid), TRUE);
    gtk_container_add(GTK_CONTAINER(window), grid);
    
    // 创建按钮并添加到网格
    for (int i = 0; i < 6; i++) {
        GtkWidget *button = gtk_button_new();
        gtk_widget_set_name(button, actions[i].label); // 设置CSS ID
        
        GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8);
        GtkWidget *icon = gtk_image_new_from_icon_name(actions[i].icon, GTK_ICON_SIZE_DIALOG);
        GtkWidget *label = gtk_label_new(actions[i].text);
        
        gtk_box_pack_start(GTK_BOX(box), icon, TRUE, TRUE, 0);
        gtk_box_pack_start(GTK_BOX(box), label, TRUE, TRUE, 0);
        gtk_container_add(GTK_CONTAINER(button), box);
        
        g_object_set_data(G_OBJECT(button), "index", GINT_TO_POINTER(i));
        g_signal_connect(button, "clicked", G_CALLBACK(button_clicked), GINT_TO_POINTER(i));
        
        gtk_grid_attach(GTK_GRID(grid), button, i % 3, i / 3, 1, 1);
    }
    
    // 连接信号
    g_signal_connect(window, "key-press-event", G_CALLBACK(key_press_event), grid);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
    
    // 设置初始焦点
    GtkWidget *first_button = gtk_grid_get_child_at(GTK_GRID(grid), 0, 0);
    if (first_button) gtk_widget_grab_focus(first_button);
    
    // 应用CSS样式
    GtkCssProvider *provider = gtk_css_provider_new();
    const char *css = 
        "button {"
        "   border-radius: 12px;"
        "   padding: 15px;"
        "   background: rgba(60, 60, 60, 0.2);"
        "   transition: all 0.2s ease;"
        "}"
        "button:hover {"
        "   background: rgba(100, 100, 100, 0.3);"
        "   transform: scale(1.05);"
        "}"
        "button:active {"
        "   background: rgba(120, 120, 120, 0.4);"
        "}"
        "button#shutdown {"
        "   background: rgba(220, 80, 80, 0.2);"
        "}"
        "button#reboot {"
        "   background: rgba(80, 160, 220, 0.2);"
        "}"
        "button#suspend {"
        "   background: rgba(160, 120, 220, 0.2);"
        "}"
        "button#logout {"
        "   background: rgba(220, 160, 80, 0.2);"
        "}"
        "button#lock {"
        "   background: rgba(80, 200, 120, 0.2);"  // 锁定按钮使用绿色调
        "}"
        "button#cancel {"
        "   background: rgba(150, 150, 150, 0.2);"
        "}"
        "label {"
        "   font-size: 14px;"
        "   margin-top: 8px;"
        "}";
    
    gtk_css_provider_load_from_data(provider, css, -1, NULL);
    gtk_style_context_add_provider_for_screen(
        gdk_screen_get_default(),
        GTK_STYLE_PROVIDER(provider),
        GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
    );
    
    // 显示窗口
    gtk_widget_show_all(window);
    gtk_main();
    
    return EXIT_SUCCESS;
}
