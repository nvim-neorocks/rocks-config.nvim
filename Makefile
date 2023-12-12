format:
	stylua -v --verify lua/rocks-config/ plugin/

check:
	luacheck lua/rocks-config plugin/
