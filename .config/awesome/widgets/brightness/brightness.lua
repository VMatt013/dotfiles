local wibox = require("wibox")
local beautiful = require('beautiful')
local gears = require("gears")

local ICON_DIR = os.getenv("HOME") .. '/.config/awesome/widgets/volume-widget/icons/'

local widget = {}

function widget.get_widget(widgets_args)
    local args = widgets_args or {}

    local main_color = args.main_color or beautiful.fg_normal
    local mute_color = "#c41d2b" or args.mute_color or beautiful.fg_urgent
    local bg_color = args.bg_color or '#ffffff11'
    local width = args.width or 10
    local margins = args.height or 2
    local shape = args.shape or 'bar'
    local with_icon = args.with_icon == true and true or false


    local bar = wibox.widget {
        {
            {
                id = "icon",
                --image = ICON_DIR .. 'audio-volume-high-symbolic.svg',
                resize = false,
                widget = wibox.widget.imagebox,                                                                                    
            },                                                                                                                     
            valign = 'center',                                                                                                     
            visible = with_icon,                                                                                                   
            layout = wibox.container.place,                                                                                        
        },                                                                                                                         
        {                                                                                                                          
            {                                                                                                                      
                id = 'bar',                                                                                                        
                max_value = 100,
		min_value = 1,
                forced_width = width,                                                                                              
                forced_height = 5,                                                                                                 
                margins = { top = margins, bottom = margins },                                                                     
                color = main_color,                                                                                                
                background_color = bg_color,                                                                                       
                shape = gears.shape[shape],                                                                                        
                widget = wibox.widget.progressbar,                                                                                 
            },                                                                                                                     
            forced_width = width,                                                                                                  
            direction = 'east',                                                                                                    
            layout = wibox.container.rotate,                                                                                       
        },                                                                                                                         
        spacing = 4,                                                                                                               
        layout = wibox.layout.fixed.horizontal,                                                                                    
        set_volume_level = function(self, new_value)                                                                               
            self:get_children_by_id('bar')[1]:set_value(tonumber(new_value))                                                       
        end,                                                                                                                       
        mute = function(self)                                                                                                      
            self:get_children_by_id('bar')[1]:set_color(mute_color)                                                                
        end,                                                                                                                       
        unmute = function(self)                                                                                                    
            self:get_children_by_id('bar')[1]:set_color(main_color)
        end
    }

    return bar
end

volume.widget:buttons(
            awful.util.table.join(
                    awful.button({}, 1, function() volume:toggle() end),
                    awful.button({}, 2, function() volume:mixer() end),
                    awful.button({}, 3, function() volume:popup() end),
                    awful.button({}, 4, function() volume:inc() end),
                    awful.button({}, 5, function() volume:dec() end)
            )
    )
