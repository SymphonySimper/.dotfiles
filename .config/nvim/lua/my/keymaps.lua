local k = vim.api.nvim_set_keymap
local o = { noremap = true, silent = true }

local e = "<CR>"
local s = "<Space>"
local l = "<Left>"
local r = "<Right>"

local leader = " "
k("", leader, "<Nop>", o)
vim.g.mapleader = leader
vim.g.maplocalleader = leader

local normal_map = {
	{ e, ":noh" .. e .. e },
	{ "<C-h>", "<C-w>h" },
	{ "<C-j>", "<C-w>j" },
	{ "<C-k>", "<C-w>k" },
	{ "<C-l>", "<C-w>l" },
	{ "H", "gT" },
	{ "L", "gT" },
	{ "th", ":tabfirst" .. e },
	{ "tk", ":tabnext" .. e },
	{ "tj", ":tabprev" .. e },
	{ "tl", ":tablast" .. e },
	{ "tt", ":tabedit" .. s },
	{ "tm", ":tabm" .. s },
	{ "td", ":tabclose" .. e },
	{ "<C-g>", ":lua _LAZYGIT_TOGGLE()" .. e },
}

local tel = ":Telescope"

local leader_map = {
	{ "R", ":%s//g" .. l .. l },
	{ "r", ":s//g" .. l .. l },
	{ "u", [[:s/\<./\u&/g<bar>:noh]] .. e },
	{ "d", ":da" },
	{ "c", ":silent !groff-ms -f %" .. e },
	{ "e", ":NvimTreeToggle" .. e },
	{ "f", ":lua vim.lsp.buf.formatting()" .. e },
	{ "p", tel .. " find_files" .. e },
	{ "s", tel .. " current_buffer_fuzzy_find" .. e },
	{ "S", tel .. " live_grep" .. e },
	{ "m", tel .. " diagnostics" .. e },
}

local le = "<leader>"
for _, v in pairs(leader_map) do
	table.insert(normal_map, { le .. v[1], v[2] })
end

local function Ins(str)
	local present = false
	for _, v in pairs({ l, s, r }) do
		if string.match(str, v) ~= nil then
			present = true
			break
		end
	end
	return present
end

for _, v in pairs(normal_map) do
	if Ins(v[2]) then
		k("n", v[1], v[2], { noremap = true })
	else
		k("n", v[1], v[2], o)
	end
end
