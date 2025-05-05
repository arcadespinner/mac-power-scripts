-- Initiate a screen capture and save to clipboard
do shell script "screencapture -c -i -s"

-- Get data from the clipboard
set imgData to ""
try
	set imgData to the clipboard as JPEG picture
 end try

 -- As long as 'something' was captured
 if imgData is not "" then
 	-- Set the folder path to 'desktop' to store new screenshots
	set screenshotDir to path to desktop folder as text

 -- Name of each new screenshot will be a timestamp
 set filePath to screenshotDir & (do shell script "date +%Y-%m-%d-%H-%M-%S-%N.jpg")

 -- Write the image data to the file
 set newFile to open for access filePath with write permission
 write imgData to newFile
 close access newFile
end if
