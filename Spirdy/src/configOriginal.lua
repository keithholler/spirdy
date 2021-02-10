
-- calculate device aspect ratio
local aspectRatio = display.pixelHeight / display.pixelWidth
system.getInfo("model")

application = {
   content = {
   
      width = aspectRatio > 1.5 and 400 or math.ceil( 600 / aspectRatio ),
      height = aspectRatio < 1.5 and 600 or math.ceil( 400 * aspectRatio ), 
      scale = "letterbox",
      fps = 60,
	  
      
      -- image size would be 400x600, 800x1200, and 1600x2400
        imageSuffix = {
          ["@2x"] = 1.3,
          ["@4x"] = 3.0,
      }
   },
}

print( aspectRatio, application.content.width, application.content.height )

