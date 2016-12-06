display.setDefault( "background", 0.9, 0.9, 0.9, 1 )
------------------------------------------------------------
local numpad = nil
local stage = display.getCurrentStage()
local function eventWithinBounds(obj, event)
   local bounds = obj.contentBounds
   local x, y = event.x, event.y
        
   if ((x >= bounds.xMin) and (x <= bounds.xMax) and (y >= bounds.yMin) and (y <= bounds.yMax)) then
      return true
   end
    
   return false   
end
local function typeTextbox(event, textlabel)
	local phase = event.phase
	local button = event.target

	if phase == "began" then
		stage:setFocus(button)
		button.isButtonPressed = true
		button.alpha = 0.5
	elseif phase == "moved" then
		if eventWithinBounds(button, event) then
			button.isButtonPressed = true
			button.alpha = 0.5
		else 
			button.isButtonPressed = false
			button.alpha = 0.01
		end 
	elseif phase == "ended" then 
		stage:setFocus(nil)
		button.alpha = 0.01
		if button.isButtonPressed then
        	button.isButtonPressed = false

        	local keyid = button.id
        	local extext = textlabel.text
        	print( "Key ID: "..keyid, "Ex Text: "..extext )
        	--
        	--
        	--
  			if (keyid == "d") then
				local extextlen = extext:len()
				textlabel.text = extext:sub(1 , extextlen-1)
				if(textlabel.text == "") then textlabel.text = "0" end
			elseif (keyid == ",") then
				if (extext:find("[.]") == nil) then
					textlabel.text = textlabel.text.."."
				end
			elseif (keyid == "0") then
				if not (extext == "0") then
					textlabel.text = textlabel.text..keyid
				end
			else
				if(extext == "0") then textlabel.text = "" end
				textlabel.text = textlabel.text..keyid
			end
        	--
        	--
        	--
        end
	end
	return true
end
local function registerEvents(x, y, w, h, textlabel)

	local kh = h*0.25
	local kw = w*0.33	
	local ky = y - 3*kh
	local kx = x - kw

	local keys = display.newGroup()
	local numkeys = {"1","2","3","4","5","6","7","8","9",",","0","d"}
	local row = 1
	local col = 0
	for i,v in ipairs(numkeys) do
		col = col + 1
		if (i == 4 or i == 7 or i == 10) then
			row = row + 1
			col = 1
		end
		local key = display.newRect( keys, (col - 1)*kw + kx, (row - 1)*kh + ky, kw, kh )
		key.id = v
		key.anchorY = 1
		key:setFillColor(0.2,0.2,0.2,0.3)
		key.alpha = 0.01
		key:addEventListener( "touch", function(event) typeTextbox(event, textlabel) end )
		print(i,v)
	end
	numpad.keys = keys
	numpad:insert( numpad.keys )
	numpad.keysbg:addEventListener("touch", function(event)
		if ( event.phase == "ended" ) then
			print("write key..")
			return true
		end
	end)

	numpad.modal:addEventListener("touch", function(event)
		if ( event.phase == "ended" ) then
			numpad.modal:removeSelf()
			numpad.modal = nil

			numpad.keys:removeSelf()
			numpad.keys = nil

			transition.to( numpad.keysbg, {time = 250, y = numpad.keysbg.y0, onComplete = function()
				numpad:removeSelf()
				numpad = nil
			end, })
			
			return true
		end
	end)
end
local function showNumpad(textlabel)
	numpad = display.newGroup()

	local centerx = display.contentCenterX
	local centery = display.contentCenterY
	local contentw = display.contentWidth
	local contenth = display.contentHeight
	local actualHeight = display.actualContentHeight
	local actualWidth = display.actualContentWidth

	local modal = display.newRect( centerx, centery, contentw*2, actualHeight )
	modal:setFillColor( 1, 1, 1, 0.15 )
	numpad.modal = modal
	numpad:insert( numpad.modal )

	local w,h = actualWidth, actualWidth * 0.75
	local keysbg = display.newImageRect( "1000x800_numpad.png", w, h )
	keysbg.x, keysbg.y, keysbg.y1 = centerx, 2*centery + h, centery + actualHeight*0.5
	keysbg.y0 = keysbg.y
	keysbg.anchorY = 1
	numpad.keysbg = keysbg
	numpad:insert( numpad.keysbg )

	transition.to( numpad.keysbg, {time = 300, y = numpad.keysbg.y1, onComplete = function(obj)
		registerEvents(numpad.keysbg.x, numpad.keysbg.y1, w, h, textlabel) end, })
end

local x,y = display.contentCenterX, display.contentWidth * 0.25
local w,h = display.contentWidth * 0.8, 40
local tx = x + w*0.5 - 15

local myTextbox = display.newImageRect( "textbox.png", w, h )
myTextbox.x, myTextbox.y = x,y

local textlabel = display.newText( "0", tx, y, native.systemFontBold, 18 )
textlabel.anchorX = 1
textlabel:setFillColor( 0,0,0 )

myTextbox:addEventListener( "touch", function(event)
	if ( event.phase == "ended" ) then
		if (numpad == nil) then
			showNumpad(textlabel)
		end
	end
end)


local myTextbox2 = display.newImageRect( "textbox.png", w, h )
myTextbox2.x, myTextbox2.y = x,y+60

local textlabel2 = display.newText( "0", tx, y+60, native.systemFontBold, 18 )
textlabel2.anchorX = 1
textlabel2:setFillColor( 0,0,0 )

myTextbox2:addEventListener( "touch", function(event)
	if ( event.phase == "ended" ) then
		if (numpad == nil) then
			showNumpad(textlabel2)
		end
	end
end)


