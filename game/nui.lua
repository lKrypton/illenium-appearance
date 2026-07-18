local client = client
local spotlightActive = false
local spotlightThreadRunning = false
local spotlightConfig = nil

RegisterNUICallback("appearance_get_locales", function(_, cb)
    local lang = GetConvar("illenium-appearance:locale", "en")
    if not Locales[lang] then
        lang = "en"
    end
    cb(Locales[lang])
end)

RegisterNUICallback("appearance_get_settings", function(_, cb)
    cb({ appearanceSettings = client.getAppearanceSettings() })
end)

RegisterNUICallback("appearance_get_data", function(_, cb)
    Wait(250)
    local appearanceData = client.getAppearance()
    if not appearanceData or not appearanceData.model or appearanceData.model == "" then
        print("[illenium-appearance] appearance_get_data: Missing model, reading current ped")
        appearanceData = client.getPedAppearance(cache.ped)
        if not appearanceData.model or appearanceData.model == "" then
            appearanceData.model = "mp_m_freemode_01"
        end
    end
    if appearanceData.tattoos then
        client.setPedTattoos(cache.ped, appearanceData.tattoos)
    end
    local sessionConfig = client.getConfig() or {}
    -- Inject UI config (themes, tabs, sections) for the web frontend.
    -- Doing it here keeps the config single-source-of-truth in shared/config.lua.
    sessionConfig.uiConfig = {
        themes   = Config.UI and Config.UI.Themes   or nil,
        tabs     = Config.UI and Config.UI.Tabs     or nil,
        sections = Config.UI and Config.UI.Sections or nil,
    }
    cb({ config = sessionConfig, appearanceData = appearanceData })
end)

RegisterNUICallback("appearance_set_camera", function(camera, cb)
    cb(1)
    client.cancelOrbit()   -- reset orbit state + isCameraInterpolating without switching cam
    client.setCamera(camera)
end)

RegisterNUICallback("appearance_start_orbit", function(data, cb)
    cb(1)
    if client.startOrbitCamera then client.startOrbitCamera(data) end
end)

RegisterNUICallback("appearance_update_orbit", function(data, cb)
    cb(1)
    if client.updateOrbitData then client.updateOrbitData(data) end
end)

RegisterNUICallback("appearance_exit_orbit", function(_, cb)
    cb(1)
    client.exitOrbitCamera()
end)

RegisterNUICallback("appearance_turn_around", function(_, cb)
    cb(1)
    client.pedTurn(cache.ped, 180.0)
end)

RegisterNUICallback("appearance_rotate_camera", function(direction, cb)
    cb(1)
    client.cancelOrbit()   -- exit orbit and clear isCameraInterpolating so rotate always fires
    client.rotateCamera(direction)
end)

RegisterNUICallback("appearance_change_model", function(model, cb)
    local playerPed = client.setPlayerModel(model)

    local verifyAttempts = 0
    while (not DoesEntityExist(cache.ped) or GetEntityModel(cache.ped) == 0) and verifyAttempts < 10 do
        Wait(100)
        verifyAttempts = verifyAttempts + 1
    end

    playerPed = cache.ped -- Update reference after model change

    -- Apply initial clothes if switching to a freemode ped
    local modelHash = GetEntityModel(playerPed)
    local initialClothes = nil
    if modelHash == `mp_m_freemode_01` then
        initialClothes = Config.InitialPlayerClothes.Male
    elseif modelHash == `mp_f_freemode_01` then
        initialClothes = Config.InitialPlayerClothes.Female
    end

    if initialClothes then
        for _, component in ipairs(initialClothes.Components) do
            SetPedComponentVariation(playerPed, component.component_id, component.drawable, component.texture, 0)
        end
        for _, prop in ipairs(initialClothes.Props) do
            if prop.drawable == -1 then
                ClearPedProp(playerPed, prop.prop_id)
            else
                SetPedPropIndex(playerPed, prop.prop_id, prop.drawable, prop.texture, true)
            end
        end
    end

    SetEntityHeading(playerPed, client.getHeading())
    SetEntityInvincible(playerPed, true)
    TaskStandStill(playerPed, -1)

    cb({
        appearanceSettings = client.getAppearanceSettings(),
        appearanceData = client.getPedAppearance(playerPed)
    })
end)

RegisterNUICallback("appearance_change_component", function(component, cb)
    client.setPedComponent(cache.ped, component)
    cb(client.getComponentSettings(cache.ped, component.component_id))
end)

RegisterNUICallback("appearance_change_prop", function(prop, cb)
    client.setPedProp(cache.ped, prop)
    cb(client.getPropSettings(cache.ped, prop.prop_id))
end)

RegisterNUICallback("appearance_change_head_blend", function(headBlend, cb)
    cb(1)
    client.setPedHeadBlend(cache.ped, headBlend)
end)

