# BlenderFaceCap
Blender Facial Capture utilizing the TrueDepth camera on the iPhone

# Use Guide for iPhone
Open up the app and you will see two buttons and a view of the front facing camera. Pressing "Take Snapshot" will save a single frame of animation data. Pressing "Start Record" will begin recording animation data. The data recorded will always be saved at 30fps. Press "End Record" to stop recording. The animation data will be saved in a file named "animdata.json" which can be accessed in the Files app. Send this file to your computer to import into Blender.

# Use Guide for Blender
Open up Blender and go to the "Scripting" tab. Click "Open" and select the downloaded copy of "BlenderScript.py". Make sure the following variables are set correctly.

pathvar - Set this to an ABSOLUTE path of where your animdata.json file is. Make sure it looks like "C:\Users\user\animdata.json" and not "/animdata.json"
crig - Set this to the object name of the character your are using the Facial Capture with. Keep in mind at the moment the eye capture only works on 2000s rigs, but the mouth works for any rig.
betterMouth - Set this to the object name of your character's mouth; MAKE SURE THE OBJECT DATA OF THAT MOUTH IS LINKED TO THE CUSTOM FACECAP MOUTH

Once you've set the following variables, set your frame in the timeline to the first frame of your capture data. Click the "Run Script" button at the top of the scripting window. Afterwards, you should be all set!
