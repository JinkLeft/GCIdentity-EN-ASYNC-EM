--====================================================================================
-- #Author: Jonathan D & Charlie @ charli62128
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

--====================================================================================
--  Teste si un joueurs a donnée ces infomation identitaire
--====================================================================================

AddEventHandler('es:playerLoaded', function(source)
    print('identity playerLoaded')
    getIdentity(source)
    Wait(100)
    local identity = identity
    if identity == nil or identity.lastname == '' then
        TriggerClientEvent('gcIdentity:showRegisterIdentity', source)
    else
    print('identity setIdentity')
        TriggerClientEvent('gcIdentity:setIdentity', source, convertSQLData(identity))
    end
end)

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function hasIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll("SELECT lastname, firstname FROM users WHERE identifier = @identifier", { ['@identifier'] = identifier }, function (result)
        if result[1] then
            local user = result[1]
            return not (user['lastname'] == '' or user['firstname'] == '')
        end
    end)
end

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll("SELECT users.* , jobs.job_name AS jobs FROM users JOIN jobs WHERE users.job = jobs.job_id AND users.identifier = @identifier", { ['@identifier'] = identifier }, function (result)             

        if result[1] ~= nil then
            result[1]['id'] = source
            identity = result[1]
        else
            return nil
        end
    end)
end

function setIdentity(identifier, data)
    MySQL.Sync.execute("UPDATE users SET lastname = @lastname, firstname = @firstname, dateOfBirth = @dateOfBirth, sex = @sex, height = @height WHERE identifier = @identifier", {
        ['@lastname'] = data.lastname,
        ['@firstname'] = data.firstname,
        ['@dateOfBirth'] = data.dateOfBirth,
        ['@sex'] = data.sex,
        ['@height'] = data.height,
        ['@identifier'] = identifier
    })
    
end

function convertSQLData(data)
    return {
        lastname = data.lastname,
        firstname = data.firstname,
        sex = data.sex,
        dateOfBirth = tostring(data.dateOfBirth),
        jobs = data.jobs,
        height = data.height,
        id = data.id
    }
end

function openIdentity(source, data)
    if data ~= nil then 
        TriggerClientEvent('gcIdentity:showIdentity', source, convertSQLData(data))
    end
end

RegisterServerEvent('gcIdentity:openIdentity')
AddEventHandler('gcIdentity:openIdentity',function(other)
    local data = getIdentity(source)
    openIdentity(other, data)
end)

RegisterServerEvent('gcIdentity:openMeIdentity')
AddEventHandler('gcIdentity:openMeIdentity',function()
    local data = getIdentity(source)
    openIdentity(source, data)
end)


RegisterServerEvent('gcIdentity:setIdentity')
AddEventHandler('gcIdentity:setIdentity', function(data)
    setIdentity(GetPlayerIdentifiers(source)[1], data)
end)