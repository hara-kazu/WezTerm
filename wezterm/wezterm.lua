local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- =========================================================
-- 基本設定
-- =========================================================
config.automatically_reload_config = true
config.disable_default_key_bindings = true

-- フォント設定
config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Source Han Sans HW',
})
config.font_size = 12.0

-- 行間（コードが読みやすくなる）
config.line_height = 1.1

-- カーソル設定
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500

config.use_ime = true
-- IMEの変換候補ウィンドウの描画をシステムに任せる（表示位置のズレ対策）
config.ime_preedit_rendering = "System"

-- Altキー入力の挙動調整（アプリ側でAltキーショートカットを認識させるため）
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- デフォルトのシェルをPowerShellに設定 (インストールされている場合 'pwsh'、なければ 'powershell.exe')
-- 必要なければコメントアウトしてください
config.default_prog = { 'powershell.exe', '-NoLogo', '-ExecutionPolicy', 'RemoteSigned' }

-- 履歴（スクロールバック）の行数を増やす
config.scrollback_lines = 10000

-- ベル音を無効化
config.audible_bell = "Disabled"

-- ランチメニュー（右クリックでシェル選択）
config.launch_menu = {
  { label = 'PowerShell', args = { 'powershell.exe', '-NoLogo', '-ExecutionPolicy', 'RemoteSigned' } },
  { label = 'Command Prompt', args = { 'cmd.exe' } },
  { label = 'WSL', args = { 'wsl.exe' } },
}

-- =========================================================
-- 外観設定 (Windows Terminal風 + 好みの透過設定)
-- =========================================================
-- 配色テーマ (Windows Terminalのデフォルトに近い 'Campbell' を指定、好みで変更可)
config.color_scheme = 'Campbell'

-- ウィンドウの透明度とブラー
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20 -- Windowsでは効かない場合がありますが残します

-- ウィンドウ枠の設定
config.window_decorations = "RESIZE"
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブバーを常に表示するか（falseだとタブが1つの時は隠れる）
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true

-- タブのデザインカスタマイズ（三角形の左右装飾付き）
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end

  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- =========================================================
-- キーバインディング (Windows Terminal準拠)
-- =========================================================
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

-- =========================================================
-- マウス設定
-- =========================================================
config.mouse_bindings = {
  -- 右クリックでペースト (Windows Terminal風)
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  -- Ctrl+クリックでリンクを開く
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
}

return config
