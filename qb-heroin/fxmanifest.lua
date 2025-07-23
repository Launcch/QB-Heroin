fx_version 'cerulean'
game 'gta5'

description 'QBCore Heroin Script'
author 'Launch'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',  -- include localization files here
    'locales/fr.lua',  -- include French localization as well
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'qb-core',
    -- uncomment these if you actually use them in your scripts:
    -- 'qb-target',
    -- 'qb-menu',
    -- 'qb-input',
}
