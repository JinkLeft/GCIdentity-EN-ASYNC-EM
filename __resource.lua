resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/ui.html'

server_script '@mysql-async/lib/MySQL.lua'

client_script '@essentialmode/server/player/wrappers.lua'

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/carteV3_h.png',
	'html/carteV3_f.png',
	'html/cursor.png'
}

client_script {
	"client.lua"
}

server_script "server.lua"

export 'getIdentity'

