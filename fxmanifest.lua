fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️#1400'
description 'vms_snowevents'
version '1.0.0'

shared_scripts {
    'config/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', 
    'config/config_server.lua',
    'server/*.lua',
}

client_scripts {
    'config/config_client.lua',
    'client/*.lua',
}

files {
    'stream/vms_gift.ytyp'
}
data_file 'DLC_ITYP_REQUEST' 'vms_gift.ytyp'
