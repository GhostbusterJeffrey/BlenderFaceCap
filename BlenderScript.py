import bpy
import time
import math
import json
from pathlib import Path

pathvar = "/Users/jeffreybrown/BlenderStuff/Loose Blends/animdata.json"
f = Path(bpy.path.abspath(pathvar))

datafile = f.read_text()
    
json_data = json.loads(datafile)

crig = bpy.data.objects["Lenny Rig"]

lefteye = crig.pose.bones["LeftEye"]
righteye = crig.pose.bones["RightEye"]

betterMouth = bpy.data.objects["Lenny Mouth.001"]

leftBlinkValues = json_data["leftBlinkValues"]
rightBlinkValues = json_data["rightBlinkValues"]

eyeSquintLeftValues = json_data["eyeSquintLeftValues"]
eyeSquintRightValues = json_data["eyeSquintRightValues"]

jawOpenValues = json_data["jawOpenValues"]
mouthFunnelValues = json_data["mouthFunnelValues"]
mouthPuckerValues = json_data["mouthPuckerValues"]
mouthSmileLeftValues = json_data["mouthSmileLeftValues"]
mouthSmileRightValues = json_data["mouthSmileRightValues"]
mouthFrownLeftValues = json_data["mouthFrownLeftValues"]
mouthFrownRightValues = json_data["mouthFrownRightValues"]
mouthUpperUpLeftValues = json_data["mouthUpperUpLeftValues"]
mouthUpperUpRightValues = json_data["mouthUpperUpRightValues"]
mouthLowerDownLeftValues = json_data["mouthLowerDownLeftValues"]
mouthLowerDownRightValues = json_data["mouthLowerDownRightValues"]
mouthPressLeftValues = json_data["mouthPressLeftValues"]
mouthPressRightValues = json_data["mouthPressRightValues"]
mouthShrugUpperValues = json_data["mouthShrugUpperValues"]
mouthShrugLowerValues = json_data["mouthShrugLowerValues"]
mouthRollUpperValues = json_data["mouthRollUpperValues"]
mouthRollLowerValues = json_data["mouthRollLowerValues"]
mouthStretchLeftValues = json_data["mouthStretchLeftValues"]
mouthStretchRightValues = json_data["mouthStretchRightValues"]
mouthDimpleLeftValues = json_data["mouthDimpleLeftValues"]
mouthDimpleRightValues = json_data["mouthDimpleRightValues"]
mouthLeftValues = json_data["mouthLeftValues"]
mouthRightValues = json_data["mouthRightValues"]

facecapframes = len(eyeSquintLeftValues)

blendShapes = ["jawOpen","mouthFunnel","mouthPucker","mouthSmileLeft","mouthSmileRight","mouthFrownLeft","mouthFrownRight","mouthUpperUpLeft","mouthUpperUpRight","mouthLowerDownLeft","mouthLowerDownRight","mouthLeft","mouthRight","mouthStretchLeft","mouthStretchRight","mouthRollLower","mouthRollUpper"]
blendShapeIndex = [jawOpenValues,mouthFunnelValues,mouthPuckerValues,mouthSmileLeftValues,mouthSmileRightValues,mouthFrownLeftValues,mouthFrownRightValues,mouthUpperUpLeftValues,mouthUpperUpRightValues,mouthLowerDownLeftValues,mouthLowerDownRightValues,mouthLeftValues,mouthRightValues,mouthStretchLeftValues,mouthStretchRightValues,mouthRollLowerValues,mouthRollUpperValues]

def insert_keyframes():
    # Blink values
    crig.keyframe_insert(data_path = "pose.bones[\"LeftEye\"][\"blink\"]")
    crig.keyframe_insert(data_path = "pose.bones[\"RightEye\"][\"blink\"]")
    
    crig.keyframe_insert(data_path = "pose.bones[\"LeftEye\"][\"lo squint\"]")
    crig.keyframe_insert(data_path = "pose.bones[\"LeftEye\"][\"up squint\"]")
    
    crig.keyframe_insert(data_path = "pose.bones[\"RightEye\"][\"lo squint\"]")
    crig.keyframe_insert(data_path = "pose.bones[\"RightEye\"][\"up squint\"]")
    
    for i in range(len(blendShapes)):
        betterMouth.data.shape_keys.key_blocks[blendShapes[i]].keyframe_insert(data_path="value")
    
def squint(i, l, r):
    if eyeSquintLeftValues[i] < 0.4 or eyeSquintRightValues[i] < 0.4 and l[i] < 0.5 and r[i] < 0.5:
        try:
            if eyeSquintLeftValues[i+1] > 0.4 or eyeSquintRightValues[i+1] > 0.4 or eyeSquintLeftValues[i+2] < 0.4 or eyeSquintRightValues[i+2] < 0.4:
                multiplier = 1
            else:
                multiplier = 0.5
        except:
            multiplier = 1
    elif l[i] > 0.4 and r[i] > 0.4:
        multiplier = 0.1
    else:
        multiplier = 2
    
    if eyeSquintLeftValues[i] > 0:
        lefteye["lo squint"] = eyeSquintLeftValues[i] * multiplier
        lefteye["up squint"] = eyeSquintLeftValues[i] * multiplier
    else:
        lefteye["lo squint"] = 0.000
        lefteye["up squint"] = 0.000
    if eyeSquintRightValues[i] > 0:
        righteye["lo squint"] = eyeSquintRightValues[i] * multiplier
        righteye["up squint"] = eyeSquintRightValues[i] * multiplier
    else:
        righteye["lo squint"] = 0.000
        righteye["up squint"] = 0.000
        
def actualMouthSetup(i):
    for g in range(len(blendShapes)):
        betterMouth.data.shape_keys.key_blocks[blendShapes[g]].value = blendShapeIndex[g][i]
    
        
startFrame = bpy.data.scenes[0].frame_current

for i in range(facecapframes):
    if leftBlinkValues[i] > 0.3:
        lefteye["blink"] = leftBlinkValues[i]
    else:
        lefteye["blink"] = 0.000
        
    if rightBlinkValues[i] > 0.3:
        righteye["blink"] = rightBlinkValues[i]
    else:
        righteye["blink"] = 0.000

    squint(i, leftBlinkValues, rightBlinkValues)

    actualMouthSetup(i)
    
    insert_keyframes()
    
    bpy.context.scene.frame_set(bpy.data.scenes[0].frame_current + 1)

bpy.context.scene.frame_set(startFrame)
