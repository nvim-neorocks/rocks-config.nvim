format:
	stylua -v --verify lua/rocks-config/

check:
	luacheck lua/rocks-config
