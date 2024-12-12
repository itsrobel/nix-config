{config, pkgs, ...}: {
	# home.packages = with pkgs; [
	# 	ripgrep
	# 	fd
	# 	git
	# 	nodejs
	# 	lazygit
	# 	gcc
	# 	unzip
	# ];
	programs.neovim = {
	enable = true;
	defaultEditor = true;
	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;
	extraLuaConfig = builtins.readFile ./nvim/options.lua;
	plugins = with pkgs; [
		vimPlugins.nvim-lspconfig
		vimPlugins.comment-nvim
		vimPlugins.gruvbox-nvim
		vimPlugins.neodev-nvim
		vimPlugins.telescope-nvim
		vimPlugins.telescope-fzf-native-nvim
		vimPlugins.cmp_luasnip
		# vimPlugins
	];

	};
}
