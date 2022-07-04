fx_version 'cerulean'
game 'gta5'

description 'QB-GruppeJob'
version '1.2.1'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'config.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/main.lua'
}

server_script 'server/main.lua'

lua54 'yes'