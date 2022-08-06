fx_version 'cerulean'
game 'gta5'

author 'Mercy Collective (https://dsc.gg/mercy-coll)'
description 'Storages'

ui_page 'nui/index.html'

shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    "client/cl_*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/sv_*.lua"
}

files {
	'nui/index.html',
    'nui/css/*.css',
    'nui/js/**.js',
}
