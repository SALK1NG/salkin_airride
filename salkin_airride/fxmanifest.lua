fx_version 'cerulean'
game 'gta5'


description 'Salkin Airride System'
author 'SALKIN.G'
version '1.0'

dependencies { 'oxmysql', 'ox_lib' }

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts { 'client.lua' }
server_scripts { 'server.lua' }