EventLayerName = "Events"

GreyColor = Color{ r=212, g=211, b=211, a=255 }
RedColor = Color{ r=255, g=0, b=0, a=255 }
BlackColor = Color{ r=255, g=255, b=255, a=255 }
DefaultColor = Color{ r=255, g=255, b=255, a=0 }

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function OnSelectCel(ev)
    if(ev.fromUndo) then
        return
    end
    if app.site.cel == nil then
        if app.site.layer.name == EventLayerName then
            app.sprite:newCel(app.site.layer, app.site.frameNumber)
            if app.site.cel ~= nil then
                app.site.cel.data = ""
            end
        end
    end
    DoCel(app.site.cel)
end

function DoCel(cel)
    if cel == nil then
        return
    end
    if cel.data == ""  then
        cel.color = DefaultColor
    else
        if string.starts(cel.data, "event:@") == false then
            cel.data = "event:@" .. cel.data
        end
        cel.color = RedColor
    end
end


PreviousSprite = nil
app.events:on('sitechange',
        function()
            if PreviousSprite ~= app.sprite then
                --print("new")
                if PreviousSprite ~= nil then
                    PreviousSprite.events:off(OnSelectCel)
                end
                PreviousSprite = app.sprite
                if app.sprite ~= nil then
                    local layerTo = nil
                    for i,layer in ipairs(app.sprite.layers) do
                        if layer.name == EventLayerName then
                            layerTo = layer
                            layer.isEditable = true
                            layer.isVisible = false
                        end
                    end
                    if layerTo ~= nil then
                        for i,frame in ipairs(app.sprite.frames) do
                            app.sprite:newCel(layerTo, i)
                        end
                    end
                    app.sprite.events:on('change', OnSelectCel)
                end

            end


        end)



