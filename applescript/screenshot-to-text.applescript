-- Loads macOS UI and Vision frameworks along with utility classes
use framework "AppKit"
use framework "Foundation"
use framework "Vision"
use scripting additions

-- Initiate a screen capture
do shell script "screencapture -c -i -s"

-- Get image data from the clipboard
set imgData to ""
try
    set thePasteboard to current application's NSPasteboard's generalPasteboard()
    set imgData to thePasteboard's dataForType:(current application's NSPasteboardTypeTIFF)
end try

-- Initially, assume we haven't captured anything meaningful
set captured to false
try
    -- As long as 'something' was captured on the clipboard
    if imgData is not "" then
        -- Use Vision to process that image
        set requestHandler to current application's VNImageRequestHandler's alloc()'s initWithData:imgData options:(missing value)
        -- Perform the text recognition
        set textRequest to current application's VNRecognizeTextRequest's alloc()'s init()
        -- Save the recognized text
        requestHandler's performRequests:(current application's NSArray's arrayWithObject:textRequest) |error|:(missing value)

        -- Decipher each string from the recognized text and build lines of text onto textLines
        set textLines to current application's NSMutableArray's new()
        repeat with aResult in (textRequest's results())
            (textLines's addObject:(((aResult's topCandidates:1)'s objectAtIndex:0)'s |string|()))
        end repeat

        -- Join each string with a new line character and add the entire text to clipboard
        set the clipboard to ((textLines's componentsJoinedByString:linefeed) as text)
        -- By now, we have certainty that meaningful text was captured
        set captured to true
    end if
end try

-- Throw an error/alert if nothing meaningful was captured
if captured is false then
    display alert "Failed" message "Please select a valid screen region before attempting to retrieve text."
end if