local wezterm = require 'wezterm'
local act = wezterm.action

-- For better modifier key encoding support (CSI u), consider adding this to your wezterm.lua:
--   config.enable_csi_u_key_encoding = true
-- We'll send both Alt-modified keys and an ESC-prefixed sequence where possible for compatibility.
local M = {}

M.keys = {
  -- 新しいタブ: Ctrl+T
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },

  -- ペイン分割: Ctrl+Alt+T (上下分割)
  { key = 't', mods = 'CTRL|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- ペイン分割: Ctrl+Alt+H (左右分割)
  { key = 'h', mods = 'CTRL|ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- ペインを閉じる: Ctrl+Shift+W
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },

  -- タブを閉じる: Ctrl+W
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab { confirm = true } },

  -- タブの移動: Ctrl+Tab / Ctrl+Shift+Tab
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },





  -- Shift+Enter で改行を送信 (Claude Code等での複数行入力用)
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\n' },

  -- ペースト: Ctrl+V (Windows標準)
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  -- ペースト: Shift+Insert (一般的)
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },

  -- コピー: Ctrl+C（選択があるときだけコピー、なければSIGINT）
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
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

-- キーテーブルを使用しない場合は空テーブルで返す
M.key_tables = {}

return M
