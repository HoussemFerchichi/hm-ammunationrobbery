fx_version 'cerulean'
game 'gta5'

description 'Ammunation Robbery By @Houssem'
version '1.0.0'
author 'houssem'

shared_scripts {
    'config.lua'
}

server_script {
    'server.lua',
}
client_scripts {
    'client.lua'
}

lua54 'yes'server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }