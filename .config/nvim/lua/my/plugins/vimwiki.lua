vim.g.vimwiki_list = {
	{
		path = os.getenv('VIMWIKI'),
		path_html = os.getenv('XDG_DATA_HOME')..'/mywiki-html',
		diary_rel_path = 'personal/diary/',
		auto_diary_index = 1,
	},
}