RegisterNUICallback("appearance_change_face_feature", function(faceFeatures, cb)
    cb(1)
    client.setPedFaceFeatures(cache.ped, faceFeatures)
end)

RegisterNUICallback("appearance_change_head_overlay", function(headOverlays, cb)
    cb(1)
    client.setPedHeadOverlays(cache.ped, headOverlays)
end)

RegisterNUICallback("appearance_change_hair", function(hair, cb)
    client.setPedHair(cache.ped, hair)
    cb(client.getHairSettings(cache.ped))
end)

RegisterNUICallback("appearance_change_fade", function(data, cb)
    cb(1)
    client.setPedTattoos(cache.ped, data)
end)

RegisterNUICallback("appearance_change_eye_color", function(eyeColor, cb)
    cb(1)
    client.setPedEyeColor(cache.ped, eyeColor)
end)

RegisterNUICallback("appearance_apply_tattoo", function(data, cb)
    local paid = not data.tattoo or not Config.ChargePerTattoo or lib.callback.await("illenium-appearance:server:payForTattoo", false, data.tattoo)
    if paid then
        client.addPedTattoo(cache.ped, data.updatedTattoos or data)
    end
    cb(paid)
end)

RegisterNUICallback("appearance_preview_tattoo", function(previewTattoo, cb)
    cb(1)
    client.setPreviewTattoo(cache.ped, previewTattoo.data, previewTattoo.tattoo)
end)

RegisterNUICallback("appearance_delete_tattoo", function(data, cb)
    cb(1)
    client.removePedTattoo(cache.ped, data)
end)

RegisterNUICallback("appearance_wear_clothes", function(dataWearClothes, cb)
    cb(1)
    client.wearClothes(dataWearClothes.data, dataWearClothes.key)
end)

RegisterNUICallback("appearance_remove_clothes", function(clothes, cb)
    cb(1)
    client.removeClothes(clothes)
end)

RegisterNUICallback("appearance_save", function(appearance, cb)
    cb(1)
    spotlightActive = false
    ClearPedTasks(cache.ped)
    if type(appearance) ~= "table" or not appearance.model or appearance.model == "" then
        print("[illenium-appearance] NUI sent invalid appearance data, getting current ped appearance")
        appearance = client.getPedAppearance(cache.ped)
        if not appearance.model or appearance.model == "" then
            appearance.model = "mp_m_freemode_01"
        end
    end
    if not appearance.components or #appearance.components == 0 then
        appearance.components = client.getPedComponents(cache.ped)
    end
    if not appearance.props or #appearance.props == 0 then
        appearance.props = client.getPedProps(cache.ped)
    end
    client.wearClothes(appearance, "head")
    client.wearClothes(appearance, "body")
    client.wearClothes(appearance, "bottom")
    client.exitPlayerCustomization(appearance)
end)

RegisterNUICallback("appearance_exit", function(_, cb)
    cb(1)
    spotlightActive = false
    ClearPedTasks(cache.ped)
    client.exitPlayerCustomization()
end)

RegisterNUICallback("rotate_left", function(_, cb)
    cb(1)
    client.pedTurn(cache.ped, 10.0)
end)

RegisterNUICallback("rotate_right", function(_, cb)
    cb(1)
    client.pedTurn(cache.ped, -10.0)
end)

RegisterNUICallback("get_theme_configuration", function(_, cb)
    cb(Config.Theme)
end)

RegisterNUICallback("appearance_close_interaction", function(_, cb)
    cb(1)
    if GetResourceState("ox_target") == "started" then
        exports["ox_target"]:disableTargeting(true)
    end
end)

RegisterNUICallback("appearance_toggle_light", function(data, cb)
    cb(1)
    spotlightActive = data.state and true or false
    spotlightConfig = data

    if spotlightActive and not spotlightThreadRunning then
        spotlightThreadRunning = true
        Citizen.CreateThread(function()
            while spotlightActive do
                local ped = cache.ped or PlayerPedId()
                if ped and ped ~= 0 then
                    local cfg = spotlightConfig or {}
                    local r = math.floor(cfg.r or 255)
                    local g = math.floor(cfg.g or 255)
                    local b = math.floor(cfg.b or 255)
                    local intensity = (cfg.intensity or 10.0) + 0.0
                    local distance  = (cfg.distance or 2.5) + 0.0
                    local height    = (cfg.height or 1.0) + 0.0
                    local angleRad  = math.rad((cfg.angle or 0.0) + 0.0)

                    -- Aim at ped's chest, not feet
                    local pedCoords = GetEntityCoords(ped)
                    local targetPos = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.6)

                    local forward = GetEntityForwardVector(ped)
                    -- Rotate forward by angle on Z axis to orbit the light around the ped
                    local cosA = math.cos(angleRad)
                    local sinA = math.sin(angleRad)
                    local rotX = forward.x * cosA - forward.y * sinA
                    local rotY = forward.x * sinA + forward.y * cosA
                    local dirVec = vector3(rotX, rotY, 0.0)

                    local lightPos = targetPos + (dirVec * distance) + vector3(0.0, 0.0, height)

                    -- Light direction = from lightPos toward ped chest
                    local toPed = targetPos - lightPos
                    local len = #(toPed) + 0.0001
                    local nx, ny, nz = toPed.x / len, toPed.y / len, toPed.z / len

                    -- DrawSpotLight(x, y, z, dx, dy, dz, r, g, b, range, brightness, hardness, radius, falloff)
                    DrawSpotLight(lightPos.x, lightPos.y, lightPos.z, nx, ny, nz, r, g, b, distance + 6.0, intensity, 1.0, 35.0, 10.0)
                    DrawSpotLightWithShadow(lightPos.x, lightPos.y, lightPos.z, nx, ny, nz, r, g, b, distance + 6.0, intensity, 1.0, 35.0, 10.0, 0)
                    -- Soft fill light around the ped
                    DrawLightWithRange(targetPos.x, targetPos.y, targetPos.z, r, g, b, 3.0, math.max(1.0, intensity * 0.3))
                end
                Citizen.Wait(0)
            end
            spotlightThreadRunning = false
        end)
    end
