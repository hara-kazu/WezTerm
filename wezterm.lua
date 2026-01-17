local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- =========================================================
-- 基本設定
-- =========================================================
config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true

-- デフォルトのシェルをPowerShellに設定 (インストールされている場合 'pwsh'、なければ 'powershell.exe')
-- 必要なければコメントアウトしてください
config.default_prog = { 'powershell.exe' }

-- 履歴（スクロールバック）の行数を増やす
config.scrollback_lines = 10000

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

-- タブバーを常に表示するか（falseだとタブが1つの時は隠れる）
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true

-- タブのデザインカスタマイズ（元の設定を維持・調整）
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end

  -- タイトルの表示内容
  local title = " " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. " "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

-- =========================================================
-- キーバインディング (Windows Terminal準拠)
-- =========================================================
config.keys = {

  -- 新しいタブ: Ctrl+T
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },

  -- ペイン分割: Ctrl+Alt+T (上下分割)
  { key = 't', mods = 'CTRL|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペインを閉じる: Ctrl+Shift+W
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },

  -- タブを閉じる: Ctrl+W
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },

  -- タブの移動: Ctrl+Tab / Ctrl+Shift+Tab
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },

  -- ペースト: Ctrl+V (Windows標準)
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  -- ペースト: Shift+Insert (一般的)
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },

  -- コピー: Ctrl+C
  -- 【重要】テキスト選択時はコピー、選択なし時は通常通り中断(SIGINT)を送る設定
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },

  -- フォントサイズ変更 (Ctrl + / - / 0)
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = ';', mods = 'CTRL', action = act.IncreaseFontSize }, -- 日本語キーボードの「+」の位置考慮
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },

  -- 検索モード: Ctrl+Shift+F
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
}

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
}

return config