end)

RegisterNUICallback("appearance_update_light", function(data, cb)
    cb(1)
    spotlightConfig = data
end)

RegisterNUICallback("appearance_play_animation", function(data, cb)
    cb(1)
    Citizen.CreateThread(function()
        local ped = cache.ped or PlayerPedId()
        if data.dict == "reset" then
            StopAnimTask(ped, "random@mugging3", "handsup_standing_base", 3.5)
            return
        end

        StopAnimTask(ped, "random@mugging3", "handsup_standing_base", 3.5)
        RequestAnimDict(data.dict)
        local timeout = 0
        while not HasAnimDictLoaded(data.dict) and timeout < 50 do
            Wait(10)
            timeout = timeout + 1
        end
        if not HasAnimDictLoaded(data.dict) then return end
        TaskPlayAnim(ped, data.dict, data.name, 3.5, -3.5, -1, 49, 0, false, false, false)
    end)
end)

-- ══════════════════════════════════════
-- WARDROBE / OUTFIT NUI CALLBACKS
-- ══════════════════════════════════════
RegisterNUICallback("appearance_get_outfits", function(_, cb)
    local outfits = lib.callback.await("illenium-appearance:server:getOutfits", false) or {}
    cb(outfits)
end)

RegisterNUICallback("appearance_save_outfit", function(data, cb)
    local outfitName = data and data.name
    if not outfitName or outfitName == "" then
        cb({ success = false, reason = "invalid_name" })
        return
    end

    -- Check if player has enough money (uses Config.ClothingCost)
    local hasMoney, price = lib.callback.await("illenium-appearance:server:hasMoney", false, "clothing")
    if not hasMoney then
        lib.notify({
            title = _L("purchase.store.failure.title") or "Yetersiz Bakiye",
            description = string.format("Kıyafet kaydetmek için $%d gerekiyor.", price or 0),
            type = "error",
            position = Config.NotifyOptions.position
        })
        cb({ success = false, reason = "no_money" })
        return
    end

    local outfits = lib.callback.await("illenium-appearance:server:getOutfits", false) or {}
    for i = 1, #outfits do
        if outfits[i].name and outfits[i].name:lower() == outfitName:lower() then
            cb({ success = false, reason = "exists" })
            return
        end
    end

    -- Charge the player
    TriggerServerEvent("illenium-appearance:server:chargeCustomer", "clothing")

    local pedModel      = client.getPedModel(cache.ped)
    local pedComponents = client.getPedComponents(cache.ped)
    local pedProps      = client.getPedProps(cache.ped)

    TriggerServerEvent("illenium-appearance:server:saveOutfit", outfitName, pedModel, pedComponents, pedProps)

    -- Wait briefly for the save to round-trip then return updated list
    Wait(250)
    local updated = lib.callback.await("illenium-appearance:server:getOutfits", false) or {}
    cb({ success = true, outfits = updated })
end)

RegisterNUICallback("appearance_wear_outfit", function(data, cb)
    cb(1)
    if not data or not data.id then return end
    local outfits = lib.callback.await("illenium-appearance:server:getOutfits", false) or {}
    for i = 1, #outfits do
        if outfits[i].id == data.id then
            TriggerEvent("illenium-appearance:client:changeOutfit", outfits[i])
            return
        end
    end
end)

RegisterNUICallback("appearance_delete_outfit", function(data, cb)
    if not data or not data.id then
        cb({ success = false })
        return
    end
    TriggerServerEvent("illenium-appearance:server:deleteOutfit", data.id)
    Wait(250)
    local updated = lib.callback.await("illenium-appearance:server:getOutfits", false) or {}
    cb({ success = true, outfits = updated })
end)
